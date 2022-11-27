//
//  NetworkService.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation
import Alamofire

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}

final class NetworkService {
    static let shared: NetworkService = NetworkService()

    let queue = DispatchQueue(label: "com.nsu.kravchenko.nailit", qos: .userInitiated, attributes: .concurrent)

    func request(_ url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 contentType: ContentType? = nil,
                 authorizationToken: String? = nil,
                 accept: ContentType? = nil,
                 completion: ((ServerResponse) -> Void)? = nil) -> DataRequest {

        let interceptor = NetworkRequestInterceptor(contentType: contentType, authorizationToken: authorizationToken, accept: accept)

        let request = AF.request(url,
                                 method: method,
                                 parameters: parameters,
                                 encoding: encoding,
                                 interceptor: interceptor)
        request
            .validate()
            .response(queue: queue) { response in
                switch response.result {
                case .success(let data):
                    let networkError = NetworkError(rawValue: response.error?.responseCode ?? 0)
                    completion?(ServerResponse(data: data, error: networkError, handler: request))
                case .failure(let error):
                    let networkError = NetworkError(rawValue: error.responseCode ?? 0)
                    completion?(ServerResponse(data: response.data, error: networkError, handler: request))
                }
            }

        return request
    }
}

private class NetworkRequestInterceptor: RequestInterceptor {
    private var accept: ContentType?
    private var contentType: ContentType?
    private var authorizationToken: String?

    init(contentType: ContentType? = nil, authorizationToken: String? = nil, accept: ContentType? = nil) {
        self.accept = accept
        self.contentType = contentType
        self.authorizationToken = authorizationToken
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accept = accept {
            urlRequest.headers.add(.accept(accept.rawValue))
        }
        if let contentType = contentType {
            urlRequest.headers.add(.contentType(contentType.rawValue))
        }
        if let authorizationToken = authorizationToken {
            urlRequest.headers.add(.authorization(authorizationToken))
        }

        completion(.success(urlRequest))
    }

    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accept = accept {
            urlRequest.headers.add(.accept(accept.rawValue))
        }
        if let contentType = contentType {
            urlRequest.headers.add(.contentType(contentType.rawValue))
        }
        if let authorizationToken = authorizationToken {
            urlRequest.headers.add(.authorization(authorizationToken))
        }

        completion(.success(urlRequest))
    }
}
