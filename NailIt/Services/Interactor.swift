//
//  Interactor.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation

final class Interactor {

    static let shared = Interactor()

    private let userManager = UserManager.shared
    private let locationService = LocationService.shared

    private let nailItProvider = NailItProvider()

    // MARK: - NailIt API Interaction

    func performUserRegistration(userInfo: RegistrationUserInfo,
                                 completion: @escaping (NailItRegistrationResult) -> Void) {
        nailItProvider.performUserRegistration(userInfo) { result in
            guard let data = result.data else {
                completion(NailItRegistrationResult(message: result.error?.localizedDescription,
                                                       error: result.error))
                return
            }
                if let error = result.error {
                    completion(NailItRegistrationResult(message: error.localizedDescription,
                                                           error: error))
                    return
                }

                completion(NailItRegistrationResult(message: nil,
                                                       error: nil))
        }
    }

    func performSignInWith(_ loginData: AuthenticationDataObject, //  TODO: Change all
                           completion: @escaping (NailItSignInResult) -> Void) {
        nailItProvider.performUserAuthentication(loginData: loginData) { result in
//            guard let data = result.data else {
//                completion(NailItSignInResult(message: result.error?.localizedDescription,
//                                                 error: result.error))
//                return
//            }
//            do {
//                var response = try JSONDecoder().decode(NailItSignInResponse.self, from: data)
                let response = NailItSignInResponse(id: 1, name: "Никита", phoneNumber: "+70000000000", accessToken: "sss", message: nil, status: nil) // TODO: Remove

//                if let error = result.error {
//                    completion(NailItSignInResult(message: response.message,
//                                                     error: error))
//                    return
//                }

            self.userManager.updateUserWith(id: response.id, name: response.name, phone: response.phoneNumber, token: response.accessToken)
                completion(NailItSignInResult(message: nil,
                                                 error: nil))
//            } catch {
//                log.error(error.localizedDescription)
//                completion(NailItSignInResult(message: error.localizedDescription,
//                                                 error: error))
//            }
        }
    }

