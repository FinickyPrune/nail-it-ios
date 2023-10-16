//
//  SalonCatalogViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 15.12.2022.
//

import Foundation

protocol SalonCatalogViewModelDisplayDelegate: AnyObject {
    var isFiltering: Bool { get }
    func reloadTable(_ viewModel: SalonCatalogViewModel)
    func showBanner(_ viewModel: SalonCatalogViewModel, _ flag: Bool)
}

protocol SalonCatalogViewModelActionDelegate: AnyObject {
    func salonCatalogViewModelAttempsToDisplaySalonController(_ viewModel: SalonCatalogViewModel, for salon: Salon)
    func salonCatalogViewModelAttempsToDisplayAppointmentControllersStack(_ viewModel: SalonCatalogViewModel, for services: [Service])
    func salonCatalogViewModelAttempsToDisplayAccountController(_ viewModel: SalonCatalogViewModel)
}

class SalonCatalogViewModel {

    weak var displayDelegate: SalonCatalogViewModelDisplayDelegate?
    weak var actionDelegate: SalonCatalogViewModelActionDelegate?

    private(set) var isSorting = false

    private(set) var isServicesMode = false

    private var salons = [Salon]()
    private var filteredSalons = [Salon]()

    private var services = [Service]()
    private var filteredServices = [Service]()
    private var selectedServices = [Service]()

    var count: Int {

        guard let displayDelegate = displayDelegate else { return 0 }
        displayDelegate.showBanner(self, false)

        if isServicesMode {
            if displayDelegate.isFiltering {
                if filteredServices.count == 0 { displayDelegate.showBanner(self, true) }
                return filteredServices.count
            }
            return services.count
        }

        if displayDelegate.isFiltering {
            if filteredSalons.count == 0 { displayDelegate.showBanner(self, true) }
            return filteredSalons.count
        }
        if salons.count == 0 { displayDelegate.showBanner(self, true) }
        return salons.count
    }

    var selectedServicesCount: Int { selectedServices.count }

    func salon(for index: Int) -> Salon? {
        guard let displayDelegate = displayDelegate else { return nil }
        if displayDelegate.isFiltering {
            if isSorting {
                return filteredSalons.sorted(by: { $0.rate > $1.rate })[safe: index]
            }
            return filteredSalons[safe: index]
        }
        if isSorting {
            return salons.sorted(by: { $0.rate > $1.rate })[safe: index]
        }
        return salons[safe: index]
    }

    func service(for index: Int) -> Service? {
        guard let displayDelegate = displayDelegate else { return nil }
        if displayDelegate.isFiltering {
            return filteredServices[safe: index]
        }
        return services[safe: index]
    }

    func didSelectItem(with index: Int) {
        guard !isServicesMode, let salon = salon(for: index) else { return }
        actionDelegate?.salonCatalogViewModelAttempsToDisplaySalonController(self, for: salon)
    }

    func didSelectService(with index: Int) {
        guard let service = services[safe: index] else { return }
        selectedServices.append(service)
    }

    func didDeselectService(with index: Int) {
        guard let service = services[safe: index] else { return }
        selectedServices.removeAll(where: { $0.serviceId == service.serviceId })
    }

    func didTapSort() {
        isSorting.toggle()
        displayDelegate?.reloadTable(self)
    }

    func didTapAllServices() {
        isServicesMode.toggle()
        displayDelegate?.reloadTable(self)
    }

    func loadData(completion: @escaping (Error?) -> Void) {
        Interactor.shared.getSalonsList { result in
            if result.error == nil {
                self.salons = result.salons ?? []
                self.salons = self.salons.sorted(by: { $0.distance < $1.distance })
                completion(nil)
            }
            completion(result.error)
        }

//        Implicitly don't call completion
        Interactor.shared.getAllServicesList { result in
            if result.error == nil {
                self.services = result.services ?? []
                self.services = self.services.sorted(by: { ($0.distance ?? .greatestFiniteMagnitude) < ($1.distance ?? .greatestFiniteMagnitude) })
            }
        }
    }

    func filterContentForSearchText(_ searchText: String) {

        if isServicesMode {
            filteredServices = services.filter { service -> Bool in
                return service.title.lowercased().contains(searchText.lowercased())
            }
        }

        filteredSalons = salons.filter { salon -> Bool in
            return salon.name.lowercased().contains(searchText.lowercased())
        }
    }

    func didLoginSuccessfully() {
        
    }

    func didTapAccount() {
        actionDelegate?.salonCatalogViewModelAttempsToDisplayAccountController(self)
    }

    func didTapEnroll() {
        actionDelegate?.salonCatalogViewModelAttempsToDisplayAppointmentControllersStack(self, for: selectedServices)
    }

}
