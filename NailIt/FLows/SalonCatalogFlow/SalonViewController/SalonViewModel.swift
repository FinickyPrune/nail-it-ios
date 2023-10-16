//
//  SalonViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.12.2022.
//

import Foundation

protocol SalonViewModelDisplayDelegate: AnyObject {
    var isFiltering: Bool { get }
    func reloadTable(_ viewModel: SalonViewModel)
    func showBanner(_ viewModel: SalonViewModel, _ flag: Bool)
}

protocol SalonViewModelActionDelegate: AnyObject {
    func salonViewModelAttempsToDisplayAccountController(_ viewModel: SalonViewModel)
    func salonViewModelAttempsToDisplayAppointmnentController(_ viewModel: SalonViewModel, for: Service, _ salon: Salon)
}

class SalonViewModel {

    weak var displayDelegate: SalonViewModelDisplayDelegate?
    weak var actionDelegate: SalonViewModelActionDelegate?

    private(set) var isSorting = false

    private let salon: Salon
    private var serviceTypes = [ServiceType]()
    private var services = [Service]()
    private var filteredServices = [Service]()

    init(salon: Salon) {
        self.salon = salon
    }

    var salonName: String { salon.name }

    var sectionsCount: Int { serviceTypes.count }

    func services(for serviceType: ServiceType) -> [Service] {
        guard let displayDelegate = displayDelegate else { return [] }
        if displayDelegate.isFiltering {
            return filteredServices.filter { (debugMode ? $0.title : $0.serviceTypeTitle) == serviceType.title }
        }
        return services.filter { (debugMode ? $0.title : $0.serviceTypeTitle) == serviceType.title }
    }

    func count(for serviceType: ServiceType) -> Int { services(for: serviceType).count }

    func serviceType(for index: Int) -> ServiceType? { serviceTypes[safe: index] }

    func didSelectItem(with indexPath: IndexPath) {
        guard let serviceType = serviceType(for: indexPath.section),
              let service = services(for: serviceType)[safe: indexPath.row] else { return }
        actionDelegate?.salonViewModelAttempsToDisplayAppointmnentController(self, for: service, salon)
    }

    func loadData(completion: @escaping (Error?) -> Void) {

        Interactor.shared.getServiceTypesList { [self] serviceTypesResult in
            if serviceTypesResult.error == nil {
                serviceTypes = (serviceTypesResult.serviceTypes ?? [])

                Interactor.shared.getServicesList(for: salon.salonId) { result in
                    if result.error == nil {
                        self.services.append(contentsOf: result.services ?? []) 
                        completion(nil)
                        return
                    }
                    completion(result.error)
                    return
                }
            }
            completion(serviceTypesResult.error)
        }

    }

    func filterContentForSearchText(_ searchText: String) {
        filteredServices = services.filter { service -> Bool in
            return service.title.lowercased().contains(searchText.lowercased())
        }
    }

    func didTapAccount() {
        actionDelegate?.salonViewModelAttempsToDisplayAccountController(self)
    }

}
