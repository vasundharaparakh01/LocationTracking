//
//  AppDelegate.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/14/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import UserNotifications
import Polyline
import IQKeyboardManagerSwift
//import Fabric
//import Crashlytics
import Firebase
import FirebaseCore
import FirebaseCrashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window              : UIWindow?
    var timerForStopTrack   : Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = Color.statusbarcolor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        IQKeyboardManager.shared.enable = true
        // Use the Firebase library to configure APIs.
        FirebaseApp.configure()
        GMSServices.provideAPIKey(GoogleAppID.appid)
        self.registerPushNotification(application: application)
        LocationManager.shared.setupLocationManager()
        if let dict = UserDefaults.standard.dictionary(forKey: "userObj") {
            AppInstance.shared.user = User(dictionary: dict)
            UIUtility.addDashboardTabBarController ()
        }
//        Fabric.with([Crashlytics.self])
        self.stopTrackApiCall()
        return true
    }
    
    func registerPushNotification(application: UIApplication) {
        if #available(iOS 10, *) {
            let notification        = UNUserNotificationCenter.current()
            notification.delegate   = self
            notification.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {
                    return
                }
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.setValue(token, forKey: "device_token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if LocationManager.shared.isTrackingStarted {
            LocationManager.shared.locationManager.desiredAccuracy      = kCLLocationAccuracyBestForNavigation
            if #available(iOS 9.0, *) {
                LocationManager.shared.locationManager.allowsBackgroundLocationUpdates    = true
            }
            //For showing gps sign when in background
            if #available(iOS 11.0, *) {
                LocationManager.shared.locationManager.showsBackgroundLocationIndicator   = true
            } else {
                // Fallback on earlier versions
            }
        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        LocationManager.shared.locationManager.allowsBackgroundLocationUpdates    = true
        LocationManager.shared.locationManager.desiredAccuracy                    = kCLLocationAccuracyBest
        LocationManager.shared.locationManager.showsBackgroundLocationIndicator   = true
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
                print("when in used2",CLLocationManager.authorizationStatus())
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationPermission") , object: nil)
            case .authorizedAlways:
                print("always in used2",CLLocationManager.authorizationStatus())
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationPermission") , object: nil)
            }
        } else {
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        UserDefaults.standard.set(true, forKey: "killedState")
        for jobs in CoreDataStackManager.sharedManager.getCurrentTrackData() {
            var encodedPolyline: String?
            let polyline       = Polyline(locations: LocationManager.shared.allcoordinates)
            encodedPolyline    = polyline.encodedPolyline
            jobs.polyline      = encodedPolyline
            jobs.long          = LocationManager.shared.currentUserLocation?.coordinate.longitude
            jobs.lat           = LocationManager.shared.currentUserLocation?.coordinate.latitude
            jobs.save()
            LocationManager.shared.stopManager()
        }
    }

    //MARK:- Navigation Bar Set Up
    func navigationBarSetUP() {
        let navigationBarAppearace                          = UINavigationBar.appearance()
        navigationBarAppearace.shadowImage                  = UIImage()
        navigationBarAppearace.tintColor                    = UIColor.gray
        let attrs                                           = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        navigationBarAppearace.titleTextAttributes          = attrs
        if #available(iOS 11.0, *) {
            navigationBarAppearace.largeTitleTextAttributes = attrs
        } else {
            // Fallback on earlier versions
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
        UINavigationBar.appearance().barTintColor           = UIColor.white
    }
    
    @objc func stopTrackApiCall() {
        if LocationManager.shared.isTrackingStarted {
            let service = TrackinService()
            service.stopTrackingFromWeb() { (response) in
                if response == "Inactive" {
                    for jobs in CoreDataStackManager.sharedManager.getCurrentTrackData() {
                        CoreDataStackManager.sharedManager.deleteCurrentTrack(trackingid: jobs.trackingid ?? "")
                    }
                }
            }
        }
    }
    
}

