//
//  StackViewController.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

public enum BottomSheetPosition {
    case minimum, maximum, progressing
}

final public class StackViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let mainVC: UIViewController
    private let sheetVC: StackViewBottomSheet
    
    // MARK: - Public Properties
    
    public var headerView: UIView? {
        didSet { sheetVC.headerView = headerView }
    }
        
    public var configuration: StackViewConfigurationType? {
        didSet { sheetVC.configuration = configuration }
    }
    
    public var state: BottomSheetPosition {
        sheetVC.bottomSheetPosition
    }
    
    // MARK: - Public Methods
    
    public func move(to state: BottomSheetPosition) {
        sheetVC.move(to: state)
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        updateDefaultParameters()
        addChild(mainVC, in: view)
        addChild(sheetVC, in: view)
    }
    
    // MARK: - Initialization

    public init(mainVC: UIViewController, sheetVC: StackViewBottomSheet) {
        self.mainVC = mainVC
        self.sheetVC = sheetVC
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    func updateDefaultParameters() {
        if configuration == nil {
            configuration = StackViewDefaultConfiguration()
        }
        
        if headerView == nil {
            headerView = StackViewHeaderView()
        }
    }
}
