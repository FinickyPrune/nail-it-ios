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

    func count(for index: Int) -> Int? { // TODO: Change
        guard let section = Section(rawValue: index) else { return nil }
        switch section {
        case .coming:
            return appointments.filter { Int($0.id)! <= 5 }.count
        case .history:
            return appointments.filter { Int($0.id)! > 5 }.count
        }

    }

    func appointments(for index: Int) -> [Appointment]? { // TODO: Change
        guard let section = Section(rawValue: index) else { return nil }
        switch section {
        case .coming:
            return appointments.filter { Int($0.id)! <= 5 }
        case .history:
            return appointments.filter { Int($0.id)! > 5 }
        }
    }

    func section(for index: Int) -> Section? {
        return Section(rawValue: index)
    }

    func didSelectItem(with index: Int) {

    }

    func loadData(completion: @escaping (Error?) -> Void) {

        Interactor.shared.getAppointmentsList(for: 0) { result in // TODO: Change
            if result.error == nil {
                self.appointments = result.appointments ?? []
                completion(nil)
            }
            completion(result.error)
        }

    }

}
