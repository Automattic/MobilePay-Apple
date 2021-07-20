import SwiftUI

@main
struct MobilePay_AppleApp: App {

    @StateObject private var paymentCoordinator = PaymentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(paymentCoordinator)
        }
    }
}
