import Foundation
import StoreKit

public class PaymentManager: NSObject {

    private let appStoreService = AppStoreService()

    private let productIdentifiers = Set([
        "com.mobilepay.consumable.rocketfuel",
        "com.mobilepay.consumable.premiumrocketfuel"
    ])

    // MARK: - Init

    public override init() {
        super.init()
    }

    // MARK: - Public

    public func fetchProducts(completion: @escaping FetchCompletionCallback) {
        appStoreService.fetchProducts(for: productIdentifiers, completion: completion)
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
