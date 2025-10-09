//
//  AppDelegate.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//


//
// Copyright (c) 2021-2025. NICE Ltd. All rights reserved.
//
// Licensed under the NICE License;
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://github.com/nice-devone/nice-cxone-mobile-sample-ios/blob/main/LICENSE
//
// TO THE EXTENT PERMITTED BY APPLICABLE LAW, THE CXONE MOBILE SDK IS PROVIDED ON
// AN “AS IS” BASIS. NICE HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS
// OR IMPLIED, INCLUDING (WITHOUT LIMITATION) WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, AND TITLE.
//

import UIKit
import CXoneChatSDK

class AppDelegate: UIResponder, UIApplicationDelegate {
    private var currentDeviceToken: Data?
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    
    // MARK: - Methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // Log notification settings at startup
        checkAndLogNotificationStatus()
        
        // Reset Badge Number
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Setup User Notification Center for real device
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    /// Checks and logs notification permission status
    private func checkAndLogNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification Settings - Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("Notification Settings - Alert Setting: \(settings.alertSetting.rawValue)")
            print("Notification Settings - Badge Setting: \(settings.badgeSetting.rawValue)")
            print("Notification Settings - Sound Setting: \(settings.soundSetting.rawValue)")
            print("Notification Settings - Notification Center Setting: \(settings.notificationCenterSetting.rawValue)")
            print("Notification Settings - Lock Screen Setting: \(settings.lockScreenSetting.rawValue)")
            print("Notification Settings - Announcement Setting: \(settings.announcementSetting.rawValue)")
            
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    print("Notification permissions granted - registering for remote notifications")
                    
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions NOT granted - notifications will not work")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Did register for remote notifications with token: \(tokenString)")
        
        guard currentDeviceToken != deviceToken else {
            print("Device token unchanged - skipping registration")
            return
        }
        
        self.currentDeviceToken = deviceToken
        
        print("Setting device token in CXoneChat")
        CXoneChat.shared.customer.setDeviceToken(deviceToken)
        
        print("Calling registration finished callback")
        RemoteNotificationsManager.shared.onRegistrationFinished?()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications")
        
        RemoteNotificationsManager.shared.onRegistrationFinished?()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let identifier = notification.request.identifier
        let userInfo = notification.request.content.userInfo
        
        // Show remote push notification when chat is not available
        if !CXoneChat.shared.state.isChatAvailable {
            print("Will present remote notification with identifier: \(identifier)")
        }
        // Show local push notification when chat is available and the notification name is `threadDeeplinkNotificationName`
        else if CXoneChat.shared.state.isChatAvailable, identifier.hasPrefix(NotificationCenter.threadDeeplinkNotificationName) {
            print("Will present local notification with identifier: \(identifier)")
            
            // Extract thread information if possible
            if let threadIdString = userInfo["threadId"] as? String {
                print("Thread ID from notification: \(threadIdString)")
            } else {
                print("Unable to extract threadId from notification userInfo")
            }
        } else {
            return []
        }
        
        print("Notification content: \(notification.request.content)")
        print("Notification userInfo: \(userInfo)")
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        print("Updated badge count to: \(UIApplication.shared.applicationIconBadgeNumber)")
        
        return [.list, .banner, .badge, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let identifier = response.notification.request.identifier
        
        print("Did receive notification response with identifier: \(identifier)")
        print("Notification userInfo: \(userInfo)")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("Reset badge count to 0")
        
        // Check if this is a message notification from a different thread
//        if processLocalNotificationAndNavigateToThread(notification: response.notification) {
//            print("Successfully posted notification to navigate directly to a CXoneChat's thread")
//        } else if processRemoteNotificationAndNavigateToThread(notification: response.notification) {
//            print("Successfully handled application deeplink")
//        } else {
//            print("Could not handle notification - neither thread navigation nor deeplink handling succeeded")
//        }
    }
}
