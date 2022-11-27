//
//  NailItProvider.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation
import Alamofire

final class NailItProvider: DataProvider {

    private static let registerUrl = ""
    private static let loginUrl = ""
    private static let refreshUrl = ""

    func performUserAuthentication(loginData: AuthenticationDataObject,
                                   completion: @escaping (ServerResponse) -> Void) -> Request? {

        guard let url = URL(string: NailItProvider.loginUrl) else { return nil }

        let parameters = try? loginData.toDictionary()

        let request = NetworkService.shared.request(url,
                                                    method: .post,
                                                    parameters: parameters,
                                                    encoding: JSONEncoding.default,
                                                    contentType: .json,
                                                    completion: completion)

        return request

    }

    func performUserRegistration(_ userInfo: RegistrationUserInfo,
                                 completion: @escaping (ServerResponse) -> Void) -> Request? {

        guard let url = URL(string: NailItProvider.registerUrl) else { return nil }

        let parameters = try? userInfo.toDictionary()

        let request = NetworkService.shared.request(url,
                                                    method: .post,
                                                    parameters: parameters,
                                                    encoding: JSONEncoding.default,
                                                    contentType: .json,
                                                    completion: completion)

        return request
    }

    func refreshToken(_ token: String?,
                      completion: @escaping (ServerResponse) -> Void) -> Request? {

        guard let url = URL(string: NailItProvider.refreshUrl) else { return nil }

        let token = token ?? ""

        let request = NetworkService.shared.request(url,
                                                    method: .get,
                                                    encoding: JSONEncoding.default,
                                                    contentType: .json,
                                                    authorizationToken: "Bearer \(token)",
                                                    completion: completion)
        return request
    }

    func cancelDataHandler(handler: DataHandler) {
        (handler as? DataRequest)?.cancel()
    }

}
