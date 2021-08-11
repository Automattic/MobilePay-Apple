import Combine
import Foundation

protocol InAppPurchasesServiceProtocol {
    func fetchProductSkus() -> AnyPublisher<[String], Error>
    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error>
}

class InAppPurchasesService: InAppPurchasesServiceProtocol {

    private let configuration: MobilePayKitConfiguration

    private let networking: Networking

    init(configuration: MobilePayKitConfiguration, networking: Networking = URLSession.shared) {
        self.configuration = configuration
        self.networking = networking
    }

    func fetchProductSkus() -> AnyPublisher<[String], Error> {

        let request = createURLRequest(for: .products)

        return networking.load(request)
            .decode(type: [String].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createOrder(identifier: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {

        let parameters = CreateOrderParameters(
            product_id: identifier,
            price: price,
            appstore_country: country,
            apple_receipt: receipt
        )

        let request = createURLRequest(for: .createOrder(parameters: parameters))

        return networking.load(request)
            .decode(type: CreateOrderResponse.self, decoder: JSONDecoder())
            .map { $0.orderId }
            .eraseToAnyPublisher()
    }

    private func createURLRequest(for endpoint: InAppPurchasesAPIRouter) -> URLRequest {
        return endpoint.asURLRequest(with: configuration)
    }
}
