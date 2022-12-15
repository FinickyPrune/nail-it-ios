//
//  SalonCatalogViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 15.12.2022.
//

import UIKit

final class SalonCatalogViewController: UIViewController {

    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    private let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var viewModel: SalonCatalogViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти салон"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "menu button"), for: .bookmark, state: .normal)
        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .bookmark)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self

        sortButton.layer.cornerRadius = 15
        sortButton.layer.borderWidth = 1
        sortButton.layer.borderColor = sortButton.tintColor.cgColor

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SalonTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: SalonTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        viewModel?.loadData { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction private func didTapSort(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.didTapSort()
        sender.backgroundColor =  viewModel.isSorting ? sender.tintColor : .white
        sender.setTitleColor( !viewModel.isSorting ? sender.tintColor : .white, for: .normal)
    }

}

extension SalonCatalogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SalonTableViewCell.identifier) as? SalonTableViewCell,
           let salon = viewModel?.salon(for: indexPath.row) {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.configure(with: salon)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(with: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

extension SalonCatalogViewController: UISearchBarDelegate {}

extension SalonCatalogViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateCellsWithSearchResult), object: nil)
        self.perform(#selector(updateCellsWithSearchResult), with: nil, afterDelay: 0.5)
    }

    @objc private func updateCellsWithSearchResult() {
        viewModel?.filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension SalonCatalogViewController: SalonCatalogViewModelDisplayDelegate {

    func reloadTable(_ viewModel: SalonCatalogViewModel) {
        tableView.reloadData()
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
}
