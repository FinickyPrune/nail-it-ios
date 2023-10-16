//
//  Credentials.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 21.09.2023.
//

import Foundation

struct APICredential {
    static var baseURLString: String {
        return debugMode ?
        "https://639b3b1231877e43d686a6e6.mockapi.io/api/v1/" :
        "http://158.160.54.51:8080/"
    }
}

struct APIPaths {

    static var registerUrl = "http://158.160.54.51:8080/auth/signup"
    static var loginUrl = ""

    static var salonsListUrl: String { APICredential.baseURLString +       (debugMode ? "salons"       : "beauty_salons?lat={lat}&lon={lon}") }
    static var servicesListUrl: String { APICredential.baseURLString +     (debugMode ? "services"     : "services/{salon_id}") }
    static var serviceTypesListUrl: String { APICredential.baseURLString + (debugMode ? "serviceTypes" : "services/types") }
    static var appointmentsListUrl: String { APICredential.baseURLString + (debugMode ? "appointments" : "clients/appointments/{id}") }
    static var mastersListUrl: String { APICredential.baseURLString +      (debugMode ? "masters"      : "masters") }

    static let appointmentsForMasterUrl = "http://158.160.54.51:8080/masters/{service_id}/provision"
    static let enrollUrl = "http://158.160.54.51:8080/services/enroll/{app_id}?userId={user_id}"
    static let allServicesUrl = "http://158.160.54.51:8080/services/all?lat={lat}&lon={lon}"  // TODO: Change
}
