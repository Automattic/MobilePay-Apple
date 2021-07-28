import Foundation

public protocol ProductsRequestFactory {
    func createRequest(with identifiers: Set<String>, completion: @escaping FetchCompletionCallback) -> ProductsRequest
}

class AppStoreProductsRequestFactory: ProductsRequestFactory {
    func createRequest(with identifiers: Set<String>, completion: @escaping FetchCompletionCallback) -> ProductsRequest {
        return ProductsRequestHelper(productIdentifiers: identifiers, completion: completion)
    }
}
