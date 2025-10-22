//
//  ChatManager.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//

import CXoneChatSDK
import CXoneChatUI
import SwiftUI
import SafariServices

@MainActor
class ChatManager: ObservableObject {
    static let shared = ChatManager()
    private(set) var isReady = false
    private var presentingVC: UIViewController?
    private var isDisplayingSurvey = false

    func prepareIfNeeded() async {
        guard !isReady else { return }
        do {
            try await CXoneChat.shared.connection.prepare(
                environment: .NA1,
                brandId: 1390,
                channelId: "chat_955c2f5e-5cc1-4131-92ed-6a6aa0878b00"
            )
            CXoneChat.shared.customer.setName(firstName: "SDK", lastName: "Tester")
            CXoneChat.shared.add(delegate: self)
            isReady = true
            print("Chat prepared")
        } catch {
            print("❌ Chat prepare failed: \(error)")
        }
    }

    func startChat(from presentingVC: UIViewController) {
        self.presentingVC = presentingVC
        let configuration = ChatConfiguration(
            additionalCustomerCustomFields: ["p1": "something"],
            additionalContactCustomFields: ["location": "San Francisco", "fname": "John"]
        )
        let localization = ChatLocalization()
        localization.commonUnassignedAgent = ""
        localization.prechatSurveySubtitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        let coordinator = ChatCoordinator(chatLocalization: localization, chatConfiguration: configuration)
        coordinator.start(in: presentingVC, presentModally: true)
    }
}

extension ChatManager: CXoneChatDelegate {
    func onThreadUpdated(_ chatThread: CXoneChatSDK.ChatThread) {
        guard let lastMessage = chatThread.messages.last else { return }
        guard let user = lastMessage.authorUser else { return }
        
        if (user.isSurveyUser && !isDisplayingSurvey) {
            isDisplayingSurvey = true

            // Parse this from the message instead of relying on a hard-coded URL.
            guard let url = URL(string: "https://ahoylink.com/sPjFhwAlGg") else {
                print("Invalid survey URL.")
                return
            }
            
            // Automatically display the web page for the survey.
            Task { @MainActor in
                guard let base = presentingVC else {
                    print("No current view controller to present guide.")
                    return
                }

                var topMost: UIViewController = base
                while let presented = topMost.presentedViewController {
                    topMost = presented
                }

                let safariVC = SFSafariViewController(url: url)
                safariVC.modalPresentationStyle = .pageSheet
                topMost.present(safariVC, animated: true)
            }
        }
    }
}

