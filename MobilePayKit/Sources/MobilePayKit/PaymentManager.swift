import Foundation
import StoreKit

public class PaymentManager: NSObject {

    private let paymentQueueService = PaymentQueueService()

    private let productIdentifiers = Set([
        "com.mobilepay.consumable.rocketfuel",
        "com.mobilepay.consumable.premiumrocketfuel"
    ])

    // MARK: - Init

    public override init() {
        super.init()
    }

    // MARK: - Public

    public func fetchRemoteProducts(completion: @escaping FetchCompletionCallback) {
        paymentQueueService.fetchProducts(for: productIdentifiers, completion: completion)
    }

    public func fetchProduct(for identifier: String) -> SKProduct? {
        return paymentQueueService.fetchProduct(for: identifier)
    }

    public func purchaseProduct(_ product: SKProduct, completion: @escaping PurchaseCompletionCallback) {
        paymentQueueService.purchaseProduct(product, completion: completion)
    }

    public func restorePurchases() {
        paymentQueueService.restorePurchases()
    }
}
