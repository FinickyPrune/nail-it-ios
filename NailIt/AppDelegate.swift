//
//  AppDelegate.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 13.11.2022.
//

import UIKit
import CoreData
import SwiftyBeaver

let log = SwiftyBeaver.self

var debugMode: Bool {
    guard let modeString = Bundle.main.object(forInfoDictionaryKey: "DEBUG_MODE") as? String else {
        return true
    }
    return modeString == "YES"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootCoordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let console = ConsoleDestination()
        log.addDestination(console)

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        window?.overrideUserInterfaceStyle = .light

        rootCoordinator = RootCoordinator(navigationController: navigationController)
        rootCoordinator?.start()

        return true
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
