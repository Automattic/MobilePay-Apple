import Foundation
import StoreKit

public typealias FetchCompletionCallback = ([SKProduct]) -> Void
public typealias PurchaseCompletionCallback = (SKPaymentTransaction?) -> Void

class AppStoreService: NSObject {

    private let paymentQueue: PaymentQueue

    private let productsRequestFactory: ProductsRequestFactory

    // A callback to help with handling fetch products completion
    private var fetchCompletionCallback: FetchCompletionCallback?

    // A callback to help with handling purchase product completion
    private var purchaseCompletionCallback: PurchaseCompletionCallback?

    // An object that can retrieve product info from the App Store
    private var productsRequest: ProductsRequest?


    // MARK: - Init

    init(
        paymentQueue: PaymentQueue = SKPaymentQueue.default(),
        productsRequestFactory: ProductsRequestFactory = AppStoreProductsRequestFactory()
    ) {
        self.paymentQueue = paymentQueue
        self.productsRequestFactory = productsRequestFactory
        super.init()
        paymentQueue.add(self)
    }

    deinit {
        paymentQueue.remove(self)
    }

    // MARK: - Public

    func fetchProducts(for identifiers: Set<String>, completion: @escaping FetchCompletionCallback) {
        productsRequest = productsRequestFactory.createRequest(with: identifiers, completion: completion)
        productsRequest?.start()
    }

    func fetchProduct(for identifier: String) -> SKProduct? {
        guard let productsRequest = productsRequest else {
            return nil
        }

        return productsRequest.fetchedProducts.first(where: { $0.productIdentifier == identifier })
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
