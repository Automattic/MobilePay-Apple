import Foundation
import StoreKit

public typealias FetchCompletionCallback = ([SKProduct]) -> Void
public typealias PurchaseCompletionCallback = (SKPaymentTransaction?) -> Void

class AppStoreService: NSObject {

    private let paymentQueue: PaymentQueue

    // A callback to help with handling fetch products completion
    private var fetchCompletionCallback: FetchCompletionCallback?

    // A callback to help with handling purchase product completion
    private var purchaseCompletionCallback: PurchaseCompletionCallback?

    // This variable will be used as a cache to store the products we fetched
    private var fetchedProducts: [SKProduct] = []

    // An object that can retrieve product info from the App Store
    private var productsRequest: SKProductsRequest?

    // MARK: - Lifecycle

    init(paymentQueue: PaymentQueue = SKPaymentQueue.default()) {
        self.paymentQueue = paymentQueue
        super.init()
        paymentQueue.add(self)
    }

    deinit {
        paymentQueue.remove(self)
    }

    // MARK: - Public

    func fetchProducts(for identifiers: Set<String>, completion: @escaping FetchCompletionCallback) {

        // Initialize the handler
        fetchCompletionCallback = completion

        // Initialize the product request with the above identifiers
        productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest?.delegate = self

        // Send the request to the App Store
        productsRequest?.start()
    }

    func fetchProduct(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: { $0.productIdentifier == identifier})
    }

    func purchaseProduct(_ product: SKProduct, completion: @escaping PurchaseCompletionCallback) {

        // Initialiaze the handler
        purchaseCompletionCallback = completion

        // Submit the payment request to the App Store by adding it to the payment queue
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }

    func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }

}

// MARK: - SKPaymentTransactionObserver

extension AppStoreService: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {

            case .purchasing,
                 .deferred:
                // FIXME: ignore for now
                break

            case .failed:
                paymentQueue.finishTransaction(transaction)
                // FIXME: handle failed transaction

            case .purchased,
                 .restored:
                paymentQueue.finishTransaction(transaction)

                DispatchQueue.main.async { [weak self] in
                    self?.purchaseCompletionCallback?(transaction)
                    self?.purchaseCompletionCallback = nil
                }

            @unknown default:
                print("Unexpected transaction state: \(transaction.transactionState)")
            }
        }
    }

}

// MARK: - SKProductsRequestDelegate

extension AppStoreService: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products

        // We want to know when products arn't loaded
        guard !products.isEmpty else {
            print("We could not load the products 😢")
            productsRequest = nil
            return
        }

        print("invalid products:", response.invalidProductIdentifiers)

        // Here we are caching the products
        fetchedProducts = products

        DispatchQueue.main.async { [weak self] in
            self?.fetchCompletionCallback?(products)
            self?.fetchCompletionCallback = nil
        }
    }

}
