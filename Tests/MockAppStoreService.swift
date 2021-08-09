import Foundation
import MobilePayKit
import StoreKit

class MockAppStoreService: AppStoreServiceProtocol {

    var fetchProductsCalled = false
    var fetchProductForIdentifierCalled = false
    var productIdentifier = ""
    var purchaseProductCalled = false
    var restorePurchasesCalled = false

    func fetchProducts(completion: @escaping FetchCompletionCallback) {
        fetchProductsCalled = true
    }

    func fetchProduct(for identifier: String) -> SKProduct? {
        productIdentifier = identifier
        fetchProductForIdentifierCalled = true
        return SKProduct()
    }

    func purchaseProduct(_ product: SKProduct, completion: @escaping PurchaseCompletionCallback) {
        purchaseProductCalled = true
    }

    func restorePurchases() {
        restorePurchasesCalled = true
    }
}
