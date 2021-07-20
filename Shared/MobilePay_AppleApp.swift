import SwiftUI
import MobilePayKit

@main
struct MobilePay_AppleApp: App {

    @StateObject private var paymentManager = PaymentManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(paymentManager)
        }
    }
}
