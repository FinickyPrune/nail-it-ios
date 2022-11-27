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
    let handler: DataHandler?
}

struct NailItSignInResult {
    let message: String?
    let error: Error?
    let handler: DataHandler?
}

struct NailItRefreshTokenResult {
    let message: String?
    let error: Error?
    let handler: DataHandler?
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
    let handler: DataHandler?
}

struct AuthenticationDataObject: Codable {
    let username: String
    let password: String
}

struct RegistrationUserInfo: Codable {

    let username: String
    let email: String
    let birthDate: String
    let country: String
    let city: String
    let height: Float
    let heightUnits: String
    let weight: Float
    let weightUnits: String
    let password: String

    internal init(username: String, email: String, birthDate: Date,
                  country: String, city: String,
                  height: Float, heightUnits: String,
                  weight: Float, weightUnits: String,
                  password: String) {
        self.username = username
        self.email = email

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.birthDate = dateFormatter.string(from: birthDate)

        self.country = country
        self.city = city
        self.height = height
        self.heightUnits = heightUnits == "cm" ? "CM" : "FT"
        self.weight = weight
        self.weightUnits = weightUnits == "kg" ? "KG" : "LB"
        self.password = password
    }

}