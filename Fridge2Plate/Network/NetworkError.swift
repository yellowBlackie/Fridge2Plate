import Foundation

enum NetworkError: LocalizedError {

    case invalidURL
    case transport(URLError)
    case invalidResponse
    case httpStatus(Int)
    case decoding

    var errorDescription: String? {
        switch self {

        case .invalidURL:
            return "Invalid request URL."

        case .transport(let error):
            return "Network connection failed: \(error.localizedDescription)"

        case .invalidResponse:
            return "Invalid server response."

        case .httpStatus(let code):
            return "Server returned HTTP status \(code)."

        case .decoding:
            return "Unable to read data received from the server."
        }
    }
}