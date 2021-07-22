import Combine
import Foundation
import MobilePayKit

class ProductListViewModel: ObservableObject {

    @Published private(set) var products: [MobilePayKit.Product]

    private let paymentManager: PaymentManager

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

    init(paymentManager: PaymentManager = .init()) {
        self.products = []
        self.paymentManager = paymentManager

        paymentManager.fetchRemoteProducts(completion: { products in
            self.products = products.map { Product(product: $0) }
        })
    }

    func buyProduct(with identifier: String) {
        // Check if the product exists before purchasing
        guard let product = paymentManager.fetchProduct(for: identifier) else {
            return
        }

        paymentManager.purchaseProduct(product, completion: { [weak self] transaction in
            guard let transaction = transaction else {
                return
            }
            self?.completedPurchases.append(transaction.payment.productIdentifier)
        })
    }

    func restorePurchases() {
        paymentManager.restorePurchases()
    }
}
