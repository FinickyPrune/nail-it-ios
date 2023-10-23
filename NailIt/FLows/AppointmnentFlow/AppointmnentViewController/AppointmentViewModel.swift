//
//  AppointmentViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 21.12.2022.
//

import Foundation

protocol AppointmentViewModelDisplayDelegate: AnyObject {
    func reloadTableView(_ viewModel: AppointmentViewModel)
    func showLoading(_ viewModel: AppointmentViewModel)
    func stopLoading(_ viewModel: AppointmentViewModel)
    func presentMessage(_ viewModel: AppointmentViewModel, message: String)
}

protocol AppointmentViewModelActionDelegate: AnyObject {
    func appointmentViewModelAttempsToDisplayAccountController(_ viewModel: AppointmentViewModel)
    func appointmentViewModelAttempsToDismissController(_ viewModel: AppointmentViewModel)
}

class AppointmentViewModel {

    weak var displayDelegate: AppointmentViewModelDisplayDelegate?
    weak var actionDelegate: AppointmentViewModelActionDelegate?

    let service: Service
    let salon: Salon?

    private var selectedDateСomponents: DateComponents?
    private var selectedMaster: Master?
    private var selectedAppointment: Appointment?
    private var filteredAppointments = [(Master, [Appointment])]()

    init(service: Service, salon: Salon?) {
        self.service = service
        self.salon = salon
    }

    func didTapAccount() {
        actionDelegate?.appointmentViewModelAttempsToDisplayAccountController(self)
    }

    var salonName: String? { salon?.salonName }
    var serviceName: String { service.title }
    var servicePrice: String { service.price }
    var serviceDuration: String { service.timeEstimate }

    var timeCount: Int { filteredAppointments.count }
    var mastersCount: Int { filteredAppointments.count }

    func time(for row: Int) -> String? {
        guard let selectedMaster = selectedMaster else { return nil }
        guard let date = filteredAppointments.first(where: { $0.0 == selectedMaster })?.1[safe: row]?.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") else { return nil }
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return "\(components.hour ?? 0):\(components.minute ?? 0)"
    }

    func master(for index: Int) -> Master? {
        return filteredAppointments[safe: index]?.0
    }

    func didSelectMaster(with index: Int) {
        selectedMaster = filteredAppointments[safe: index]?.0
    }

    func didSelectDate(with components: DateComponents) {
        selectedDateСomponents = components
        Interactor.shared.appointmentsForMasterList(service.serviceId) { result in
            if result.error != nil {
                return
            }
            self.filteredAppointments = self.composeTimes(from: result.mastersWithApps) ?? []
            self.displayDelegate?.reloadTableView(self)
        }

    }

    func didSelectAppointment(for row: Int) {
        guard let selectedMaster = selectedMaster else { return }
        selectedAppointment = filteredAppointments.first(where: { $0.0 == selectedMaster })?.1[safe: row]
    }

    func didTapEnroll() {
        guard let appId = selectedAppointment?.appointmentId else { return }
        displayDelegate?.showLoading(self)
        Interactor.shared.enrollWith(appId: appId) { result in
            self.displayDelegate?.stopLoading(self)
            if result.error == nil {
                if self.salon != nil {
                    self.actionDelegate?.appointmentViewModelAttempsToDismissController(self)
                }

            } else {
                log.error(result.error?.localizedDescription as Any)
                    self.actionDelegate?.appointmentViewModelAttempsToDismissController(self)

            }
        }
    }
}

extension AppointmentViewModel {

    func composeTimes(from response: [MasterWithAppResponse]?) -> [(Master, [Appointment])]? {
        filteredAppointments = []
        let appointments = response?.map { ($0.master, $0.appointmentDtos) }
        guard let selectedDateСomponents = selectedDateСomponents else { return nil }
        return appointments?.map { pair in
            return (pair.0, pair.1.filter {
                guard let date = $0.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSZZZ") else { return false }
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                return selectedDateСomponents.year == components.year && selectedDateСomponents.month == components.month && selectedDateСomponents.day == components.day
            })
        }
    }

}
