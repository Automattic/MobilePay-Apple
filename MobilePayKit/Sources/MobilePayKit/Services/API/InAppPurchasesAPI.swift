import Alamofire
import Combine
import Foundation

public protocol InAppPurchasesAPIProtocol {

    func fetchProductSKUs() -> AnyPublisher<[String], Error>
    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error>
}

class InAppPurchasesAPI: InAppPurchasesAPIProtocol {

    func fetchProductSKUs() -> AnyPublisher<[String], Error> {

        // FIXME: send actual request

        let productIdentifiers = [
            "com.mobilepay.consumable.rocketfuel",
            "com.mobilepay.consumable.premiumrocketfuel"
        ]

        return Future { $0(.success(productIdentifiers)) }
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {

        // FIXME: send actual request

        let orderIdentifier = 1

        return Future { $0(.success(orderIdentifier)) }
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func request<T>(urlRequest: URLRequestConvertible) -> AnyPublisher<T, AFError> where T: Decodable {
        return AF.request(urlRequest)
            .publishDecodable(type: T.self)
            .value()
    }
}
