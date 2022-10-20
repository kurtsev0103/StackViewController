//
//  StackViewController.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

final public class StackViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let mainVC: UIViewController
    private let sheetVC: StackViewBottomSheet
    
    // MARK: - Public Properties
        
    public var configuration: StackViewConfigurationType? {
        didSet { sheetVC.configuration = configuration }
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        updateConfiguration()
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
    
    func updateConfiguration() {
        guard configuration == nil else { return }
        configuration = StackViewDefaultConfiguration()
    }
}
