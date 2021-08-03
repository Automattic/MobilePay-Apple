import Foundation
import StoreKit

extension SKProduct {

    var priceInCents: Int {
        Int(price.floatValue * 100)
    }
}
