import Combine
import Foundation

extension URLSession: Networking {

    public func load(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        return dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}
