import Combine
import Foundation

protocol Networking {

    func fetchProductSKUs() -> AnyPublisher<[String], Error>
    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error>
}

class NetworkingPlaceholder: Networking {

    func fetchProductSKUs() -> AnyPublisher<[String], Error> {

        let productIdentifiers = [
            "com.mobilepay.consumable.rocketfuel",
            "com.mobilepay.consumable.premiumrocketfuel"
        ]

        return Future { $0(.success(productIdentifiers)) }
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {

        let orderIdentifier = 1

        return Future { $0(.success(orderIdentifier)) }
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
