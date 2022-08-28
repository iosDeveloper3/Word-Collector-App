//
//  NetworkService.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

// based on https://www.youtube.com/playlist?list=PLgBVHL8joMCthoqCwsWAUWIiyJaPrqPA4
struct NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchEntries(for word: String, completion: @escaping (Result<[Entry], Error>) -> Void) {
        request(route: DictionaryRoute.entries(word), method: .get, completion: completion)
    }
    
    private func request<T: Decodable>(route: Route, method: Method, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(APIInteractionError.unableToCreateRequest))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
            } else if let error = error {
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
        }.resume()
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void) {
        guard let result = result else {
            completion(.failure(APIInteractionError.noAPIResponse))
            return
        }

        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(T.self, from: data) {
                completion(.success(response))
            }
            else {
                completion(.failure(APIInteractionError.responseDecodingError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func createRequest(route: Route, method: Method, parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = route.baseUrl + route.endpoint
        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post, .delete, .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
}
