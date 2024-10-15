//
//  SceneDelegate.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let networkManager = NetworkManager(session: URLSession.shared)
        let serviceAPI = EventsAPIService(networkManager: networkManager)
        let sportsViewModel = SportsEventsViewModel(serviceApi: serviceAPI)
        let viewController = HomeViewController(viewModel: sportsViewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.navigationBar.barTintColor = UIColor(red: 67/255.0, green: 148/255.0, blue: 159/255.0, alpha: 1.0)
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor(red: 28.0/255.0, green: 31.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        window?.makeKeyAndVisible()
    }
}

