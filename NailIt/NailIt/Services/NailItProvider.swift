//
//  NailItProvider.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation
import Alamofire

final class NailItProvider {

    private static let registerUrl = ""
    private static let loginUrl = ""
    private static let refreshUrl = ""
    private static let salonsListUrl = "https://639b3b1231877e43d686a6e6.mockapi.io/api/v1/salons"

    func performUserAuthentication(loginData: AuthenticationDataObject,
                                   completion: @escaping (ServerResponse) -> Void) {

        guard let url = URL(string: NailItProvider.loginUrl) else { return }

        let parameters = try? loginData.toDictionary()

        NetworkService.shared.request(url,
                                      method: .post,
                                      parameters: parameters,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func performUserRegistration(_ userInfo: RegistrationUserInfo,
                                 completion: @escaping (ServerResponse) -> Void) {

        guard let url = URL(string: NailItProvider.registerUrl) else { return }

        let parameters = try? userInfo.toDictionary()

        NetworkService.shared.request(url,
                                      method: .post,
                                      parameters: parameters,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func refreshToken(_ token: String?,
                      completion: @escaping (ServerResponse) -> Void) {

        guard let url = URL(string: NailItProvider.refreshUrl) else { return }

        let token = token ?? ""

        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      authorizationToken: "Bearer \(token)",
                                      completion: completion)
    }

    func salonsList(_ token: String?,
                    completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.salonsListUrl) else { return }

        let token = token ?? ""

        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
//                                      authorizationToken: "Bearer \(token)", // TODO: Enable token
                                      completion: completion)
    }

}
