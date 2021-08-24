import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

@testable import MobilePayKit

final class InAppPurchasesServiceTests: XCTestCase {

    var service: InAppPurchasesService!

    private let testDomain = "iap.test"
    private let testOrderId = "123"
    private let testOrderPrice = 100

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Override

    override func setUp() {
        super.setUp()
        service = InAppPurchasesService(configuration: .fixture())
    }

    override func tearDown() {
        service = nil
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }

    // MARK: - Fetch product SKUs

    func testFetchProductSKUs_WhenRequestSucceeds_PublishesDecodedSKUs() throws {

        let expectation = XCTestExpectation(description: "Publishes decoded [String]")

        stubRemoteResponse("/wpcom/v2/iap/products", filename: "iap-products-success.json")

        service.fetchProductSKUs()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { productIds in
                    XCTAssertEqual(productIds.count, 3)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProductSKUs_WhenRequestFails_PublishesReceivedError() throws {

        let expectation = XCTestExpectation(description: "Publishes received error")

        stubRemoteResponse("/wpcom/v2/iap/products", filename: "iap-products-success.json", status: 503)

        service.fetchProductSKUs()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Expected to fail")
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - Create order

    func testCreateOrder_WhenRequestSucceeds_PublishesDecodedOrderIds() throws {

        let expectation = XCTestExpectation(description: "Publishes decoded Int")

        stubRemoteResponse("/wpcom/v2/iap/orders", filename: "iap-orders-success.json")

        service.createOrder(orderId: testOrderId, price: testOrderPrice, country: "", receipt: "")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { orderId in
                    XCTAssertEqual(orderId, 123)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testCreateOrder_WhenRequestFails_PublishesReceivedError() throws {

        let expectation = XCTestExpectation(description: "Publishes received error")

        stubRemoteResponse("/wpcom/v2/iap/orders", filename: "iap-orders-success.json", status: 503)

        service.createOrder(orderId: testOrderId, price: testOrderPrice, country: "", receipt: "")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Expected to fail")
                }
            )
            .store(in: &cancellables)
    }
}

extension InAppPurchasesServiceTests {

    func stubRemoteResponse(_ endpoint: String, filename: String, status: Int32 = 200) {
        stub(condition: { request in
            return request.url?.absoluteString.range(of: endpoint) != nil
        }) { _ in
            let stubPath = OHPathForFile(filename, type(of: self))
            let headers = ["Content-Type" as NSObject: "application/json" as AnyObject]

            return fixture(filePath: stubPath!, status: status, headers: headers)
        }
    }
}
