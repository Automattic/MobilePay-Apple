import Foundation
import StoreKit

public protocol ProductsRequest {

    var fetchedProducts: [SKProduct] { get }

    func start()
}

class ProductsRequestHelper: NSObject, ProductsRequest {

    // An object that can retrieve product info from the App Store
    private let request: SKProductsRequest

    // A callback to help with handling fetch products completion
    private var fetchCompletionCallback: FetchCompletionCallback?

    // This variable will be used as a cache to store the products we fetched
    private(set) var fetchedProducts: [SKProduct] = []

    // MARK: - Init

    init(productIdentifiers: Set<String>, completion: @escaping FetchCompletionCallback) {
        self.fetchCompletionCallback = completion
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        super.init()
        request.delegate = self
    }

    // MARK: - ProductsRequest

    func start() {
        // Send a request to the App Store
        request.start()
    }
}

// MARK: - SKProductsRequestDelegate

extension ProductsRequestHelper: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products

        // We want to know when products arn't loaded
        guard !products.isEmpty else {
            print("We could not load the products 😢")
            return
        }

        print("Invalid products:", response.invalidProductIdentifiers)

        // Here we are caching the products
        fetchedProducts = products

        DispatchQueue.main.async { [weak self] in
            self?.fetchCompletionCallback?(products)
            self?.fetchCompletionCallback = nil
        }
    }
}
