import Combine
import Foundation

public protocol Networking {
    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError>
}
