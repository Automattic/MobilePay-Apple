import Foundation

protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

enum InAppPurchasesAPIRouter: URLRequestConvertible {

    private enum Constants {
        static let baseURLPath = "https://public-api.wordpress.com/wpcom/v2"
        static let token = "token"
    }

    case products
    case createOrder(parameters: CreateOrderParameters)

    var httpMethod: String {
        switch self {
        case .products:
            return "GET"
        case .createOrder:
            return "POST"
        }
    }

    var path: String {
        switch self {
        case .products:
            return "/iap/products"
        case .createOrder:
            return "/iap/orders"
        }
    }

    func asURLRequest() -> URLRequest {
        guard let baseURL = URL(string: Constants.baseURLPath) else {
            preconditionFailure("Invalid URL string: \(Constants.baseURLPath)")
        }

        var request = URLRequest(url: baseURL.appendingPathComponent(path))

        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        request.setValue(Bundle.main.bundleIdentifier, forHTTPHeaderField: "X-APP-ID")

        switch self {
        case .products:
            break
        case .createOrder(let parameters):
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
            } catch let error {
                print("error serializing parameters: \(error.localizedDescription)")
            }
        }

        return request
    }
}

struct CreateOrderParameters: Encodable {
    let product_id: String
    let price: Int
    let appstore_country: String
    let apple_receipt: String
}
