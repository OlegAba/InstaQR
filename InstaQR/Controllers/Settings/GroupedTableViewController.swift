//
//  GroupedTableViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 4/20/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class GroupedTableViewController: InsetGroupedTableViewController {
    
    fileprivate lazy var groupedTableView: UITableView = {
        let newTableView = UITableView(frame: .zero, style: .grouped)
        newTableView.tableHeaderView = containerView
        newTableView.separatorColor = .none
        newTableView.backgroundColor = view.backgroundColor
        newTableView.translatesAutoresizingMaskIntoConstraints = false
        return newTableView
    }()
    
    override var tableView: UITableView {
        get { return groupedTableView }
        set { groupedTableView = newValue }
    }
    
}
