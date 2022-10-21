//
//  TableViewController.swift
//  Example
//
//  Created by Oleksandr Kurtsev on 21/10/2022.
//

import UIKit
import StackViewController

final class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = StackUITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(indexPath)"
        cell.selectionStyle = .none
        return cell
    }
}
