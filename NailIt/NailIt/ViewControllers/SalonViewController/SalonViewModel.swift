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
            return filteredServices.filter { $0.serviceTypeTitle == serviceType.title }
        }
        return services.filter { $0.serviceTypeTitle == serviceType.title }
    }

    func serviceType(for index: Int) -> ServiceType? {
        return serviceTypes[safe: index]
    }

    func count(for serviceType: ServiceType) -> Int {
        guard let displayDelegate = displayDelegate else { return 0 }
        if displayDelegate.isFiltering {
            return filteredServices.filter { $0.serviceTypeTitle == serviceType.title }.count
        }
        return services.filter { $0.serviceTypeTitle == serviceType.title }.count
    }

    func didSelectItem(with index: Int) {

    }

    func loadData(completion: @escaping (Error?) -> Void) {

        Interactor.shared.getServiceTypesList { serviceTypesResult in
            if serviceTypesResult.error == nil {
                self.serviceTypes = (serviceTypesResult.serviceTypes ?? []).map { ServiceType(id: $0.id, title: $0.title.replacingOccurrences(of: "title", with: "serviceTypeTitle", options: .literal, range: nil)) } // TODO: Change
                Interactor.shared.getSalonsList(for: 0) { result in // TODO: Change
                    if result.error == nil {
                        self.services.append(contentsOf: result.services ?? []) // TODO: Change
                        self.services.append(contentsOf: result.services ?? []) // TODO: Change
                        self.services = self.services.sorted(by: { $0.serviceTypeTitle < $1.serviceTypeTitle }) // TODO: Change
                        completion(nil)
                    }
                    completion(result.error)
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
