//
//  ContentView.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//

import SwiftUI


struct ContentView: View {
    @State private var showChat = false
    @State private var isPrepared = false
    @State private var currentViewController: UIViewController?

    var body: some View {
        VStack {
            if isPrepared {
                Button("Start Chat") {
                    if let vc = currentViewController {
                        ChatManager.shared.startChat(from: vc)
                    } else {
                        print("No current view controller to start chat from.")
                    }
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

#Preview {
    ContentView()
}
