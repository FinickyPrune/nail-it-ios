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

//struct NailItSignUpResponse: Codable {
//    let id: Int
//    let name: String
//    let phoneNumber: String
//    let accessToken: String
//    let message: String?
//    let status: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, message, status
//        case phoneNumber = "phone_number"
//        case accessToken
//    }
//}

struct NailItSignInResponse: Codable {
    let id: Int
    let name: String
    let phoneNumber: String
    let accessToken: String
    let message: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, message, status
        case phoneNumber = "phone_number"
        case accessToken
    }
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

    let role: [String]
    let phoneNumber: String
    let password: String

    internal init(role: [String], phoneNumber: String, password: String) {
        self.role = role
        self.phoneNumber = phoneNumber
        self.password = password
    }
}

struct Salon: Codable {
    let id: Int
    let name: String
    var rate: Float
    let address: String
    let distance: Float
}

struct NailItSalonsListResult {
    let message: String?
    let error: Error?
    let salons: [Salon]?
}

struct Service: Codable {
    let id: Int
    let title: String
    let estimate: String
    let price: Int
    let service: String
}

struct NailItServicesListResult {
    let message: String?
    let error: Error?
    let services: [Service]?
}

struct ServiceType: Codable {
    let id: Int
    let title: String
}

struct NailItServiceTypesListResult {
    let message: String?
    let error: Error?
    let serviceTypes: [ServiceType]?
}

struct Appointment: Codable {
    let id: Int
    let title: String
    let salon: String?
    let address: String?
    let master: String?
    let date: String
    let price: Int?
}

struct NailItAppointmentsListResult {
    let message: String?
    let error: Error?
    let appointments: [Appointment]?
}

struct Master: Codable, Hashable {
    let id: Int
    let name: String
    let rate: Float
    let beautySalonId: Int?
    let masterCategoryId: Int?
}

struct MasterWithAppResponse: Codable {
    let master: Master
    let appointmentDtos: [Appointment]
}

struct NailItMastersWithTimesListResult {
    let message: String?
    let error: Error?
    let mastersWithApps: [MasterWithAppResponse]?
}

struct MastersResponse: Codable {
    let masters: [Master]
}

struct MastersListResult {
    let message: String?
    let error: Error?
    let masters: [Master]?
}

struct EnrollResult {
    let message: String?
    let error: Error?
    let appointment: Appointment?
}
