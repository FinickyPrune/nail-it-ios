//
//  AccountViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.12.2022.
//

import Foundation

enum Section: Int {
    case coming = 0
    case history = 1
}

protocol AccountViewModelDisplayDelegate: AnyObject {

}

protocol AccountViewModelActionDelegate: AnyObject {

}

class AccountViewModel {

    weak var displayDelegate: AccountViewModelDisplayDelegate?
    weak var actionDelegate: AccountViewModelActionDelegate?

    private let userManager = UserManager.shared

    var username: String? { userManager.username }
    var phoneNumber: String? { userManager.phoneNumber }

    private var appointments = [Appointment]()

    var sectionsCount: Int { 2 }

    func count(for index: Int) -> Int? {
        guard let section = Section(rawValue: index) else { return nil }
        let now = Date()
        switch section {
        case .coming:
            return appointments.filter { $0.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") ?? Date() > now }.count
        case .history:
            return appointments.filter { $0.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") ?? Date() < now }.count
        }

    }

    func appointments(for index: Int) -> [Appointment]? {
        guard let section = Section(rawValue: index) else { return nil }
        let now = Date()
        switch section {
        case .coming:
            return appointments.filter { $0.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") ?? Date() > now }
        case .history:
            return appointments.filter { $0.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") ?? Date() < now }
        }
    }

    func section(for index: Int) -> Section? {
        return Section(rawValue: index)
    }

    func didSelectItem(with index: Int) {

    }

    func loadData(completion: @escaping (Error?) -> Void) {
        guard let id = UserManager.shared.id else { return }
        Interactor.shared.getAppointmentsList(for: id) { result in
            if result.error == nil {
                self.appointments = result.appointments ?? []
                completion(nil)
            }
            completion(result.error)
        }

    }

}
