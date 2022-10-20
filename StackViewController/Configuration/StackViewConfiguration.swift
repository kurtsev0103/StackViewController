//
//  StackViewConfiguration.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 20/10/2022.
//

import UIKit

public protocol StackViewConfigurationType {
    
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
    var backColor: UIColor { get }
    var cornerRadius: CGFloat { get }
    
    var headerHeight: CGFloat { get }
    
    var shadowColor: UIColor { get }
    var shadowOffset: CGSize { get }
    var shadowRadius: CGFloat { get }
    var shadowSpread: CGFloat { get }
}


final class StackViewDefaultConfiguration: StackViewConfigurationType {
    
    // MARK: - Private Properties
    
    private var screenHeight: CGFloat { UIScreen.main.bounds.height }
    
    // MARK: - StackViewConfigurationType
    
    var minHeight: CGFloat { screenHeight / 5 }
    var maxHeight: CGFloat { screenHeight / 2 }
    var backColor: UIColor { .white }
    var cornerRadius: CGFloat { 16.0 }
    
    var headerHeight: CGFloat { 20.0 }
    
    var shadowColor: UIColor { .black }
    var shadowOffset: CGSize { .zero }
    var shadowRadius: CGFloat { 8.0 }
    var shadowSpread: CGFloat { 4.0 }
}
