import StoreKit
import XCTest

@testable import MobilePayKit

final class AppStoreServiceTests: XCTestCase {

    let spy = PaymentQueueSpy()

    var service: AppStoreService!

    // MARK: - Override

    override func setUp() {
        super.setUp()
        service = AppStoreService(paymentQueue: spy)
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

    func testPurchaseProduct_CallsAddPaymentToQueue() {
        let testProduct = SKProduct()

        service.purchaseProduct(testProduct, completion: { _ in })

        XCTAssertEqual(spy.addPaymentCalled, true)
    }
    
    func testRestorePurchases_CallsRestoresCompletedTransactions() {
        service.restorePurchases()

        XCTAssertEqual(spy.restoreCompletedTransactionCalled, true)
    }

}
