//
//  PaymentCoordinator.swift
//  MobilePay-Apple
//
//  Created by Momo Ozawa on 2021/07/19.
//

import Foundation
import StoreKit
import MobilePayKit

class PaymentCoordinator: NSObject, ObservableObject {

    @Published var contentList: [PurchasableContent] = []

    let paymentQueueService = PaymentQueueService()

    private let productIdentifiers = Set([
        "com.mobilepay.consumable.rocketfuel",
        "com.mobilepay.consumable.premiumrocketfuel"
    ])

    override init() {
        super.init()

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

}
