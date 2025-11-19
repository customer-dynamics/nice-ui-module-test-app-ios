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
        // Add your custom fields.
        let configuration = ChatConfiguration(
            additionalCustomerCustomFields: ["p1": "something"],
            additionalContactCustomFields: ["location": "San Francisco", "fname": "John"]
        )

        // Override text for localization.
        let localization = ChatLocalization()
        localization.commonUnassignedAgent = ""
        localization.prechatSurveySubtitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        
        // Set custom colors for the interface
        let primaryColor = Color(.sRGB, red: 102, green: 128, blue: 255)
        let primaryContainer = Color(.sRGB, red: 92, green: 216, blue: 110)
        let onPrimaryContainer = Color(.sRGB, red: 0, green: 162, blue: 0)
        let secondaryColor = Color(.sRGB, red: 68, green: 210, blue: 227)
        let secondaryContainer = Color(.sRGB, red: 177, green: 235, blue: 242)
        let onSecondaryContainer = Color(.sRGB, red: 0, green: 133, blue: 145)
        let white = Color(.sRGB, red: 255, green: 255, blue: 255)
        let black = Color(.sRGB, red: 0, green: 0, blue: 0)

        let customColors = StyleColorsManager(
            light: StyleColorsImpl(
                background: BackgroundStyleColorsImpl.defaultLight,
                content: ContentStyleColorsImpl.defaultLight,
//                brand: BrandStyleColorsImpl.defaultLight,
                brand: BrandStyleColorsImpl(
                    primary: primaryColor,
                    onPrimary: white,
                    primaryContainer: black,
                    onPrimaryContainer: white,
                    secondary: black,
                    onSecondary: white,
                    secondaryContainer: black,
                    onSecondaryContainer: white
                ),
//                border: BorderStyleColorsImpl.defaultLight, // Not accessible
                border: BorderStyleColorsImpl(
                    default: Color(.sRGB, red: 212, green: 213, blue: 216),
                    subtle: Color(.sRGB, red: 230, green: 230, blue: 232)
                ),
                status: StatusStyleColorsImpl.defaultLight
            ),
            dark: StyleColorsImpl(
                background: BackgroundStyleColorsImpl.defaultDark,
                content: ContentStyleColorsImpl.defaultDark,
                brand: BrandStyleColorsImpl.defaultDark,
//                border: BorderStyleColorsImpl.defaultDark, // Not accessible
                border: BorderStyleColorsImpl(
                    default: Color(.sRGB, red: 64, green: 68, blue: 83),
                    subtle: Color(.sRGB, red: 31, green: 35, blue: 51)
                ),
                status: StatusStyleColorsImpl.defaultDark
            )
        )
        let chatStyle = ChatStyle(colorsManager: customColors)
        
        let coordinator = ChatCoordinator(chatStyle: chatStyle, chatLocalization: localization, chatConfiguration: configuration)
        coordinator.start(in: presentingVC, presentModally: true)
    }
}

extension ChatManager: CXoneChatDelegate {
    func onThreadUpdated(_ chatThread: CXoneChatSDK.ChatThread) {
        if let contentType = chatThread.messages.last?.contentType {
            switch contentType {
            case .unknown:
                print("Received unknown message type")
            default:
                break
            }
        }
    }
}
