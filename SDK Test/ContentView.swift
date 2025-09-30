//
//  ContentView.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//

import SwiftUI
import SafariServices


struct ContentView: View {
    @State private var showChat = false
    @State private var isPrepared = false
    @State private var currentViewController: UIViewController?

    var body: some View {
        NavigationStack {
            VStack {
                if isPrepared {
                    Button("Start Chat") {
                        if let vc = currentViewController {
                            ChatManager.shared.startChat(from: vc)
                        } else {
                            print("No current view controller to start chat from.")
                        }
                    }
                    Button("Open Guide in Safari View Controller") {
                        guard let url = URL(string: "https://nice-incontact-mobile-sdk.s3.us-west-2.amazonaws.com/index.html") else {
                            print("Invalid guide URL.")
                            return
                        }
                        if let vc = currentViewController {
                            let safariVC = SFSafariViewController(url: url)
                            vc.present(safariVC, animated: true)
                        } else {
                            print("No current view controller to present guide.")
                        }
                    }
                    NavigationLink("Open Guide in Web View") {
                        GuideView()
                    }
                } else {
                    ProgressView("Preparing Chat...")
                }
            }
            .background(
                ViewControllerResolver { vc in
                    self.currentViewController = vc
                }
                    .frame(width: 0, height: 0)
            )
            .task {
                await ChatManager.shared.prepareIfNeeded()
                isPrepared = true
            }
        }
    }
}

#Preview {
    ContentView()
}

