//
//  NailItProvider.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Alamofire

final class NailItProvider {

    func performUserAuthentication(loginData: AuthenticationDataObject,
                                   completion: @escaping (ServerResponse) -> Void) {

        // Server processing imitation

        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: 1.0)
            if let data = try? JSONSerialization.data(withJSONObject: DebugData.loginData()) {
                completion(ServerResponse(data: data, error: nil))
                return
            }
            completion(ServerResponse(data: nil, error: nil))
        }

    }

    func performUserRegistration(_ userInfo: RegistrationUserInfo,
                                 completion: @escaping (ServerResponse) -> Void) {

        guard let url = URL(string: APIPaths.registerUrl) else { return }

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
        guard let url = URL(string: APIPaths.salonsListUrl.replacingOccurrences(of: "{lat}", with: String(lat)).replacingOccurrences(of: "{lon}", with: String(lon))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func servicesList(for salonId: Int,
                      completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.servicesListUrl.replacingOccurrences(of: "{salon_id}", with: String(salonId))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func serviceTypesList(completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.serviceTypesListUrl) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func mastersList(completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.mastersListUrl) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func appointmentsList(for userId: Int,
                          completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.appointmentsListUrl.replacingOccurrences(of: "{id}", with: String(userId))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func appointmentsForMasterList(_ serviceId: Int,
                                   completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.appointmentsForMasterUrl.replacingOccurrences(of: "{service_id}", with: String(serviceId))) else { return }

        if debugMode {

            DispatchQueue.global(qos: .background).async {
                Thread.sleep(forTimeInterval: 1.0)
                if let data = try? JSONSerialization.data(withJSONObject: DebugData.mastersWithAppointmentsData()) {
                    completion(ServerResponse(data: data, error: nil))
                    return
                }
                completion(ServerResponse(data: nil, error: nil))
            }

        }

        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func enroll(appId: Int, userId: Int, completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.enrollUrl.replacingOccurrences(of: "{app_id}", with: String(appId)).replacingOccurrences(of: "{user_id}", with: String(userId))) else { return }
        NetworkService.shared.request(url,
                                      method: .post,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }

    func getAllServices(for lat: Double, lon: Double,
                        completion: @escaping (ServerResponse) -> Void) {
        guard let url = URL(string: APIPaths.allServicesUrl.replacingOccurrences(of: "{lat}", with: String(lat)).replacingOccurrences(of: "{lon}", with: String(lon))) else { return }
        NetworkService.shared.request(url,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      contentType: .json,
                                      completion: completion)
    }
}
