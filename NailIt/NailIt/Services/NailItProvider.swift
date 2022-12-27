//
//  NailItProvider.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation
import Alamofire

final class NailItProvider {

    private static let registerUrl = "http://158.160.54.51:8080/auth/signup"
    private static let loginUrl = ""
    private static let salonsListUrl = "http://158.160.54.51:8080/beauty_salons?lat={lat}&lon={lon}"
    private static let servicesListUrl = "http://158.160.54.51:8080/services/{salon_id}"
    private static let serviceTypesListUrl = "http://158.160.54.51:8080/services/types"
    private static let appointmentsListUrl = "http://158.160.54.51:8080/clients/appointments/{id}"
    private static let mastersListUrl = "http://158.160.54.51:8080/masters"
    private static let appointmentsForMasterUrl = "http://158.160.54.51:8080/masters/{service_id}/provision"
    private static let enrollUrl = "http://158.160.54.51:8080/services/enroll/{app_id}?userId={user_id}"
    private static let allServicesUrl = "http://158.160.54.51:8080/services/all?lat={lat}&lon={lon}"  // TODO: Change

    func performUserAuthentication(loginData: AuthenticationDataObject,
                                   completion: @escaping (ServerResponse) -> Void) {

        guard let url = URL(string: NailItProvider.serviceTypesListUrl) else { return } // TODO: Change url

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

    func salonsList(for lat: Double, lon: Double,
                    completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.salonsListUrl.replacingOccurrences(of: "{lat}", with: String(lat)).replacingOccurrences(of: "{lon}", with: String(lon))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func servicesList(for salonId: Int,
                      completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.servicesListUrl.replacingOccurrences(of: "{salon_id}", with: String(salonId))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func serviceTypesList(completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.serviceTypesListUrl) else { return }        
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func mastersList(completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.mastersListUrl) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func appointmentsList(for userId: Int,
                          completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.appointmentsListUrl.replacingOccurrences(of: "{id}", with: String(userId))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func appointmentsForMasterList(_ serviceId: Int,
                                   completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.appointmentsForMasterUrl.replacingOccurrences(of: "{service_id}", with: String(serviceId))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func enroll(appId: Int, userId: Int, completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.enrollUrl.replacingOccurrences(of: "{app_id}", with: String(appId)).replacingOccurrences(of: "{user_id}", with: String(userId))) else { return }
        NetworkService.shared.request(url,
                                      method: .post,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func getAllServices(for lat: Double, lon: Double,
                        completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: NailItProvider.allServicesUrl.replacingOccurrences(of: "{lat}", with: String(lat)).replacingOccurrences(of: "{lon}", with: String(lon))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }
}
