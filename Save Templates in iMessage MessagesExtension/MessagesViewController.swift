import UIKit
import Messages
import SwiftUI

class MessagesViewController: MSMessagesAppViewController {

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)

        // Delay embedding of SwiftUI view to ensure view hierarchy is ready (fixes iPad blank screen issue)
        DispatchQueue.main.async {
            // Remove any existing child view controllers
            for child in self.children {
                child.view.removeFromSuperview()
                child.removeFromParent()
            }

            // Create the SwiftUI view
            let messagesView = MessagesView(conversation: conversation)

            // Embed it in a hosting controller
            let controller = UIHostingController(rootView: messagesView)
            self.addChild(controller)
            controller.view.frame = self.view.bounds
            controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(controller.view)
            controller.didMove(toParent: self)

            // Debug: write test value to shared defaults
            let sharedDefaults = UserDefaults(suiteName: "group.com.zane.TemplatePasterApp")
            let testMessage = "🧪 TEST MESSAGE FROM EXTENSION: \(Date())"
            sharedDefaults?.set(testMessage, forKey: "templateMessage")
            print("✅ Wrote test message: \(testMessage)")
        }
    }
}
