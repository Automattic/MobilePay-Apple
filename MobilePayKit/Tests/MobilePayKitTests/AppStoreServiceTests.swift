import StoreKit
import XCTest

@testable import MobilePayKit

final class AppStoreServiceTests: XCTestCase {

    var service: AppStoreService!

    let paymentQueue = MockPaymentQueue()
    let requestFactory = MockProductsRequestFactory()

    // MARK: - Override

    override func setUp() {
        super.setUp()
        service = AppStoreService(paymentQueue: paymentQueue, productsRequestFactory: requestFactory)
    }

    override func tearDown() {
        super.tearDown()
        service = nil
    }

    // MARK: - Init

    func testInit_CallsAddObserver() {
        XCTAssertEqual(paymentQueue.addObserverCalled, true)
    }

    func testDeinit_CallsRemoveObserver() {
        service = nil

        XCTAssertEqual(paymentQueue.removeObserverCalled, true)
    }

    // MARK: - Fetch product

    func testfetchProducts_CreatesProductsRequestAndCallsStart() {
        XCTAssertNil(service.productsRequest)

        service.fetchProducts(for: Set([]), completion: { _ in })

        XCTAssertNotNil(requestFactory.request)
        XCTAssertEqual(requestFactory.request?.startCalled, true)
    }

    // MARK: - Purchase product

    func testPurchaseProduct_CallsAddPaymentToQueue() {
        let testProduct = SKProduct()

        service.purchaseProduct(testProduct, completion: { _ in })

        XCTAssertEqual(paymentQueue.addPaymentCalled, true)
    }

    // MARK: - Restore purchases

    func testRestorePurchases_CallsRestoresCompletedTransactions() {
        service.restorePurchases()

        XCTAssertEqual(paymentQueue.restoreCompletedTransactionCalled, true)
    }

    // MARK: - Payment queue updated transactions

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsFailed_CallsFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .failed)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(paymentQueue.finishTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsPurchased_CallsFinishTransaction() throws {

        try XCTSkipIf(true, "skipping this for now, need to stub receipt and mock iapService for this test to pass")

        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .purchased)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(paymentQueue.finishTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsRestored_CallsFinishTransaction() throws {

        try XCTSkipIf(true, "skipping this for now, need to stub receipt and mock iapService for this test to pass")

        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .restored)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(paymentQueue.finishTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsPurchasing_DoesNotCallFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .purchasing)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(paymentQueue.finishTransactionCalled, false)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsDeferred_DoesNotCallFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .deferred)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(paymentQueue.finishTransactionCalled, false)
    }

}
