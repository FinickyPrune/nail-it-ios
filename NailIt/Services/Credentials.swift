//
//  Credentials.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 21.09.2023.
//

import Foundation

enum APIEndpoint {
    case register
    case login
    case salons
    case services
    case serviceTypes
    case appointments
    case masters
    case allServices
}

struct APICredential {

    private static let stagingBaseUrlString: String = "http://158.160.54.51:8080/"
    private static let debugBaseUrlString1: String = "https://639b3b1231877e43d686a6e6.mockapi.io/api/v1/"
    private static let debugBaseUrlString2: String = "https://65355e4dc620ba9358ec6f19.mockapi.io/api/v1/"

    static func baseUrlString(for endpoint: APIEndpoint) -> String {

        switch endpoint {
        case .register:
            debugMode ? "" : stagingBaseUrlString
        case .login:
            debugMode ? "" : ""
        case .salons:
            debugMode ? debugBaseUrlString1 : stagingBaseUrlString
        case .services:
            debugMode ? debugBaseUrlString1 : stagingBaseUrlString
        case .serviceTypes:
            debugMode ? debugBaseUrlString1 : stagingBaseUrlString
        case .appointments:
            debugMode ? debugBaseUrlString1 : stagingBaseUrlString
        case .masters:
            debugMode ? debugBaseUrlString2 : stagingBaseUrlString
        case .allServices:
            debugMode ? debugBaseUrlString1 : stagingBaseUrlString
        }

    }
}

struct APIPaths {

    static var registerUrl = APICredential.baseUrlString(for: .register) + "auth/signup"
    static var loginUrl = APICredential.baseUrlString(for: .login) + "auth/login"

    static var salonsListUrl: String { APICredential.baseUrlString(for: .salons) +  (debugMode ? "salons" : "beauty_salons?lat={lat}&lon={lon}") }
    static var servicesListUrl: String { APICredential.baseUrlString(for: .services) + (debugMode ? "services" : "services/{salon_id}") }
    static var serviceTypesListUrl: String { APICredential.baseUrlString(for: .serviceTypes) + (debugMode ? "serviceTypes" : "services/types") }
    static var appointmentsListUrl: String { APICredential.baseUrlString(for: .appointments) + (debugMode ? "appointments" : "clients/appointments/{id}") }
    static var mastersListUrl: String { APICredential.baseUrlString(for: .masters) + (debugMode ? "masters" : "masters") }
    static var allServicesUrl: String { APICredential.baseUrlString(for: .allServices) + (debugMode ? "services" : "services/all?lat={lat}&lon={lon}") }

    static let appointmentsForMasterUrl = "http://158.160.54.51:8080/masters/{service_id}/provision"
    static let enrollUrl = "http://158.160.54.51:8080/services/enroll/{app_id}?userId={user_id}"
    
}
