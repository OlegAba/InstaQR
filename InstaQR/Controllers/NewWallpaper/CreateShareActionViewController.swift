//
//  CreateShareActionDelegate.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

protocol CreateShareActionDelegate {
    func createShareAction(_ createShareActionViewController: CreateShareActionViewController, didSelectBarcodeType barcodeType: Barcode.BarcodeType, withPrefilledInput prefilledInput: String?)
}

class CreateShareActionViewController: TableViewController {
    
    // MARK: - Internal Properties
    
    var delegate: CreateShareActionDelegate!
    
    override var tableHeaderViewBottomInset: CGFloat {
        get { return 32.0 }
    }
    
    // MARK: - Private Properties
    
    fileprivate let barcodeCategoryTypes = [BarcodeCategory.barcodeTypesFor(barcodeCategoryType: .social),
                                BarcodeCategory.barcodeTypesFor(barcodeCategoryType: .payment),
                                BarcodeCategory.barcodeTypesFor(barcodeCategoryType: .standard)]
    fileprivate let barcodeCategoryTitles = [BarcodeCategory.titleFor(barcodeCategoryType: .social),
                                 BarcodeCategory.titleFor(barcodeCategoryType: .payment),
                                 BarcodeCategory.titleFor(barcodeCategoryType: .standard)]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Setup
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Share Action"
        let qrScanIconImage = UIImage(systemName: "qrcode.viewfinder")
        let qrScanBarButtonItem = UIBarButtonItem(image: qrScanIconImage, style: .plain, target: self, action: #selector(qrScanButtonWasTapped))
        navigationItem.rightBarButtonItem = qrScanBarButtonItem
    }
    
    fileprivate func setupTableView() {
        subtitle = "Set up a share action that will be triggered when your wallpaper is scanned."
        tableView.rowHeight = 50.0
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc fileprivate func qrScanButtonWasTapped() {
        let barcodeScannerViewController = BarcodeScannerViewController()
        barcodeScannerViewController.delegate = self
        present(barcodeScannerViewController, animated: true, completion: nil)
    }
}

// TODO: Seperate Delegate and Datasource extensions

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CreateShareActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return barcodeCategoryTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeCategoryTypes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as? BaseTableViewCell else { return UITableViewCell() }
        
        cell.isLast = rowIsLast(for: indexPath)
        
        let barcodeType = self.barcodeCategoryTypes[indexPath.section][indexPath.row]
        cell.title = Barcode.titleFor(barcodeType: barcodeType)
        cell.logoImageBackgroundColor = Barcode.primaryColorFor(barcodeType: barcodeType)
        cell.iconImage = UIImage(systemName: "chevron.right")
        
        DispatchQueue.global(qos: .background).async {
            guard let logo = Barcode.logoImageFor(barcodeType: barcodeType) else { return }
            
            DispatchQueue.main.async {
                cell.logoImage = logo
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectTableViewRow()
        
        let barcodeType = barcodeCategoryTypes[indexPath.section][indexPath.row]
        delegate.createShareAction(self, didSelectBarcodeType: barcodeType, withPrefilledInput: nil)
    }
}

// MARK: - BarcodeScannerDelegate
extension CreateShareActionViewController: BarcodeScannerDelegate {
    
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
        barcodeScannerViewController.success()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            barcodeScannerViewController.dismiss(animated: true) {
                
                let customBarcodeType = Barcode.BarcodeType.custom
                self.delegate.createShareAction(self, didSelectBarcodeType: customBarcodeType, withPrefilledInput: codeData)
            }
        }
    }
}
