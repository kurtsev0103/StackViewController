//
//  TableViewSplitDelegate.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

public class TableViewSplitDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    weak var tableViewDelegate: UITableViewDelegate?
    weak var scrollViewDelegate: UIScrollViewDelegate?
    
    // MARK: - Override Methods
    
    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if selectorIsPartOfUIScrollViewDelegate(selector: aSelector) {
            return scrollViewDelegate
        }
        
        if selectorIsPartOfUITableViewDelegate(selector: aSelector) {
            return tableViewDelegate
        }
        
        return nil
    }
    
    override public func responds(to aSelector: Selector) -> Bool {
        guard let target = forwardingTarget(for: aSelector) as AnyObject? else {
            return super.responds(to: aSelector)
        }
        
        if target === scrollViewDelegate {
            return target.responds(to: aSelector)
        } else if target === tableViewDelegate {
            return target.responds(to: aSelector)
        } else {
            return super.responds(to: aSelector)
        }
    }
    
    // MARK: - Private Methods
    
    private func selectorIsPartOfUITableViewDelegate(selector aSelector: Selector) -> Bool {
        return isInstanceMethodForProtocol(selector: aSelector, protocol: UITableViewDelegate.self)
    }
    
    private func selectorIsPartOfUIScrollViewDelegate(selector aSelector: Selector) -> Bool {
        return isInstanceMethodForProtocol(selector: aSelector, protocol: UIScrollViewDelegate.self)
    }
    
    private func isInstanceMethodForProtocol(selector: Selector, `protocol`: Protocol) -> Bool {
        return isInstanceMethodForProtocol(selector: selector, protocol: `protocol`, isRequired: true) ||
        isInstanceMethodForProtocol(selector: selector, protocol: `protocol`, isRequired: false)
    }
    
    private func isInstanceMethodForProtocol(selector: Selector, `protocol`: Protocol, isRequired: Bool) -> Bool {
        let methodDesc = protocol_getMethodDescription(`protocol`, selector, isRequired, true)
        return methodDesc.name != nil
    }
}
