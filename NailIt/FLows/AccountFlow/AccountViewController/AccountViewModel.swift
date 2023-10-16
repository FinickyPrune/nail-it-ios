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
    func dispayAlert(_ viewModel: AccountViewModel, message: String)
}

protocol AccountViewModelActionDelegate: AnyObject {

}

class AccountViewModel {

    weak var displayDelegate: AccountViewModelDisplayDelegate?
    weak var actionDelegate: AccountViewModelActionDelegate?

    private let userManager = UserManager.shared

    var username: String? { userManager.username }
    var phoneNumber: String? { userManager.phoneNumber }

    private var appointments = [Appointment]() {
        didSet {
            if conflictingAppointments.count != 0 {
                displayDelegate?.dispayAlert(self, message: "У Вас есть конфликтующие записи.")
            }
        }
    }

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

    var conflictingAppointments: [Appointment] {
        var conflictingAppointments = [Appointment]()
        appointments(for: Section.coming.rawValue)?.forEach { app in
            guard let date = app.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") else { return }
            let firstComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            self.appointments.forEach { secondApp in
                guard let secondDate = secondApp.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") else { return }
                let secondComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: secondDate)
                if app.appointmentId != secondApp.appointmentId && firstComponents == secondComponents {
                    conflictingAppointments.append(app)
                    conflictingAppointments.append(secondApp)
                }
            }
        }
        return conflictingAppointments
    }

}
