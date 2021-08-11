import Combine
import Foundation
import MobilePayKit

class ProductListViewModel: ObservableObject {

    @Published private(set) var products: [Product] = []

    // Here we're going to store all the completed purchases
    private var completedPurchases: [String] = [] {

        // We need to update set the subscription.isLocked value to true after a purchase
        didSet {
            // We have to do this on the main queue as this might affect the UI
            DispatchQueue.main.async { [weak self] in

                guard let self = self else {
                    return
                }

                for index in self.products.indices {

                    // Update the "isLocked" if the product has been purchased
                    self.products[index].isLocked = !self.completedPurchases.contains( self.products[index].id )
                }
            }
        }
    }

    init() {
        MobilePayKit.configure(
            oAuthToken: "token",
            bundleId: Bundle.main.bundleIdentifier
        )

        MobilePayKit.shared.fetchProducts(completion: { result in
            switch result {
            case .success(let products):
                self.products = products.map { Product(product: $0) }
            case .failure(let error):
                print("Error fetching products: \(error.localizedDescription)")
            }
        })
    }

    func purchaseProduct(with identifier: String) {
        MobilePayKit.shared.purchaseProduct(with: identifier, completion: { [weak self] result in
            switch result {
            case .success(let transaction):
                self?.completedPurchases.append(transaction.payment.productIdentifier)
            case .failure(let error):
                print("Error purchasing product: \(error.localizedDescription)")
            }
        })
    }

    func restorePurchases() {
        MobilePayKit.shared.restorePurchases()
    }
}
