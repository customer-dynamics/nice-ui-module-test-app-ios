//
//  SDK_TestApp.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//

import SwiftUI

@main
struct SDK_TestApp: App {
    // Register the UIKit AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
