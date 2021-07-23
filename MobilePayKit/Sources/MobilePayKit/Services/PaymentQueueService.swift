import Foundation
import StoreKit

public typealias FetchCompletionCallback = ([SKProduct]) -> Void
public typealias PurchaseCompletionCallback = (SKPaymentTransaction?) -> Void

public class PaymentQueueService: NSObject {

    // A callback to help with handling fetch products completion
    private var fetchCompletionCallback: FetchCompletionCallback?

    // A callback to help with handling purchase product completion
    private var purchaseCompletionCallback: PurchaseCompletionCallback?

    // This variable will be used as a cache to store the products we fetched
    private var fetchedProducts: [SKProduct] = []

    // An object that can retrieve product info from the App Store
    private var productsRequest: SKProductsRequest?

    // MARK: - Lifecycle

    public override init() {
        super.init()
        start()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    // MARK: - Public

    public func start() {
        SKPaymentQueue.default().add(self)
    }

    public func fetchProducts(for identifiers: Set<String>, completion: @escaping FetchCompletionCallback) {

        // Initialize the handler
        fetchCompletionCallback = completion

        // Initialize the product request with the above identifiers
        productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest?.delegate = self

        // Send the request to the App Store
        productsRequest?.start()
    }

    public func fetchProduct(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: { $0.productIdentifier == identifier})
    }

    public func purchaseProduct(_ product: SKProduct, completion: @escaping PurchaseCompletionCallback) {

        // Initialiaze the handler
        purchaseCompletionCallback = completion

        // Submit the payment request to the App Store by adding it to the payment queue
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

}

// MARK: - SKPaymentTransactionObserver

extension PaymentQueueService: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {

            case .purchasing,
                 .deferred:
                // FIXME: ignore for now
                break

            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                // FIXME: handle failed transaction

            case .purchased,
                 .restored:
                SKPaymentQueue.default().finishTransaction(transaction)

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

extension PaymentQueueService: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
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