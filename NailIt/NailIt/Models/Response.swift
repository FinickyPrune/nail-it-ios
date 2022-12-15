//
//  Response.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation

struct NailItRegistrationResult {
    let message: String?
    let error: Error?
}

struct NailItSignInResult {
    let message: String?
    let error: Error?
}

struct NailItRefreshTokenResult {
    let message: String?
    let error: Error?
}

struct NailItSignUpResponse: Codable {
    let id: String?
    let username: String?
    let email: String?
    let accessToken: String
    let refreshToken: String
    let message: String?
    let status: Int
}

struct NailItSignInResponse: Codable {
    let message: String?
    let accessToken: String?
    let refreshToken: String?
    let username: String?
    let status: Int?
}

struct NailItRefreshTokenResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let message: String?
    let status: Int?
}

struct ServerResponse {
    let data: Data?
    let error: NetworkError?
}

struct AuthenticationDataObject: Codable {
    let phoneNumber: String
    let password: String
}

struct RegistrationUserInfo: Codable {

    let name: String
    let phoneNumber: String
    let password: String

    internal init(name: String, phoneNumber: String, password: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.password = password
    }

}

struct Salon: Codable {
    let id: String
    let name: String
    var rate: Float
    let address: String
}

struct NailItSalonsListResult {
    let message: String?
    let error: Error?
    let salons: [Salon]?
}
