import Foundation
import StoreKit

public class PaymentManager: NSObject {

    private let appStoreService = AppStoreService()

    // MARK: - Init

    public override init() {
        super.init()
    }

    // MARK: - Public

    public func fetchProducts(completion: @escaping FetchCompletionCallback) {
        appStoreService.fetchProducts(completion: completion)
    }

    public func purchaseProduct(with identifier: String, completion: @escaping PurchaseCompletionCallback) {

        // Check if the product exists in the App Store before purchasing
        guard let product = appStoreService.fetchProduct(for: identifier) else {
            return
        }

        appStoreService.purchaseProduct(product, completion: completion)

    }

    public func restorePurchases() {
        appStoreService.restorePurchases()
    }
}
