//
//  AstellaService.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import Foundation

final class AstellaService : ObservableObject {
    private init() {}
    /// Shared singleton instance
    static let shared = AstellaService()
    private let cachManager = ApiCacheManger()
    
    enum ServiceError : Error {
        case failedToCreateRequest
        case failedToGetData

    }
    
    
    /// - Parameters
    ///     - request : Request Instance
    ///     - expecting : Data type we are expecting to recieve
    ///     - completion : Callback with data or error
    ///
    public func execute<T : Codable> (
        _ request : RequestPostService,
        expecting type : T.Type,
        completion : @escaping (Result<T, Error>) -> Void
    ) {
        if let cachedData = cachManager.cacheResponse(for: request.endpoint, url: request.url) {
            do {
                print("Using cache for \(request.endpoint)")
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
                return
            } catch {
                completion(.failure(error))
            }
        }
        guard let urlRequest = self.request(from: request) else {
            print("Unable to create URL request in Execute")
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, err in
            guard let data = data, err == nil else {
                completion(.failure(err ?? ServiceError.failedToCreateRequest))
                return
            }
            //Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cachManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    

    public func execute<T : Codable> (
        _ request : RequestGetService,
        expecting type : T.Type,
        completion : @escaping (Result<T, Error>) -> Void
    ) {
        if let cachedData = cachManager.cacheResponse(for: request.endpoint, url: request.url) {
            do {
                print("Using cache for \(request.endpoint)")
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
                return
            } catch {
                completion(.failure(error))
            }
        }
        
        guard let urlRequest = self.request(from: request) else {
            print("Unable to create URL request in Execute")
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, err in
            guard let data = data, err == nil else {
                completion(.failure(err ?? ServiceError.failedToCreateRequest))
                return
            }
            //Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cachManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: - POST Formdata
    public func execute<T : Codable> (
        _ request : RequestMultipartForm,
        expecting type : T.Type,
        completion : @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            print("Unable to create URL request in Execute")
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.uploadTask(with: urlRequest, from: request.createMultipartFormData(), completionHandler: { data, response, err in
            guard let data = data, err == nil else {
                completion(.failure(err ?? ServiceError.failedToCreateRequest))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            
        })
        task.resume()
    }
    
    //MARK: - POST
    private func request(from incommingReq : RequestPostService) -> URLRequest? {
        do {
            guard let url : URL = incommingReq.url else { return  nil}
            var request = buildRequest(url: url, method: incommingReq.httpMethod)
            let encoder = JSONEncoder()
            let data = try encoder.encode(incommingReq.httpBody)
            request.httpBody = data
            return request
        } catch {
            print("Unable to encode jsonData: " + String(describing: incommingReq.httpBody))
            return nil
        }
    }
    
    //MARK: - GET
    private func request(from incommingReq : RequestGetService) -> URLRequest? {
            guard let url : URL = incommingReq.url else { return  nil}
        return buildRequest(url: url, method: "GET")
    }
    
    //MARK: - Multipart
    private func request(from incommingReq : RequestMultipartForm) -> URLRequest? {
        guard let url : URL = incommingReq.url else { return  nil}
        let request = buildRequestMultipart(url: url, method: incommingReq.httpMethod, boundary: incommingReq.boundary)
        return request
    }
    
    //MARK: - Building request
    private func buildRequest(url : URL, method : String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func buildRequestMultipart(url : URL, method : String, boundary : String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func removeFromCache(endpoint : AstellaEndpoints) {
        cachManager.removeCache(for: endpoint)
    }
    
}
