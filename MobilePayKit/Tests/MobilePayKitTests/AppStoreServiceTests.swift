import StoreKit
import XCTest

@testable import MobilePayKit

final class AppStoreServiceTests: XCTestCase {

    let spy = PaymentQueueSpy()
    let requestFactory = MockProductsRequestFactory()

    var service: AppStoreService!

    // MARK: - Override

    override func setUp() {
        super.setUp()
        service = AppStoreService(paymentQueue: spy, productsRequestFactory: requestFactory)
    }

    override func tearDown() {
        super.tearDown()
        service = nil
    }

    // MARK: - Tests

    func testInit_CallsAddObserver() {
        XCTAssertEqual(spy.addObserverCalled, true)
    }

    func testDeinit_CallsRemoveObserver() {
        service = nil

        XCTAssertEqual(spy.removeObserverCalled, true)
    }

    // MARK: - Fetch product
    
    func testfetchProducts_CreatesProductsRequestAndCallsStart() {
        // call fetchProducts

        XCTAssertNil(service.productsRequest)


        service.fetchProducts(for: Set([]), completion: { _ in })

        XCTAssertNotNil(requestFactory.request)
        XCTAssertEqual(requestFactory.request?.startCalled, true)
    }
    
    // MARK: - Purchase product

    func testPurchaseProduct_CallsAddPaymentToQueue() {
        let testProduct = SKProduct()

        service.purchaseProduct(testProduct, completion: { _ in })

        XCTAssertEqual(spy.addPaymentCalled, true)
    }

    func testRestorePurchases_CallsRestoresCompletedTransactions() {
        service.restorePurchases()

        XCTAssertEqual(spy.restoreCompletedTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsFailed_CallsFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .failed)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(spy.finishTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsPurchased_CallsFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .purchased)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(spy.finishTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsRestored_CallsFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .restored)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(spy.finishTransactionCalled, true)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsPurchasing_DoesNotCallFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .purchasing)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(spy.finishTransactionCalled, false)
    }

    func testPaymentQueueUpdatedTransactions_WhenTransactionStateIsDeferred_DoesNotCallFinishTransaction() {
        let transactions: [TestPaymentTransaction] = [
            .fixture(transactionState: .deferred)
        ]

        service.paymentQueue(SKPaymentQueue(), updatedTransactions: transactions)

        XCTAssertEqual(spy.finishTransactionCalled, false)
    }

}
