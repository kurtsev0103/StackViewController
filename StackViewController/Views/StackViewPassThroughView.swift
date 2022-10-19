//
//  StackViewPassThroughView.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

final class StackViewPassThroughView: UIView {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - UIView
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view != self ? view : nil
    }
    
    // MARK: - Private
    
    private func setupView() {
        backgroundColor = .clear
    }
}
