//
//  AppDelegate.swift
//  Example
//
//  Created by Oleksandr Kurtsev on 21/10/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = ViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
