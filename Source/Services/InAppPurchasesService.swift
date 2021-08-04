import Combine
import Foundation

protocol InAppPurchasesServiceProtocol {
    func fetchProductSKUs() -> AnyPublisher<[String], Error>
    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error>
}

class InAppPurchasesService: InAppPurchasesServiceProtocol {

    let networking: Networking

    init(networking: Networking = URLSession.shared) {
        self.networking = networking
    }

    func fetchProductSKUs() -> AnyPublisher<[String], Error> {

        let request = InAppPurchasesAPIRouter.products.asURLRequest()

        return networking.load(request)
            .decode(type: [String].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {

//        FIXME: send actual request
//
//        let parameters = CreateOrderParameters(
//            product_id: identifier,
//            price: price,
//            appstore_country: country,
//            apple_receipt: receipt
//        )
//
//        let request = InAppPurchasesAPIRouter.createOrder(parameters: parameters).asURLRequest()
//
//        return networking.load(request)
//            .decode(type: Int.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()

        let orderIdentifier = 1

        return Future { $0(.success(orderIdentifier)) }
            .eraseToAnyPublisher()
    }

}
