//
//  PurchasableContent.swift
//  MobilePay-Apple
//
//  Created by Momo Ozawa on 2021/07/19.
//

import Foundation
import StoreKit

struct PurchasableContent: Hashable {
    let id: String
    let title: String
    let description: String
    var isLocked: Bool
    var price: String?
    let locale: Locale
    let imageName: String

    // A number formatter for the price value
    lazy var formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter
    }()

    // Initialize a product based on the StoreKit product
    init(product: SKProduct, isLocked: Bool = true) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.imageName = product.productIdentifier
        self.description = product.localizedDescription

        self.isLocked = isLocked
        self.locale = product.priceLocale

        if isLocked {
            self.price = formatter.string(from: product.price)
        }
    }
}
