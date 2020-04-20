//
//  InsetGroupedTableViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class InsetGroupedTableViewController: ViewController {
    
    // MARK: - Internal Properties
    
    var subtitle: String? {
        didSet { subtitleLabel.text = subtitle }
    }
    
    var tableHeaderViewFont: UIFont =
        UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold) {
        didSet { subtitleLabel.font = tableHeaderViewFont }
    }
    
    var tableHeaderViewBottomInset: CGFloat = 16.0
    
    let tableViewCellID = "TableViewCellReuseIdentifier"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.tableHeaderView = containerView
        tableView.separatorStyle = .none
        tableView.backgroundColor = view.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = tableHeaderViewFont
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        containerView.addSubview(subtitleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        let headerViewWidth = view.frame.width - (view.layoutMargins.left + view.layoutMargins.right)
        let headerViewHeight = heightForView(text: subtitle ?? "", width: headerViewWidth)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: headerViewHeight + tableHeaderViewBottomInset),
            
            subtitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        sizeHeaderToFit(tableView: tableView)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func heightForView(text: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = tableHeaderViewFont
        label.text = text
        label.sizeToFit()

        return label.frame.height
    }
    
    fileprivate func sizeHeaderToFit(tableView: UITableView) {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    // MARK: - Internal Methods
    
    func deselectTableViewRow() -> Void {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func rowIsLast(for indexPath: IndexPath) -> Bool {
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        return (indexPath.row == totalRows - 1)
    }
    
    func animateReloadAllRows() {
        var indexPaths: [IndexPath] = []

        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                indexPaths.append(IndexPath(row: j, section: i))
            }
        }
        
        tableView.reloadRows(at: indexPaths, with: .fade)
    }
}
