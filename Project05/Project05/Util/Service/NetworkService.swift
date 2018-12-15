
//
//  NetworkService.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 31..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

public typealias HTTPBody = [String:Any]

// MAKR: HTTP method type
enum HTTPMethod: String {
    case GET
    case POST
}

// MARK: error message
enum EncodeError: String, Error {
    case urlEncodeError = "url is nil"
    case parameterEncodeError = "parameter encode failed"
}

// MARK: - network function : url parameters and body parameters
struct NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    public func request(_ url: String,
                        method: HTTPMethod = .GET,
                        parameters: HTTPBody? = nil,
                        completion: @escaping (Result<Data>) -> Swift.Void) {
        guard let URL: URL = URL(string: url) else { return }
        
        var request: URLRequest = URLRequest(url: URL)
        do {
            request.httpMethod = method.rawValue
            
            switch method {
            case .GET:
                try self.getURLParameterRequest(&request, parameters: parameters)
                
            case .POST:
                guard let params = parameters else { return }
                try self.getURLParameterRequest(&request)
                try self.getBodyParameterRequest(&request, parameters: params)
            }
        } catch let err {
            completion(.error(err.localizedDescription))
        }
        
        self.getRequest(request, completion: completion)
    }
    
    private func getURLParameterRequest(_ request: inout URLRequest,
                                        parameters: HTTPBody? = nil) throws {
        guard let URL = request.url else { throw EncodeError.urlEncodeError }
        if var components = URLComponents(url: URL, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters?.map { arg -> URLQueryItem in
                return URLQueryItem(name: arg.key, value: "\(arg.value)")
            }
            
            request.url = components.url
        }
    }
    
    private func getBodyParameterRequest(_ request: inout URLRequest,
                                         parameters: HTTPBody) throws {
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = httpBody
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw EncodeError.parameterEncodeError
        }
    }
    
    private func getRequest(_ request: URLRequest,
                            completion: @escaping (Result<Data>) -> Swift.Void) {
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, res, err) in
            
            let complete: (Result<Data>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, err == nil else {
                complete(.error(err?.localizedDescription ?? ""))
                return
            }
            complete(.success(data))
        }
        
        dataTask.resume()
    }
}
