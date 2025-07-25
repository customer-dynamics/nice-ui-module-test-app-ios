//
//  ChatManager.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//

import CXoneChatSDK
import CXoneChatUI
import SwiftUI

@MainActor
class ChatManager: ObservableObject {
    static let shared = ChatManager()
    private(set) var isReady = false

    func prepareIfNeeded() async {
        guard !isReady else { return }
        do {
            try await CXoneChat.shared.connection.prepare(
                environment: .NA1,
                brandId: 1390,
                channelId: "chat_7e079ff5-6ffd-4001-8dd9-413cd041ce54"
            )
            isReady = true
            print("Chat prepared")
        } catch {
            print("❌ Chat prepare failed: \(error)")
        }
    }

    func startChat(from presentingVC: UIViewController) {
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
