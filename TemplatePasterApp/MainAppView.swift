import SwiftUI

struct MainAppView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Template Creator for Messages")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("To use this app:\n\n1. Open the Messages app.\n2. Start a conversation.\n3. Tap the plus (+) button.\n4. Select \"Template Creator for Messages\".\n5. Create and insert your templates.")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    MainAppView()
}
