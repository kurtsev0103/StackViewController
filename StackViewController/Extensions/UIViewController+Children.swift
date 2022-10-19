//
//  UIViewController+Children.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

extension UIViewController {
    
    func addChild(_ child: UIViewController, in containerView: UIView, edges: UIRectEdge = .all) {
        guard containerView.isDescendant(of: view) else { return }
        addChild(child)
        
        containerView.addSubview(child.view)
        child.view.pinToSuperview(edges: edges)
        child.didMove(toParent: self)
    }
}
