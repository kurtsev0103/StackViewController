//
//  StackViewHeaderView.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 20/10/2022.
//

import UIKit

final class StackViewHeaderView: UIView {
    
    // MARK: - Views
    
    private let grabber: UIView = Subviews.grabber
        
    // MARK: - Properties
    
    private enum Configuration {
        static let grabberHeight: CGFloat = 4.0
        static let grabberWidth: CGFloat = 36.0
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        addSubview(grabber)
        grabber.activate(constraints: [
            grabber.heightAnchor.constraint(equalToConstant: Configuration.grabberHeight),
            grabber.widthAnchor.constraint(equalToConstant: Configuration.grabberWidth),
            grabber.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabber.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        grabber.layer.cornerRadius = Configuration.grabberHeight / 2.0
    }
}

// MARK: - Subviews

enum Subviews {
    static var grabber: UIView {
        let view = UIView()
        view.backgroundColor = .init(hex: "#D9D9D9")
        return view
    }
}

fileprivate extension UIColor {
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}
