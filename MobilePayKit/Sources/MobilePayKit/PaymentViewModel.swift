import Foundation
import StoreKit

public class PaymentViewModel: NSObject, ObservableObject {

    @Published public var contentList: [PurchasableContent] = []

    @Published public var currentContent: PurchasableContent?

    private let paymentQueueService = PaymentQueueService()

    private let productIdentifiers = Set([
        "com.mobilepay.consumable.rocketfuel",
        "com.mobilepay.consumable.premiumrocketfuel"
    ])

    // Here we're going to store all the completed purchases
    private var completedPurchases = [String]() {

        // We need to update set the subscription.isLocked value to true after a purchase
        didSet {
            // We have to do this on the main queue as this might affect the UI
            DispatchQueue.main.async { [weak self] in

                guard let self = self else {
                    return
                }

                for index in self.contentList.indices {

                    // Update the "isLocked" if the product has been purchased
                    self.contentList[index].isLocked = !self.completedPurchases.contains( self.contentList[index].id )
                }
            }
        }
    }

    public override init() {
        super.init()

        paymentQueueService.delegate = self

        paymentQueueService.fetchProducts(for: productIdentifiers) { products in
            self.contentList = products.map { PurchasableContent(product: $0) }
        }
    }

    public func fetchProduct(for identifier: String) -> SKProduct? {
        return paymentQueueService.fetchProduct(for: identifier)
    }

    public func purchaseProduct(_ product: SKProduct) {
        paymentQueueService.purchaseProduct(product)
    }

    public func restorePurchases() {
        paymentQueueService.restorePurchases()
    }

    public func consumeCurrentContent() {
        currentContent?.isLocked = true
    }

}

extension PaymentViewModel: PaymentQueueServiceDelegate {

    public func failedTransaction(_ transaction: SKPaymentTransaction) {
        // TODO
    }

    public func completeTransaction(_ transaction: SKPaymentTransaction) {
        // Add the purhcased and restored transaction product Ids to the "completedPurchases" array
        completedPurchases.append(transaction.payment.productIdentifier)
    }

}
