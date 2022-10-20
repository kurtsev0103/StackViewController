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
        static let grabberWidth: CGFloat = 40.0
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
        view.backgroundColor = .lightGray
        return view
    }
}
