import Combine
import Foundation

extension Publisher where Output == (Data, URLResponse) {

    func decode<T: Decodable, E: Error&Decodable>(
        type: T.Type,
        errorType: E.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Publishers.FlatMap<AnyPublisher<T, Error>, Self> {

        self.flatMap { (data, response) -> AnyPublisher<T, Error> in

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {

                return Just(data)
                    .decode(type: errorType, decoder: decoder)
                    .flatMap { Fail(error: $0) }
                    .eraseToAnyPublisher()
            }

            return Just(data)
                .decode(type: type, decoder: decoder)
                .eraseToAnyPublisher()
        }
    }
}
