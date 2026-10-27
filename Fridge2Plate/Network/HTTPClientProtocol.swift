import Foundation

protocol HTTPClientProtocol {
    func get(from url: URL) async throws -> Data
}