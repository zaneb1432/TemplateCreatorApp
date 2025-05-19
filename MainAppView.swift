import SwiftUI

struct MainAppView: View {
    var body: some View {
        VStack {
            Text("Save Templates in iMessage")
                .font(.title)
                .padding()

            Text("This is the main app. You can close this and use the iMessage extension.")
                .font(.body)
                .padding()
        }
    }
}

#Preview {
    MainAppView()
}
