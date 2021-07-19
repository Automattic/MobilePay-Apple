//
//  PaymentViewModel.swift
//  MobilePay-Apple
//
//  Created by Momo Ozawa on 2021/07/19.
//

import Foundation
import StoreKit
import MobilePayKit

class PaymentViewModel: NSObject, ObservableObject {

    @Published var contentList: [PurchasableContent] = []

    @Published var currentContent: PurchasableContent?

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
                // Ensure we can access self here
                guard let self = self else { return }

                for index in self.contentList.indices {

                    // Update the "isLocked" if the product has been purchased
                    self.contentList[index].isLocked = !self.completedPurchases.contains( self.contentList[index].id )
                }
            }
        }
    }

    override init() {
        super.init()

        paymentQueueService.delegate = self

        paymentQueueService.fetchProducts(for: productIdentifiers) { products in
            self.contentList = products.map { PurchasableContent(product: $0) }
        }
    }

    func fetchProduct(for identifier: String) -> SKProduct? {
        return paymentQueueService.fetchProduct(for: identifier)
    }

    func purchaseProduct(_ product: SKProduct) {
        paymentQueueService.purchaseProduct(product)
    }

    func restorePurchases() {
        paymentQueueService.restorePurchases()
    }

    func consumeCurrentContent() {
        currentContent?.isLocked = true
    }

}

extension PaymentViewModel: PaymentQueueServiceDelegate {

    func failedTransaction(_ transaction: SKPaymentTransaction) {
        // TODO
    }

    func completeTransaction(_ transaction: SKPaymentTransaction) {
        // Add the purhcased and restored transaction product Ids to the "completedPurchases" array
        completedPurchases.append(transaction.payment.productIdentifier)
    }

}
