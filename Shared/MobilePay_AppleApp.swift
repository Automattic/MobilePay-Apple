import SwiftUI
import MobilePayKit

@main
struct MobilePay_AppleApp: App {

    @StateObject private var viewModel = PaymentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
