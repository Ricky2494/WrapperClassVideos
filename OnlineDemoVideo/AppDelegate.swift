//
//  AppDelegate.swift
//  OnlineDemoVideo
//
//  Created by Anindya Guha on 03/12/19.
//  Copyright © 2019 Anindya Guha. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Allow other apps to play sound also
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient,
        mode: AVAudioSession.Mode.moviePlayback, options: [.mixWithOthers])
        
        let videoFeedVC = VideoFeedViewController()
        videoFeedVC.title = "Simple Videos"
        
        let navBar = UINavigationController(rootViewController: videoFeedVC)
        navBar.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
        window?.rootViewController = navBar
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

