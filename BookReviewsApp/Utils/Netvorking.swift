//
//  Netvorking.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkingRouter {
    case getCategorys
    case getBooks(category: String)
}

extension NetworkingRouter {
    var method: HTTPMethod {
        switch self {
        case .getCategorys, .getBooks:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getCategorys:
            return "lists/names.json"
        case .getBooks:
            return "lists.json"
        }
    }

    var queryItem: [URLQueryItem] {
        switch self {
        case .getCategorys:
            return [
                URLQueryItem(name: "api-key", value: ApiConstants.apiKey)
            ]
        case .getBooks(let category):
            return [
                URLQueryItem(name: "api-key", value: ApiConstants.apiKey),
                URLQueryItem(name: "list", value: category)
            ]
        }
    }


    func asURLRequest() throws -> URLRequest {
        var url = URL(string: ApiConstants.baseUrl)!
        url.append(queryItems: queryItem)

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = Double.infinity
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }
}

struct ApiConstants {
    static let baseUrl: String = "https://api.nytimes.com/svc/books/v3/"
    static let apiKey: String = "PnGAAD62yzo5B0UOK9xKTV9yp02OWmJr"
}

class NetworkManager{
    // MARK: - fetchBookData - complition
//    func fetchBookData(with category: String, _ complition: @escaping ((BookData)->Void)){
//
//        let request = try? Router.getBooks(category: category).asURLRequest()
//        print(request!)
//        URLSession.shared.dataTask(with: request!) {data, respons, error in
//
//            guard let respons = respons else { return }
//            let httpurlResponse = respons as? HTTPURLResponse
//            print("respons1.statusCode = \(httpurlResponse?.statusCode ?? 0)" )
//
//            guard let responsData = data else { return }
////            print(responsData)
//
//            let posts = try? JSONDecoder().decode(BookData.self, from: responsData)
////            print(posts as Any)
//            complition(posts ?? BookData(results: []))
//
//            if error != nil {
//                print(error as Any)
//            }
//
//        }.resume()
//    }

    // MARK: - fetchBookData - async

    func fetchCategoryData() async throws -> CategorysData{

        let request = try? NetworkingRouter.getCategorys.asURLRequest()
        print(request!)

        let session = URLSession.shared
        let (data, respons) = try await session.data(for: request!)
        print(data)

        let httpurlResponse = respons as? HTTPURLResponse
        print("respons1.statusCode = \(httpurlResponse?.statusCode ?? 0)" )

        let decoder = JSONDecoder()
        return try decoder.decode(CategorysData.self, from: data)

    }


    func fetchBookData(with category: String) async throws -> BookData{

        let request = try? NetworkingRouter.getBooks(category: category).asURLRequest()
        print(request!)

        let session = URLSession.shared
        let (data, respons) = try await session.data(for: request!)
        print(data)

        let httpurlResponse = respons as? HTTPURLResponse
        print("respons1.statusCode = \(httpurlResponse?.statusCode ?? 0)" )

        let decoder = JSONDecoder()
        return try decoder.decode(BookData.self, from: data)

    }
}



enum APIError: Error {
    case badRequest
    case serverError
    case unknown
}

protocol APIRequestProtocol {
    func get(request: URLRequest) async throws -> Result<Data, Error>
}

final class APIRequest: APIRequestProtocol {

    func get(request: URLRequest) async throws -> Result<Data, Error> {
        let (data, response) = try await URLSession.shared.data(for: request)
        return verifyResponse(data: data, response: response)
    }

    private func verifyResponse(data: Data, response: URLResponse) -> Result<Data, Error> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(APIError.unknown)
        }

        switch httpResponse.statusCode {
        case 200...299:
            return .success(data)
        case 400...499:
            return .failure(APIError.badRequest)
        case 500...599:
            return .failure(APIError.serverError)
        default:
            return .failure(APIError.unknown)

        }
    }
}


protocol CategoryAPIProtocol {
    func fetchCategory() async throws -> CategorysData?
}

protocol BookAPIProtocol {
    func fetchBook(with category: String) async throws -> BookData?
}

enum ComputerAPIError: Error {
    case nilRequest
    case invalidResponseFormat
}

final class APIService: CategoryAPIProtocol, BookAPIProtocol {
    private let apiRequest: APIRequestProtocol

    init(apiRequest: APIRequestProtocol = APIRequest()) {
        self.apiRequest = apiRequest
    }

    func fetchBook(with category: String) async throws -> BookData? {

        let request = try? NetworkingRouter.getBooks(category: category).asURLRequest()
        guard let urlRequest = request else {
            throw ComputerAPIError.nilRequest
        }

        let apiData = try await apiRequest.get(request: urlRequest)
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(BookData.self, from: data)
            } catch {
                throw ComputerAPIError.invalidResponseFormat
            }

        case .failure(let error):
            throw error
        }
    }


    func fetchCategory() async throws -> CategorysData? {

        let request = try? NetworkingRouter.getCategorys.asURLRequest()
        guard let urlRequest = request else {
            throw ComputerAPIError.nilRequest
        }

        let apiData = try await apiRequest.get(request: urlRequest)
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(CategorysData.self, from: data)
            } catch {
                throw ComputerAPIError.invalidResponseFormat
            }

        case .failure(let error):
            throw error
        }
    }

}

