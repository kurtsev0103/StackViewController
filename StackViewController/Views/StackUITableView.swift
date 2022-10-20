//
//  StackUITableView.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 20/10/2022.
//

import UIKit

final public class StackUITableView: UITableView {
    
    // MARK: - Properties
    
    public var splitDelegate = TableViewSplitDelegate()
    
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        didSet { splitDelegate.scrollViewDelegate = scrollViewDelegate }
    }
    
    override public var delegate: UITableViewDelegate? {
        didSet {
            if delegate is TableViewSplitDelegate { return }
            splitDelegate.tableViewDelegate = delegate
            self.delegate = splitDelegate
        }
    }
}
