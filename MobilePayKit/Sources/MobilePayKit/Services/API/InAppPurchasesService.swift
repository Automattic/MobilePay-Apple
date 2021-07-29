import Combine
import Foundation

class InAppPurchasesService {

    let api: InAppPurchasesAPIProtocol

    init(api: InAppPurchasesAPIProtocol = InAppPurchasesAPI()) {
        self.api = api
    }

    func fetchProductSKUs() -> AnyPublisher<[String], Error> {
        return api.fetchProductSKUs()
    }

    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {
        return api.createOrder(identifier: identifier, price: price, country: country, receipt: receipt)
    }
}
