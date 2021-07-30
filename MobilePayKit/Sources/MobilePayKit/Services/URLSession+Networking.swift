import Combine
import Foundation

extension URLSession: Networking {

    func load<T>(_ request: URLRequest) -> AnyPublisher<T, Error> where T: Decodable {
        return dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
