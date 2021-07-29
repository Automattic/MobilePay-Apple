import Combine
import XCTest

@testable import MobilePayKit

final class InAppPurchasesServiceTests: XCTestCase {

    var service: InAppPurchasesService!

    var apiStub = InAppPurchasesAPIStub()

    var cancellables = Set<AnyCancellable>()

    // MARK: - Override

    override func setUp() {
        super.setUp()
        service = InAppPurchasesService(api: apiStub)
    }

    override func tearDown() {
        super.tearDown()
        service = nil
    }

    func testFetchProducts_WhenReqeustSucceeds_PublishesDecodedIds() throws {

        let json = """
        [
            "com.product.1",
            "com.product.2"
        ]
        """

        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try JSONDecoder().decode([String].self, from: data)

        apiStub.fetchProductsResult = .success(decoded)

        let expectation = XCTestExpectation(description: "Publishes decoded [String]")

        service.fetchProductSKUs()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { productIds in
                    XCTAssertEqual(productIds.count, 2)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProducts_WhenRequestFails_PublishesReceivedError() {
        let expectedError = URLError(.badServerResponse)

        apiStub.fetchProductsResult = .failure(expectedError)

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
                receiveValue: { productIds in
                    XCTFail("Expected to fail")
                }
            )
            .store(in: &cancellables)
    }
}
