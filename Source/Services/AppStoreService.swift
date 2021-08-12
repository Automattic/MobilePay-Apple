import Combine
import Foundation
import StoreKit

public typealias FetchCompletionCallback = (ProductsResult) -> Void
public typealias PurchaseCompletionCallback = (TransactionResult) -> Void

public typealias ProductsResult = Result<[SKProduct], Error>
public typealias TransactionResult = Result<SKPaymentTransaction, Error>

public protocol AppStoreServiceProtocol {
    func fetchProducts(completion: @escaping FetchCompletionCallback)
    func fetchProduct(for identifier: String) -> SKProduct?
    func purchaseProduct(_ product: SKProduct, completion: @escaping PurchaseCompletionCallback)
    func restorePurchases()
}

public class AppStoreService: NSObject, AppStoreServiceProtocol {

    public enum PurchaseError: Error {
        case missingProduct
        case missingReceipt
        case invalidReceipt
    }

    private let iapService: InAppPurchasesServiceProtocol

    private let paymentQueue: PaymentQueue

    private let productsRequestFactory: ProductsRequestFactory

    private var cancellables = Set<AnyCancellable>()

    // A callback to help with handling purchase product completion
    private var purchaseCompletionCallback: PurchaseCompletionCallback?

    // An object that can retrieve product info from the App Store
    private(set) var productsRequest: ProductsRequest?

    // The product being purchased
    private var purchasingProduct: SKProduct?

    // MARK: - Init

    init(
        configuration: MobilePayKitConfiguration,
        iapService: InAppPurchasesServiceProtocol? = nil,
        paymentQueue: PaymentQueue = SKPaymentQueue.default(),
        productsRequestFactory: ProductsRequestFactory = AppStoreProductsRequestFactory()
    ) {
        self.iapService = iapService ?? InAppPurchasesService(configuration: configuration)
        self.paymentQueue = paymentQueue
        self.productsRequestFactory = productsRequestFactory
        super.init()
        paymentQueue.add(self)
    }

    deinit {
        paymentQueue.remove(self)
    }

    // MARK: - Public

    public func fetchProducts(completion: @escaping FetchCompletionCallback) {
        iapService.fetchProductSKUs()
            .sink(
                receiveCompletion: { fetchSkusCompletion in

                    switch fetchSkusCompletion {
                    case .finished:
                        print("fetch products finished")
                    case .failure(let error):
                        completion(.failure(error))
                    }

                },
                receiveValue: { [weak self] skus in
                    let productIdentifiers = Set(skus)
                    self?.fetchProducts(for: productIdentifiers, completion: completion)
                }
            )
            .store(in: &cancellables)
    }

    func fetchProducts(for identifiers: Set<String>, completion: @escaping FetchCompletionCallback) {
        productsRequest = productsRequestFactory.createRequest(with: identifiers, completion: completion)
        productsRequest?.start()
    }

    public func fetchProduct(for identifier: String) -> SKProduct? {
        guard let productsRequest = productsRequest else {
            return nil
        }

        return productsRequest.fetchedProducts.first(where: { $0.productIdentifier == identifier })
    }

    public func purchaseProduct(_ product: SKProduct, completion: @escaping PurchaseCompletionCallback) {

        // Initialize the product being purchased
        purchasingProduct = product

        // Initialize the handler
        purchaseCompletionCallback = completion

        // Submit the payment request to the App Store by adding it to the payment queue
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }

    public func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }

}

// MARK: - SKPaymentTransactionObserver

extension AppStoreService: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {

            case .purchasing,
                 .deferred:
                // FIXME: ignore for now
                break

            case .failed:
                handleFailedTransaction(transaction)

            case .purchased,
                 .restored:
                handleCompletedTransaction(transaction)

            @unknown default:
                print("Unexpected transaction state: \(transaction.transactionState)")
            }
        }
    }

    private func handleFailedTransaction(_ transaction: SKPaymentTransaction) {

        guard let error = transaction.error else {
            return
        }

        paymentQueue.finishTransaction(transaction)

        performPurchaseCompletionCallback(.failure(error))
    }

    private func handleCompletedTransaction(_ transaction: SKPaymentTransaction) {

        guard let product = purchasingProduct else {
            purchaseCompletionCallback?(.failure(PurchaseError.missingProduct))
            return
        }

        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            purchaseCompletionCallback?(.failure(PurchaseError.missingReceipt))
            return
        }

        // TODO: remove later
        let bundle = Bundle(for: type(of: self))
        guard let debugReceiptPath = bundle.path(forResource: "debug-receipt", ofType: "txt") else {
            print("Could not find debug receipt")
            return
        }

        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            print(receiptData)

            let receiptString = receiptData.base64EncodedString(options: [])

            // TODO: remove later
            let debugReceiptString = try String(contentsOfFile: debugReceiptPath, encoding: String.Encoding.utf8)
                .trimmingCharacters(in: .newlines)

            createOrder(for: product, transaction: transaction, receipt: debugReceiptString)

        } catch {
            purchaseCompletionCallback?(.failure(PurchaseError.invalidReceipt))
        }
    }

    private func createOrder(for product: SKProduct, transaction: SKPaymentTransaction, receipt: String) {

        let country = paymentQueue.storefront?.countryCode ?? ""

        iapService.createOrder(
            identifier: product.productIdentifier,
            price: product.priceInCents,
            country: country,
            receipt: receipt
        )
        .sink(
            receiveCompletion: { [weak self] completion in

                switch completion {
                case .finished:
                    print("create order finished")
                case .failure(let error):
                    self?.performPurchaseCompletionCallback(.failure(error))
                }

            },
            receiveValue: { [weak self] orderId in

                print("created order for: \(orderId)")

                // Finish the transaction once we've successfully created an order remotely
                self?.paymentQueue.finishTransaction(transaction)

                self?.performPurchaseCompletionCallback(.success(transaction))
            }
        )
        .store(in: &cancellables)
    }

    private func performPurchaseCompletionCallback(_ result: TransactionResult) {
        DispatchQueue.main.async {
            self.purchaseCompletionCallback?(result)
            self.purchaseCompletionCallback = nil
        }
    }
}
