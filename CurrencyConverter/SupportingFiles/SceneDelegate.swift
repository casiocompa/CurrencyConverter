//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 01.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let contentViewController = CurrencyConverterViewController()
        let navigationController = UINavigationController(rootViewController: contentViewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
}
