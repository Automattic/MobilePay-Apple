import SwiftUI

@main
struct MobilePayKit_macOSApp: App {

    @StateObject private var viewModel = ProductListViewModel()

    var body: some Scene {
        WindowGroup {
            ProductList()
                .frame(width: 700, height: 400, alignment: .center)
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
