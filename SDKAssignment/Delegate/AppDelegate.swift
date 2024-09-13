//
//  AppDelegate.swift
//  SDKAssignment
//
//  Created by ceinfo on 06/09/24.
//

import UIKit
import MapplsAPIKit
import MapplsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MapplsAccountManager.setMapSDKKey("d1a47d258f208e9670ce3d30dbc34238")
        MapplsAccountManager.setRestAPIKey("d1a47d258f208e9670ce3d30dbc34238")
        MapplsAccountManager.setClientId("33OkryzDZsLnQEZBj6lmM2JlDl8kOoIwMC7cMz6a_1J9-G-ke6XWyUkpnaLLU7Ej-3lNG3xnQlftQbw2weBbQw==")
        MapplsAccountManager.setClientSecret("lrFxI-iSEg-4c9850ynECYyzOBFfVXPJRyhDONweVOXlJLpymYWEgMP9KyKqJ_7umX5CK9kqBmxJowwG83AJTZfXmgocGeDN")
        MapplsAccountManager.setGrantType("client_credentials")
        
        
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

