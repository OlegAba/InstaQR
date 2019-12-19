//
//  FAQViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class FAQViewController: InsetGroupedTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    fileprivate func setupNavigationBar() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonWasTapped))
        navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    fileprivate func setupTableView() {
        tableHeaderViewBottomInset = tableHeaderViewBottomInset * 2.0
        tableView.rowHeight = 75.0
        tableView.register(TableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc fileprivate func cancelButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// TODO: Seperate Delegate and Datasource extensions

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.isLast = rowIsLast(for: indexPath)
        cell.backgroundColor = .tableViewCellBackgroundColor
        cell.iconImage = UIImage(systemName: "chevron.right")
        
        let currentFAQ = FAQSection[indexPath.row]
        cell.title = currentFAQ.question
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectTableViewRow()
        let selectedFAQ = FAQSection[indexPath.row]
        let answerViewController = AnswersViewController()
        answerViewController.question = selectedFAQ.question
        answerViewController.answer = selectedFAQ.answer
        navigationController?.pushViewController(answerViewController, animated: true)
    }
}
