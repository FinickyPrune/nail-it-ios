//
//  AppointmentViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 21.12.2022.
//

import Foundation

protocol AppointmentViewModelDisplayDelegate: AnyObject {

}

protocol AppointmentViewModelActionDelegate: AnyObject {

}

class AppointmentViewModel {

    weak var displayDelegate: AppointmentViewModelDisplayDelegate?
    weak var actionDelegate: AppointmentViewModelActionDelegate?

    let service: Service
    let salonName: String

    private var masters = [Master]()
    private var times = [String]()

    init(service: Service, salonName: String) {
        self.service = service
        self.salonName = salonName
    }

    func didTapAccount() {

    }

    var serviceName: String { service.title }
    var servicePrice: Int { service.price }
    var serviceDuration: String { service.timeEstimate }

    var timeCount: Int { return 5 } // TODO: Change
    var mastersCount: Int { return 10 } // TODO: Change

    func time(for row: Int) -> String {
        return "12:00" // TODO: Change
    }

    func master(for index: Int) -> Master? {
        return Master()
//        return masters[safe: index]
    }

    func didSelectMaster(with index: Int) {
        
    }
}
