//
//  SettingsViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class SettingsViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Settings"
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonWasTapped))
        navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = 50.0
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc fileprivate func cancelButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// TODO: Seperate Delegate and Datasource extensions

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section{
        case .Help: return HelpItem.allCases.count
        case .General: return GeneralItem.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionTitleLabelHeaderView()
        header.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        
        guard let section = SettingsSection(rawValue: section) else { return header }
        
        switch section{
        case .Help:
            header.text = SettingsSection.Help.description
        case .General:
            header.text = SettingsSection.General.description
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as? BaseTableViewCell else { return UITableViewCell() }
        
        cell.isLast = rowIsLast(for: indexPath)
        cell.backgroundColor = .tableViewCellBackgroundColor
        cell.iconImage = UIImage(systemName: "chevron.right")
        cell.logoImageView.tintColor = .systemBlue
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell }
        
        switch section {
        case .Help:
            guard let helpItem = HelpItem(rawValue: indexPath.row) else { return cell }
            cell.title = helpItem.description
            cell.logoImage = helpItem.logoImage
        case .General:
            
            guard let generalItem = GeneralItem(rawValue: indexPath.row) else { return cell }
            cell.title = generalItem.description
            cell.logoImage = generalItem.logoImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectTableViewRow()
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        var selectedController: UIViewController?
        
        switch section {
        case .Help:
            guard let helpItem = HelpItem(rawValue: indexPath.row) else { return }
            
            switch helpItem {
            case .faq:
                selectedController = FAQViewController()
            case .liveWallpaper:
                let containerPageViewController = ContainerPageViewController()
                containerPageViewController.pageSections = wallpaperGuidePageSections
                selectedController = containerPageViewController
            case .onBoarding:
                let containerPageViewController = ContainerPageViewController()
                containerPageViewController.pageSections = onBoardingPageSections
                selectedController = containerPageViewController
            }
            
            selectedController?.title = helpItem.description
            
        case .General:
            guard let generalItem = GeneralItem(rawValue: indexPath.row) else { return }
            
            switch generalItem {
            case .rate:
                print("NOT IMPLEMENTED")
            case .share:
                print("NOT IMPLEMENTED")
            case .licenses:
                print("NOT IMPLEMENTED")
            case .privacyPolicy:
                print("NOT IMPLEMENTED")
            }
        }
        
        if let viewController = selectedController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
