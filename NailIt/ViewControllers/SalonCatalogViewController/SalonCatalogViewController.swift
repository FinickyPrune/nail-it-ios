//
//  SalonCatalogViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 15.12.2022.
//

import UIKit
import CoreLocation

final class SalonCatalogViewController: UIViewController {

    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var allServicesButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bannerView: UIView!

    @IBOutlet private weak var enrollButton: UIView!

    private let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var viewModel: SalonCatalogViewModel?
    var locationManager: CLLocationManager?
    private var isFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        sortButton.layer.cornerRadius = 15
        sortButton.layer.borderWidth = 1
        sortButton.layer.borderColor = sortButton.tintColor.cgColor

        allServicesButton.layer.cornerRadius = 15
        allServicesButton.layer.borderWidth = 1
        allServicesButton.layer.borderColor = allServicesButton.tintColor.cgColor

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NailItTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: NailItTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        enrollButton.layer.cornerRadius = 15
        enrollButton.isHidden = true

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchDataWithLocation),
                                               name: .didUpdateLocation,
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

    @objc private func fetchDataWithLocation(notification: Notification) {
        fetchData()
    }

    private func setupNavigationBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar

        searchBar.setPlaceholderColor(NIAppearance.nailItPlaceholderTextColor)
        searchBar.setTextColor(color: NIAppearance.nailItPlaceholderTextColor)
        searchBar.searchTextField.leftView?.tintColor = NIAppearance.nailItPlaceholderTextColor
        searchBar.placeholder = "Найти салон"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = NIAppearance.nailItOrangeColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAccount))
        navigationItem.rightBarButtonItem?.tintColor = NIAppearance.nailItBrownColor

        navigationItem.title = "Поиск салона"

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

    private func fetchData() {
        viewModel?.loadData { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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

extension SalonCatalogViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            return
        case .restricted:
            return
        case .denied:
            return
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            if CLLocationManager.locationServicesEnabled() {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager?.startUpdatingLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        LocationService.shared.setCoordinates(lat: locValue.latitude, lon: locValue.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }
}
