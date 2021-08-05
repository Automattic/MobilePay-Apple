import SwiftUI

@main
struct MobilePayKit_macOSApp: App {

    @StateObject private var viewModel = ProductListViewModel()

    var body: some Scene {
        WindowGroup {
            ProductList()
                .environmentObject(viewModel)
        }.commands {
            CommandMenu("Purchases") {
                Button(action: {
                    viewModel.restorePurchases()
                }) {
                    Text("Restore")
                }
            }
        }
    }
}
