//
//  File.swift
//  
//
//  Created by USER on 2023/06/06.
//

import Foundation
import GiphyRepository

public final class GiphyURLSessionNetworkService: GiphyNetworkService {
    public enum Errors: LocalizedError {
        case failedToBuildRequest
        case badResponse
        case failedWith(statusCode: Int)

        public var errorDescription: String? {
            switch self {
            case .failedToBuildRequest: return "failed to build request"
            case .badResponse: return "bad response"
            case let .failedWith(statusCode): return "failed with statusCode: \(statusCode)"
            }
        }
    }

    private let decoder = JSONDecoder()

    public init() {}

    public func request<DTO>(
        domain: String,
        path: String?,
        method: HTTPMethod,
        parameters: [String : String]?,
        headers: [String : String]?,
        body: [String : Any]?
    ) async throws -> DTO where DTO : Decodable {
        guard let url = URL(string: domain + (path ?? "")) else { throw Errors.failedToBuildRequest }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = parameters?.compactMap { key, value in
            guard !key.isEmpty else { return nil }
            return URLQueryItem(name: key, value: value)
        } ?? []

        var urlRequest: URLRequest
        if let urlWithQueryItems = urlComponents?.url {
            urlRequest = URLRequest(url: urlWithQueryItems)
        }
        else {
            urlRequest = URLRequest(url: url)
        }

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers

        if let body = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Errors.badResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw Errors.failedWith(statusCode: httpResponse.statusCode)
        }

        return try decoder.decode(DTO.self, from: data)
    }
}
