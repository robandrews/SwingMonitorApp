/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class is the main entry point of the extension.
 */
import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if(granted){
                print("Granted authorization for notifications")
            }else{
                print("NO AUTHORIZATION FOR NOTIFICATIONS")
                // Require users to enable notifications?
                
            }
        }

        print("Configuring notification actions")
        let confirmAction = UNNotificationAction(identifier: "CONFIRM_SWING", title: "Yes", options: .foreground)
        let declineAction = UNNotificationAction(identifier: "DECLINE_SWING", title: "No", options: .foreground)
        
        let generalCategory = UNNotificationCategory(identifier: "SWING",
                                                     actions: [confirmAction, declineAction],
                                                     intentIdentifiers: [],
                                                     options: [])
        
        center.setNotificationCategories([generalCategory])
    }
}
