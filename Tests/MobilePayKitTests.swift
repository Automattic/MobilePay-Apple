import XCTest

@testable import MobilePayKit

class MobilePayKitTests: XCTestCase {

    var mobilePayKit: MobilePayKit!

    let configuration = MobilePayKitConfiguration.fixture()
    let appStoreService = MockAppStoreService()

    // MARK: - Override

    override func setUp() {
        super.setUp()
        mobilePayKit = MobilePayKit(configuration: configuration, appStoreService: appStoreService)
    }

    override func tearDown() {
        super.tearDown()
        mobilePayKit = nil
    }

    // MARK: - Tests

    func testFetchProducts_CallsFetchProducts() {
        mobilePayKit.fetchProducts(completion: { _ in })

        XCTAssertEqual(appStoreService.fetchProductsCalled, true)
    }

    func testPurchaseProduct_CallsFetchProductAndPurchaseProduct() {
        let identifier = "1"

        mobilePayKit.purchaseProduct(with: identifier, completion: { _ in })

        XCTAssertEqual(appStoreService.fetchProductForIdentifierCalled, true)
        XCTAssertEqual(appStoreService.productIdentifier, identifier)
        XCTAssertEqual(appStoreService.purchaseProductCalled, true)
    }

    func testRestorePurchases_CallsRestorePurchases() {
        mobilePayKit.restorePurchases()

        XCTAssertEqual(appStoreService.restorePurchasesCalled, true)
    }

}
