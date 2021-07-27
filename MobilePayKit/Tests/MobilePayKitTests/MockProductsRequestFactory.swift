import Foundation
import StoreKit
import MobilePayKit

class MockProductsRequest: ProductsRequest {

    var startCalled = false

    var fetchedProducts: [SKProduct] = []

    private let productIdentifiers: Set<String>
    private let completion: FetchCompletionCallback

    init(productIdentifiers: Set<String>, completion: @escaping FetchCompletionCallback) {
        self.productIdentifiers = productIdentifiers
        self.completion = completion
    }

    func start() {
        startCalled = true
    }
}

class MockProductsRequestFactory: ProductsRequestFactory {

    var request: MockProductsRequest?

    func createRequest(with identifiers: Set<String>, completion: @escaping FetchCompletionCallback) -> ProductsRequest {
        let productsRequest = MockProductsRequest(productIdentifiers: identifiers, completion: completion)
        request = productsRequest
        return productsRequest
    }
}
