//
//  SceneDelegate.swift
//  CarSample
//
//  Created by MAC240 on 18/10/21.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let _ = userActivity.interaction?.intent as? DoSomethingIntent {

            if let windowScene = scene as? UIWindowScene {
                self.window = UIWindow(windowScene: windowScene)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "MKMapViewController") as! MKMapViewController
                self.window!.rootViewController = initialViewController
                self.window!.makeKeyAndVisible()
//                initialViewController.showMessage()
            }
        }
    }
    
}

