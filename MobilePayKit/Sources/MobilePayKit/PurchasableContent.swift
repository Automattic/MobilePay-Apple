import Foundation
import StoreKit

public struct PurchasableContent: Hashable {
    public let id: String
    public let title: String
    public let description: String
    public var isLocked: Bool
    public var price: String?
    public let locale: Locale
    public let imageName: String

    // A number formatter for the price value
    lazy var formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter
    }()

    // Initialize a product based on the StoreKit product
    public init(product: SKProduct, isLocked: Bool = true) {
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
