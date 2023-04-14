//
//  SceneDelegate.swift
//  ElinextFlickrSpringBoard
//
//  Created by Vlad Katsubo on 10.04.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let viewController = SpringBoardFactory().createController()
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: viewController)

        self.window = window
    }
}
