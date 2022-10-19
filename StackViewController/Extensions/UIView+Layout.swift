//
//  UIView+Layout.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

extension UIView {
    
    func activate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateFullFill(parent view: UIView, inset: UIEdgeInsets = .zero) {
        activate(constraints: [
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom),
        ])
    }
    
    func activateFullFill(parent view: UIView, vOffset: CGFloat = 0.0, hOffset: CGFloat = 0.0) {
        activateFullFill(parent: view, inset: .init(top: vOffset, left: hOffset, bottom: vOffset, right: hOffset))
    }
    
    func activateCenter(parent view: UIView, sizeMultiplier: CGFloat = 1.0) {
        activate(constraints: [
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: sizeMultiplier),
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: sizeMultiplier),
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func activateAspectRatio(_ ratio: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio).isActive = true
    }
    
    func activateWidth(parent view: UIView, sizeMultiplier: CGFloat = 1.0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: sizeMultiplier).isActive = true
    }
    
    func activateHeight(parent view: UIView, sizeMultiplier: CGFloat = 1.0) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: sizeMultiplier).isActive = true
    }
    
    func pinToSuperview(with insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        }
    }
}
