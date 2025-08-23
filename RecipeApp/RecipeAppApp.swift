//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import Firebase
import FirebaseAppCheck
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    #if DEBUG
      let providerFactory = AppCheckDebugProviderFactory()
      AppCheck.setAppCheckProviderFactory(providerFactory)
    #endif

    return true
  }
}


@main
struct RecipeAppApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [RecipeModel.self, UserModel.self])
    }
}


