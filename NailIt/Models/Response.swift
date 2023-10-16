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
    let salonId: Int
    let name: String
    var rate: Float
    let address: String
    let distance: Float

    enum CodingKeys: String, CodingKey {
        case salonId = "salon_id"
        case name, rate, address, distance
    }
}

struct NailItSalonsListResult {
    let message: String?
    let error: Error?
    let salons: [Salon]?
}

struct Service: Codable {
    let serviceId: Int
    let title: String
    let timeEstimate: String
    let price: Int
    let serviceTypeTitle: String
    let distance: Float?

    enum CodingKeys: String, CodingKey {
        case serviceId = "service_id"
        case timeEstimate = "time_estimate"
        case serviceTypeTitle = "service_type_title"
        case title, price, distance
    }
}

struct NailItServicesListResult {
    let message: String?
    let error: Error?
    let services: [Service]?
}

struct ServiceType: Codable {
    let serviceTypeId: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case serviceTypeId = "service_type_id"
        case title
    }
}

struct NailItServiceTypesListResult {
    let message: String?
    let error: Error?
    let serviceTypes: [ServiceType]?
}

struct Appointment: Codable {
    let appointmentId: Int
    let serviceTitle: String
    let salonTitle: String?
    let salonAddress: String?
    let masterName: String?
    let date: String
    let price: Int?
    let time: String

    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case serviceTitle = "service_title"
        case salonTitle = "salon_title"
        case salonAddress = "salon_address"
        case masterName = "master_name"
        case date, price, time
    }
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
