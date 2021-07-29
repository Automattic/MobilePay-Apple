import Alamofire
import Foundation

enum InAppPurchasesAPIRouter: URLRequestConvertible {

    private enum Constants {
        static let baseURLPath = "https://public-api.wordpress.com/wpcom/v2"
    }

    case products
    case createOrder(parameters: CreateOrderParameters)

    var method: HTTPMethod {
        switch self {
        case .products:
            return .get
        case .createOrder:
            return .post
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

    var headers: HTTPHeaders {
        return [
            .authorization(bearerToken: "oauthToken"),
            HTTPHeader(name: "X-APP-ID", value: "appBundleID")
        ]
    }

    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()

        var request = try URLRequest(
            url: url.appendingPathComponent(path),
            method: method,
            headers: headers
        )

        switch self {
        case .products:
            break
        case .createOrder(let parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }

        return request
    }
}

struct CreateOrderParameters: Encodable {
    let customer_id: String
    let order_id: Int
    let appstore_country: String
    let apple_receipt: String
}
