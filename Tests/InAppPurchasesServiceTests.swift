import Combine
import XCTest

@testable import MobilePayKit

final class InAppPurchasesServiceTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testFetchProductSKUs_WhenRequestSucceeds_PublishesDecodedSKUs() throws {

        let json = """
        [
            "com.product.1",
            "com.product.2",
            "com.product.3"
        ]
        """

        let data = try XCTUnwrap(json.data(using: .utf8))

        let service = InAppPurchasesService(
            configuration: .fixture(),
            networking: NetworkingStub(returning: .success(data))
        )

        let expectation = XCTestExpectation(description: "Publishes decoded [String]")

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

        let expectedError = URLError(.badServerResponse)

        let service = InAppPurchasesService(
            configuration: .fixture(),
            networking: NetworkingStub(returning: .failure(expectedError))
        )

        let expectation = XCTestExpectation(description: "Publishes received URLError")

        service.fetchProductSKUs()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure(let error) = completion else {
                        return
                    }

                    XCTAssertEqual(error as? URLError, expectedError)

                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Expected to fail")
                }
            )
            .store(in: &cancellables)
    }

    func testCreateOrder_WhenRequestSucceeds_PublishesDecodedOrderIds() throws {

        let json = """
        {
            "order_id": 123
        }
        """

        let data = try XCTUnwrap(json.data(using: .utf8))

        let service = InAppPurchasesService(
            configuration: .fixture(),
            networking: NetworkingStub(returning: .success(data))
        )

        let expectation = XCTestExpectation(description: "Publishes decoded Int")

        service.createOrder(orderId: "1", price: 100, country: "", receipt: "")
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

        let expectedError = URLError(.badServerResponse)

        let service = InAppPurchasesService(
            configuration: .fixture(),
            networking: NetworkingStub(returning: .failure(expectedError))
        )

        let expectation = XCTestExpectation(description: "Publishes received URLError")

        service.createOrder(orderId: "1", price: 100, country: "", receipt: "")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure(let error) = completion else {
                        return
                    }

                    XCTAssertEqual(error as? URLError, expectedError)

                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Expected to fail")
                }
            )
            .store(in: &cancellables)
    }
}
