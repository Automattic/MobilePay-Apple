import Combine
import Foundation

protocol Networking {
    func load<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}
