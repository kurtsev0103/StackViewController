//
//  AppDelegate.swift
//  Example
//
//  Created by Oleksandr Kurtsev on 21/10/2022.
//

import UIKit
import StackViewController

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let stackVC = StackViewController(
            mainVC: MapViewController(),
            sheetVC: TableViewController()
        )
        
        // (Optional): You can set your own header view
        stackVC.headerView = MyHeaderView()
        
        // (Optional): You can set your own configuration
        stackVC.configuration = MyConfiguration()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = stackVC
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

final class MyHeaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .red.withAlphaComponent(0.5)
    }
}

final class MyConfiguration: StackViewConfigurationType {
    
    // MARK: - Private Properties
    
    private var screenHeight: CGFloat { UIScreen.main.bounds.height }
    
    // MARK: - StackViewConfigurationType
    
    var minHeight: CGFloat { screenHeight * 0.2 }
    var maxHeight: CGFloat { screenHeight * 0.8 }
    var backColor: UIColor { .white }
    var cornerRadius: CGFloat { 20.0 }
    
    var headerHeight: CGFloat { 44.0 }
    
    var shadowColor: UIColor { .red.withAlphaComponent(0.5) }
    var shadowOffset: CGSize { .zero }
    var shadowRadius: CGFloat { 8.0 }
    var shadowOpacity: CGFloat { 4.0 }
}
