//
//  StackViewController.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

public enum BottomSheetPosition {
    case minimum, maximum, progressing, hidden
}

final public class StackViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let mainVC: UIViewController
    private let sheetVC: StackViewBottomSheet
    private var sheet2VC: StackViewBottomSheet?
    private lazy var currentSheet: StackViewBottomSheet = sheetVC
    
    // MARK: - Public Properties
    
    public var onChangePosition: ((CGFloat) -> Void)?
    public var onSheet2Hidden: (() -> Void)?
    
    public var headerView: UIView? {
        didSet { sheetVC.headerView = headerView }
    }
    
    public var header2View: UIView? {
        didSet { sheet2VC?.headerView = header2View }
    }
        
    public var configuration: StackViewConfigurationType? {
        didSet { sheetVC.configuration = configuration }
    }
    
    public var configuration2: StackViewConfigurationType? {
        didSet { sheet2VC?.configuration = configuration2 }
    }
    
    public var state: BottomSheetPosition {
        sheetVC.bottomSheetPosition
    }
    
    // MARK: - Public Methods
    
    public func move(to state: BottomSheetPosition) {
        sheetVC.move(to: state)
    }
    
    public func switchSheet() {
        guard let sheet2VC = sheet2VC else { return }
        if currentSheet == sheetVC {
            currentSheet = sheet2VC
            sheetVC.move(to: .hidden)
            sheet2VC.move(to: .maximum)
            view.bringSubviewToFront(sheet2VC.view)
        } else {
            currentSheet = sheetVC
            sheet2VC.move(to: .hidden)
            sheetVC.move(to: .maximum)
            view.bringSubviewToFront(sheetVC.view)
        }
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        updateDefaultParameters()
        addChild(mainVC, in: view)
        
        if let sheet2VC = sheet2VC {
            addChild(sheet2VC, in: view)
        }
        
        addChild(sheetVC, in: view)
        
        setupBinding()
    }
    
    // MARK: - Initialization

    public init(mainVC: UIViewController, sheetVC: UIViewController, sheet2VC: UIViewController? = nil) {
        self.sheetVC = StackViewBottomSheet(childVC: sheetVC)
        
        if let sheet2VC = sheet2VC {
            self.sheet2VC = StackViewBottomSheet(childVC: sheet2VC)
        }
        
        self.mainVC = mainVC
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func updateDefaultParameters() {
        if configuration == nil {
            configuration = StackViewDefaultConfiguration()
        }
        
        if configuration2 == nil {
            configuration2 = StackViewDefaultConfiguration()
        }
        
        if headerView == nil {
            headerView = StackViewHeaderView()
        }
        
        if header2View == nil {
            header2View = StackViewHeaderView()
        }
    }
    
    private func setupBinding() {
        sheetVC.onChangePosition = { [weak self] value in
            guard let self = self else { return }
            self.onChangePosition?(value)
        }
        
        sheet2VC?.onMoveToMinimum = { [weak self] in
            guard let self = self else { return }
            self.onSheet2Hidden?()
        }
    }
}