    func getSalonsList(completion: @escaping (NailItSalonsListResult) -> Void) {
        guard let lat = locationService.currentLat,
                let lon = locationService.currentLon else { return }
        nailItProvider.salonsList(for: lat, lon: lon) { result in
            guard let data = result.data else {
                completion(NailItSalonsListResult(message: result.error?.localizedDescription,
                                                  error: result.error,
                                                  salons: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([Salon].self, from: data)

                if let error = result.error {
                    completion(NailItSalonsListResult(message: error.localizedDescription,
                                                      error: error,
                                                      salons: nil))
                    return
                }
                completion(NailItSalonsListResult(message: nil,
                                                  error: nil,
                                                  salons: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItSalonsListResult(message: error.localizedDescription,
                                                  error: error,
                                                  salons: nil))
            }
        }

    }

    func getServicesList(for salonId: Int, completion: @escaping (NailItServicesListResult) -> Void) {
        nailItProvider.servicesList(for: salonId) { result in
            guard let data = result.data else {
                completion(NailItServicesListResult(message: result.error?.localizedDescription,
                                                    error: result.error,
                                                    services: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([Service].self, from: data)

                if let error = result.error {
                    completion(NailItServicesListResult(message: error.localizedDescription,
                                                        error: error,
                                                        services: nil))
                    return
                }
                completion(NailItServicesListResult(message: nil,
                                                    error: nil,
                                                    services: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItServicesListResult(message: error.localizedDescription,
                                                    error: error,
                                                    services: nil))
            }
        }

    }

    func getMastersList(completion: @escaping (MastersListResult) -> Void) {
        nailItProvider.mastersList { result in
            guard let data = result.data else {
                completion(MastersListResult(message: result.error?.localizedDescription,
                                             error: result.error,
                                             masters: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode(MastersResponse.self, from: data)

                if let error = result.error {
                    completion(MastersListResult(message: error.localizedDescription,
                                                 error: error,
                                                 masters: nil))
                    return
                }
                completion(MastersListResult(message: nil,
                                             error: nil,
                                             masters: response.masters))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(MastersListResult(message: error.localizedDescription,
                                             error: error,
                                             masters: nil))
            }
        }

    }

    func getServiceTypesList(completion: @escaping (NailItServiceTypesListResult) -> Void) {
        nailItProvider.serviceTypesList { result in
            guard let data = result.data else {
                completion(NailItServiceTypesListResult(message: result.error?.localizedDescription,
                                                        error: result.error,
                                                        serviceTypes: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([ServiceType].self, from: data)

                if let error = result.error {
                    completion(NailItServiceTypesListResult(message: error.localizedDescription,
                                                            error: error,
                                                            serviceTypes: nil))
                    return
                }
                completion(NailItServiceTypesListResult(message: nil,
                                                        error: nil,
                                                        serviceTypes: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItServiceTypesListResult(message: error.localizedDescription,
                                                        error: error,
                                                        serviceTypes: nil))
            }
        }

    }

    func getAppointmentsList(for userId: Int, completion: @escaping (NailItAppointmentsListResult) -> Void) {
        nailItProvider.appointmentsList(for: userId) { result in
            guard let data = result.data else {
                completion(NailItAppointmentsListResult(message: result.error?.localizedDescription,
                                                        error: result.error,
                                                        appointments: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([Appointment].self, from: data)

                if let error = result.error {
                    completion(NailItAppointmentsListResult(message: error.localizedDescription,
                                                            error: error,
                                                            appointments: nil))
                    return
                }
                completion(NailItAppointmentsListResult(message: nil,
                                                        error: nil,
                                                        appointments: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItAppointmentsListResult(message: error.localizedDescription,
                                                        error: error,
                                                        appointments: nil))
            }
        }
    }

    func appointmentsForMasterList(_ serviceId: Int, completion: @escaping (NailItMastersWithTimesListResult) -> Void) {
        nailItProvider.appointmentsForMasterList(serviceId) { result in
            guard let data = result.data else {
                completion(NailItMastersWithTimesListResult(message: result.error?.localizedDescription,
                                                            error: result.error,
                                                            mastersWithApps: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([MasterWithAppResponse].self, from: data)

                if let error = result.error {
                    completion(NailItMastersWithTimesListResult(message: error.localizedDescription,
                                                                error: error,
                                                                mastersWithApps: nil))
                    return
                }
                completion(NailItMastersWithTimesListResult(message: nil,
                                                            error: nil,
                                                            mastersWithApps: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItMastersWithTimesListResult(message: error.localizedDescription,
                                                            error: error,
                                                            mastersWithApps: nil))
            }
        }
    }

    func enrollWith(appId: Int, completion: @escaping (EnrollResult) -> Void) {
        guard let userId = userManager.id else { return }
        nailItProvider.enroll(appId: appId, userId: userId) { result in
            guard let data = result.data else {
                completion(EnrollResult(message: result.error?.localizedDescription,
                                        error: result.error,
                                        appointment: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode(Appointment.self, from: data)

                if let error = result.error {
                    completion(EnrollResult(message: error.localizedDescription,
                                            error: error,
                                            appointment: nil))
                    return
                }
                completion(EnrollResult(message: nil,
                                        error: nil,
                                        appointment: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(EnrollResult(message: error.localizedDescription,
                                        error: error,
                                        appointment: nil))
            }
        }
    }

    func getAllServicesList(completion: @escaping (NailItServicesListResult) -> Void) {
        guard let lat = locationService.currentLat,
              let lon = locationService.currentLon else { return }
        nailItProvider.getAllServices(for: lat, lon: lon) { result in
            guard let data = result.data else {
                completion(NailItServicesListResult(message: result.error?.localizedDescription,
                                                    error: result.error,
                                                    services: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([Service].self, from: data)

                if let error = result.error {
                    completion(NailItServicesListResult(message: error.localizedDescription,
                                                        error: error,
                                                        services: nil))
                    return
                }
                completion(NailItServicesListResult(message: nil,
                                                    error: nil,
                                                    services: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItServicesListResult(message: error.localizedDescription,
                                                    error: error,
                                                    services: nil))
            }
        }

    }

}
