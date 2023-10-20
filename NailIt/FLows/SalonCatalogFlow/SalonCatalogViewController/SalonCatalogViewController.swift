//
//  SalonCatalogViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 15.12.2022.
//

import UIKit

final class SalonCatalogViewController: UIViewController {

    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var allServicesButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var bannerLabel: UILabel!
    @IBOutlet private weak var bannerView: UIView!

    @IBOutlet private weak var enrollButton: UIButton!

    private let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var viewModel: SalonCatalogViewModel?
    private var isFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        sortButton.layer.cornerRadius = 15
        sortButton.layer.borderWidth = 1
        sortButton.layer.borderColor = sortButton.tintColor.cgColor
        sortButton.titleLabel?.font = UIFont.montserratRegular(size: 16)

        allServicesButton.layer.cornerRadius = 15
        allServicesButton.layer.borderWidth = 1
        allServicesButton.layer.borderColor = allServicesButton.tintColor.cgColor
        allServicesButton.titleLabel?.font = UIFont.montserratRegular(size: 16)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NailItTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: NailItTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        bannerLabel.font = UIFont.montserratSemiBold(size: 16)

        enrollButton.layer.cornerRadius = 15
        enrollButton.isHidden = true
        enrollButton.titleLabel?.font = UIFont.montserratBold(size: 16)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var contentInset = tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 20
        tableView.contentInset = contentInset
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }

    private func setupNavigationBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar

        searchBar.setPlaceholderColor(NIAppearance.nailItPlaceholderTextColor)
        searchBar.setTextColor(color: NIAppearance.nailItPlaceholderTextColor)
        searchBar.setPlaceholderFont(UIFont.montserratSemiBold(size: 16))
        searchBar.searchTextField.leftView?.tintColor = NIAppearance.nailItPlaceholderTextColor
        searchBar.placeholder = "SalonCatalogViewController.searchPlaceholder".localized
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = NIAppearance.nailItOrangeColor

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratBold(size: 16),
                                                                   NSAttributedString.Key.foregroundColor: NIAppearance.nailItOrangeColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAccount))
        navigationItem.rightBarButtonItem?.tintColor = NIAppearance.nailItBrownColor

        navigationItem.title = "SalonCatalogViewController.navigationLabel".localized

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }

    @objc private func didTapAccount() {
        viewModel?.didTapAccount()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupNavigationBar()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
    }

    @IBAction private func didTapSort(_ sender: UIButton) {
        guard let viewModel = viewModel, !viewModel.isServicesMode else { return }
        viewModel.didTapSort()
        sender.backgroundColor =  viewModel.isSorting ? NIAppearance.nailItOrangeColor : .white
        sender.setTitleColor( !viewModel.isSorting ? NIAppearance.nailItOrangeColor : .white, for: .normal)
    }

    @IBAction private func didTapAllServices(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAllServices()
        tableView.allowsMultipleSelection = viewModel.isServicesMode
        tableView.allowsMultipleSelectionDuringEditing = viewModel.isServicesMode
        enrollButton.isHidden = !viewModel.isServicesMode
        sender.backgroundColor =  viewModel.isServicesMode ? NIAppearance.nailItOrangeColor : .white
        sender.setTitleColor( !viewModel.isServicesMode ? NIAppearance.nailItOrangeColor : .white, for: .normal)
    }

    @IBAction private func didTapEnroll() {
        viewModel?.didTapEnroll()
    }

}

extension SalonCatalogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NailItTableViewCell.identifier) as? NailItTableViewCell,
            let viewModel = viewModel {

            if viewModel.isServicesMode {
                if let service = viewModel.service(for: indexPath.row) {
                    cell.configure(with: service)
                }
                return cell
            }

            if let salon = viewModel.salon(for: indexPath.row) {
                cell.configure(with: salon)
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.isServicesMode {
            viewModel.didSelectService(with: indexPath.row)
            return
        }
        viewModel.didSelectItem(with: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.isServicesMode {
            viewModel.didDeselectService(with: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

extension SalonCatalogViewController: UISearchBarDelegate, UISearchResultsUpdating {

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

    func showBanner(_ viewModel: SalonCatalogViewModel, _ flag: Bool) {
        bannerView.isHidden = !flag
    }

    func reloadTable(_ viewModel: SalonCatalogViewModel) {
        tableView.reloadData()
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
}
