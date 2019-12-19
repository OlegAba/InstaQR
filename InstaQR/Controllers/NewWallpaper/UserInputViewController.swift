//
//  UserInputViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

protocol UserInputDelegate {
    func userInput(_ userInputViewController: UserInputViewController, didCreateBarcode barcode: Barcode, withBarcodeInput barcodeInput: BarcodeInput)
}

class UserInputViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var delegate: UserInputDelegate!
    var barcode: Barcode!
    var barcodeInput: BarcodeInput!
    
    // MARK: - Private Properties
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = barcodeInput?.instructions
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topContainerView, bottomContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = view.layoutMargins.left
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate lazy var topContainerView: UIView = {
        let view = UIView()
        view.addSubview(inputTextField)
        return view
    }()
    
    fileprivate lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.addSubview(createPrimaryButton)
        return view
    }()
    
    fileprivate lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.placeholder = barcodeInput?.placeholder
        textField.text = barcode.userInputs[barcodeInput.key]
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .alphabet
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    fileprivate lazy var createPrimaryButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Create", for: .normal)
        button.addTarget(self, action: #selector(createButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate var keyboardHeight: CGFloat = 0
    
    fileprivate lazy var hiddenKeyboardStackViewConstraint: NSLayoutConstraint = {
        return stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }()
    
    fileprivate lazy var shownKeyboardStackViewConstraint: NSLayoutConstraint = {
        return stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight)
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputTextField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        
        if barcodeInput.barcodeScanEnabled {
            let qrScanBarButtonItem = UIBarButtonItem(image: .scanQRIcon, style: .plain, target: self, action: #selector(qrScanButtonWasTapped))
            navigationItem.rightBarButtonItem = qrScanBarButtonItem
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        hiddenKeyboardStackViewConstraint.isActive = true
    }
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (view.layoutMargins.left * 1.5)),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            inputTextField.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            inputTextField.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            
            createPrimaryButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            createPrimaryButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            createPrimaryButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -view.layoutMargins.left)
        ])
    }
    
    // MARK: - Actions
    
    @objc fileprivate func qrScanButtonWasTapped() {
        presentBarcodeScannerViewController()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardControl(notification, isShowing: true)
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.keyboardControl(notification, isShowing: false)
    }
    
    @objc fileprivate func createButtonWasTapped() {
        guard let inputText = inputTextField.text else { return }
        let (isValid, errorMessage) = barcode.userInputValidationFor(data: inputText, inputKeyType: barcodeInput.key)
        
        if isValid {
            barcode.userInputs[barcodeInput.key] = inputText
            delegate.userInput(self, didCreateBarcode: barcode, withBarcodeInput: barcodeInput)
        } else {
            if let errorMessage = errorMessage {
                System.shared.appDelegate().newWallpaperNavigationController?.presentError(with: errorMessage)
            }
        }
    }

    // MARK: - Private Methods
    
    fileprivate func presentBarcodeScannerViewController() {
        let barcodeScannerViewController = BarcodeScannerViewController()
        barcodeScannerViewController.instructionText = "Scan \(barcode.title ?? "") Barcode"
        barcodeScannerViewController.delegate = self
        present(barcodeScannerViewController, animated: true, completion: nil)
    }

    fileprivate func keyboardControl(_ notification: Notification, isShowing: Bool) {

        let userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue ?? 0.5
        
        keyboardHeight = keyboardRect?.height ?? 0
        
        if isShowing {
            hiddenKeyboardStackViewConstraint.isActive = false
            shownKeyboardStackViewConstraint.isActive = true
        } else {
            shownKeyboardStackViewConstraint.isActive = false
            hiddenKeyboardStackViewConstraint.isActive = true
        }


        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
        }, completion: { _ in

        })
    }
}

// MARK: - UITextFieldDelegate
extension UserInputViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(string == " ")
    }
}

// MARK: - BarcodeScannerDelegate
extension UserInputViewController: BarcodeScannerDelegate {
    
    func barcodeScannerShouldDismiss(_ barcodeScannerViewController: BarcodeScannerViewController, error: Bool) {
        DispatchQueue.main.async {
            barcodeScannerViewController.dismiss(animated: true) {
                
                if error {
                    System.shared.appDelegate().newWallpaperNavigationController?.presentError(with: "There was an error scanning your barcode. Please try again.")
                }
            }
        }
    }
    
    func barcodeScannerCodeFound(_ barcodeScannerViewController: BarcodeScannerViewController, codeData: String) {
        
        let (isValid, _) = barcode.userInputValidationFor(data: codeData, inputKeyType: barcodeInput.key)
        
        if isValid {
            inputTextField.text = codeData
            barcodeScannerViewController.success()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                barcodeScannerViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
