import Foundation

final class URLSessionHTTPClient: HTTPClientProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL) async throws -> Data {

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(
                from: url
            )
        } catch let error as URLError {
            throw NetworkError.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatus(
                httpResponse.statusCode
            )
        }

        return data
    }
}