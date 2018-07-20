//
//  AppDelegate.swift
//  PDF Reader
//
//  Created by Chintan Dave on 23/09/16.
//  Copyright © 2016 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import UserNotifications

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var interstitial: GADInterstitial!
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //Firebase
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        registerSetupForRemoteNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3023134250340516~4054152080")
        
        loadInterstitial()
        return true
    }
    
    func loadInterstitial()
    {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3023134250340516/7390761864")
        let request = GADRequest()
        interstitial.load(request)
    }
    
    //MARK: -  Register For Remote Notification
    func registerSetupForRemoteNotification() {
        
        let application:UIApplication = UIApplication.shared
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            //Messaging.messaging().remoteMessageDelegate = self
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")

        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
//        #if DEBUG
//        InstanceID.instanceID().setAPNSToken(deviceToken as Data, type: AuthAPNSTokenType.sandbox)
//        #else
//        InstanceID.instanceID().setAPNSToken(deviceToken as Data, type: InstanceIDAPNSTokenType.prod)
//        #endif
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        connectToFcm()
    }
    
    func connectToFcm() {
        
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
        
        
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}
