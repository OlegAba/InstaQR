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

class CreateShareActionViewController: InsetGroupedTableViewController {
    
    // MARK: - Internal Properties
    
    var delegate: CreateShareActionDelegate!
    
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
        let qrScanBarButtonItem = UIBarButtonItem(image: .scanQRIcon, style: .plain, target: self, action: #selector(qrScanButtonWasTapped))
        navigationItem.rightBarButtonItem = qrScanBarButtonItem
    }
    
    fileprivate func setupTableView() {
        subtitle = "Create or enter a share action link that will be opened when your wallpaper is scanned."
        tableHeaderViewBottomInset = tableHeaderViewBottomInset * 2.0
        tableView.rowHeight = 50.0
        tableView.register(TableViewCell.self, forCellReuseIdentifier: tableViewCellID)
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

// MARK: - UITableViewDelegate
extension CreateShareActionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectTableViewRow()
        
        let barcodeType = barcodeCategoryTypes[indexPath.section][indexPath.row]
        delegate.createShareAction(self, didSelectBarcodeType: barcodeType, withPrefilledInput: nil)
    }
}

// MARK: - UITableViewDataSource
extension CreateShareActionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return barcodeCategoryTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeCategoryTypes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.isLast = rowIsLast(for: indexPath)
        
        let barcodeType = self.barcodeCategoryTypes[indexPath.section][indexPath.row]
        cell.title = Barcode.titleFor(barcodeType: barcodeType)
        cell.logoImageBackgroundColor = Barcode.primaryColorFor(barcodeType: barcodeType)
        cell.iconImage = UIImage(systemName: "chevron.right")
        
        DispatchQueue.global(qos: .background).async {
            guard let logo = Barcode.iconImageFor(barcodeType: barcodeType) else { return }
            
            DispatchQueue.main.async {
                cell.logoImage = logo
            }
        }
        
        return cell
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
