import Combine
import XCTest

@testable import MobilePayKit

final class InAppPurchasesServiceTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testFetchProducts_WhenReqeustSucceeds_PublishesDecodedSkus() throws {

        let json = """
        [
            "com.product.1",
            "com.product.2",
            "com.product.3"
        ]
        """

        let data = try XCTUnwrap(json.data(using: .utf8))

        let service = InAppPurchasesService(networking: NetworkingStub(returning: .success(data)))

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

    func testFetchProducts_WhenRequestFails_PublishesReceivedError() throws {

        let expectedError = URLError(.badServerResponse)

        let service = InAppPurchasesService(networking: NetworkingStub(returning: .failure(expectedError)))

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
