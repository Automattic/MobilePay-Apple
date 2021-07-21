import SwiftUI
import MobilePayKit

@main
struct MobilePay_AppleApp: App {

    @StateObject private var viewModel = ProductListViewModel()

    var body: some Scene {
        WindowGroup {
            ProductList()
                .environmentObject(viewModel)
        }
    }
}
