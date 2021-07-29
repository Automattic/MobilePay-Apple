import Alamofire
import Foundation

protocol APIRequest {

    associatedtype Response: Decodable

    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
}

enum APIConstants {

    enum Endpoint {
        case products
        case createOrder

        var path: String {
            switch self {
            case .products:
                return "iap/products"
            case .createOrder:
                return "iap/orders"
            }
        }
    }

    static var baseURL: String {
        return "https://public-api.wordpress.com/wpcom/v2"
    }

    static var headers: HTTPHeaders {
        return [
            .authorization(bearerToken: "oauthToken"),
            HTTPHeader(name: "X-APP-ID", value: "appBundleID")
        ]
    }
}

extension APIRequest {

    var baseURL: String {
        return APIConstants.baseURL
    }

    var headers: HTTPHeaders {
        return APIConstants.headers
    }
}

struct FetchProductRequest: APIRequest {

    typealias Response = [String]

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return APIConstants.Endpoint.products.path
    }

    var parameters: Parameters? {
        return nil
    }
}

struct CreateOrderRequest: APIRequest {

    typealias Response = Int

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return APIConstants.Endpoint.createOrder.path
    }

    var parameters: Parameters? {
        return [
            "customer_id": identifier,
            "price": price,
            "appstore_country": country,
            "apple_receipt": receipt
        ]
    }

    let identifier: String
    let price: Int
    let country: String
    let receipt: String
}
