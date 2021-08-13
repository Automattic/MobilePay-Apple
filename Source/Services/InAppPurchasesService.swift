import Combine
import Foundation

public protocol InAppPurchasesServiceProtocol {
    func fetchProductSKUs() -> AnyPublisher<[String], Error>
    func createOrder(orderId: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error>
}

class InAppPurchasesService: InAppPurchasesServiceProtocol {

    private let configuration: MobilePayKitConfiguration

    private let networking: Networking

    init(configuration: MobilePayKitConfiguration, networking: Networking = URLSession.shared) {
        self.configuration = configuration
        self.networking = networking
    }

    func fetchProductSKUs() -> AnyPublisher<[String], Error> {

        let request = createURLRequest(for: .products)

        return networking.load(request)
            .decode(type: [String].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createOrder(orderId: String, price: Int, country: String, receipt: String) -> AnyPublisher<Int, Error> {

        let parameters = CreateOrderParameters(
            site_id: configuration.siteId,
            product_id: orderId,
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

// MARK: - API Errors

struct InAppPurchasesServiceError: Error, Codable {
    let code: String
    let message: String
}

extension InAppPurchasesServiceError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
