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
        //stackVC.headerView = MyHeaderView()
        
        // (Optional): You can set your own configuration
        //stackVC.configuration = MyConfiguration()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = stackVC
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
