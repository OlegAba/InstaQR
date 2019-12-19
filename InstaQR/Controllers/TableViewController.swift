//
//  TableViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

// TODO: Change name to InsetGroupedTableViewController

class TableViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var subtitle: String? {
        didSet {
            subtitleLabelHeaderView.text = subtitle
        }
    }
    
    var tableHeaderViewBottomInset: CGFloat {
        get { return 16.0 }
    }
    
    let tableViewCellID = "TableViewCellReuseIdentifier"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.tableHeaderView = subtitleLabelHeaderView
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Private Properties
    
    fileprivate lazy var subtitleLabelHeaderView: SubtitleLabelHeaderView = {
        let subtitleLabelHeaderView = SubtitleLabelHeaderView()
        subtitleLabelHeaderView.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        subtitleLabelHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabelHeaderView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        let headerViewWidth = view.frame.width - (view.layoutMargins.left + view.layoutMargins.right)
        let headerViewHeight = subtitleLabelHeaderView.heightForView(text: subtitle ?? "", width: headerViewWidth)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            subtitleLabelHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            subtitleLabelHeaderView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            subtitleLabelHeaderView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            subtitleLabelHeaderView.heightAnchor.constraint(equalToConstant: headerViewHeight + tableHeaderViewBottomInset)
        ])
        
        sizeHeaderToFit(tableView: tableView)
    }
    
    
    // MARK: - Private Methods
    
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

