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
    
    public func purchaseProduct(with identifier: String, completion: @escaping PurchaseCompletionCallback) {
        
        // Check if the product exists in the App Store before purchasing
        guard let product = paymentQueueService.fetchProduct(for: identifier) else {
            return
        }
        
        paymentQueueService.purchaseProduct(product, completion: completion)

    }

    public func restorePurchases() {
        paymentQueueService.restorePurchases()
    }
}
