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

protocol SalonCAtalogViewModelActionDelegate: AnyObject {

}

class SalonCatalogViewModel {

    weak var displayDelegate: SalonCatalogViewModelDisplayDelegate?
    weak var actionDelegate: SalonCAtalogViewModelActionDelegate?

    private(set) var isSorting = false

    private var salons = [Salon]()
    private var filteredSalons = [Salon]()

    var count: Int {
        guard let displayDelegate = displayDelegate else { return 0 }
        displayDelegate.showBanner(self, false)
        if displayDelegate.isFiltering {
            if filteredSalons.count == 0 { displayDelegate.showBanner(self, true) }
            return filteredSalons.count
        }
        if salons.count == 0 { displayDelegate.showBanner(self, true) }
        return salons.count
    }

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

    func didSelectItem(with index: Int) {
        
    }

    func didTapSort() {
        isSorting.toggle()
        displayDelegate?.reloadTable(self)
    }

    func loadData(completion: @escaping (Error?) -> Void) {
        Interactor.shared.getSalonsList { result in
            if result.error == nil {
                self.salons = result.salons ?? []
                self.salons = self.salons.map { Salon(id: $0.id, name: $0.name, rate: Float.random(in: 0...5.0), address: $0.address, distance: $0.distance) }.sorted(by: { $0.distance < $1.distance }) // TODO: Remove
                completion(nil)
            }
            completion(result.error)
        }
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredSalons = salons.filter { salon -> Bool in
            return salon.name.lowercased().contains(searchText.lowercased())
        }
    }

}
