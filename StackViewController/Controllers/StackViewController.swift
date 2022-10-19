//
//  StackViewController.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

final public class StackViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainVC: UIViewController
    private let sheetVC: StackViewBottomSheet

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Public Methods
    
    public func track(_ scrollView: UIScrollView?) {
        guard let scrollView = scrollView else { return }
        scrollView.delegate = sheetVC
    }
}
