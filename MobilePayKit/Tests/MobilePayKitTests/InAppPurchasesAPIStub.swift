import Combine
import Foundation
import MobilePayKit

class InAppPurchasesAPIStub: InAppPurchasesAPIProtocol {

    var fetchProductsResult: Result<[String], Error>?
    var createOrderResult: Result<Int, Error>?

    func fetchProductSKUs() -> AnyPublisher<[String], Error> {
        return fetchProductsResult!.publisher
            .delay(for: 0.01, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {
        return createOrderResult!.publisher
            .delay(for: 0.01, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
