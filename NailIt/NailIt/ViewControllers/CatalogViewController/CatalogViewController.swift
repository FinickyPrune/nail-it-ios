//
//  MainViewController.swift
//  Autotuned
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import UIKit
import CoreLocation

class CatalogViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet private weak var catalogCollectionView: UICollectionView!

    var viewModel: CatalogViewModel?
    var locationManager: CLLocationManager?

    private let identifier = "CatalogCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        catalogCollectionView.delegate = self
        catalogCollectionView.dataSource = self
        catalogCollectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }

}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CatalogCollectionViewCell,
           let category = viewModel?.category(for: indexPath.row) {
            cell.delegate = self
            cell.configure(with: category)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 270)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension CatalogViewController: CatalogCollectionViewDelegate {

    func collectionViewDidSelect(_ collectionView: UICollectionView, cell: CategoryCollectionViewCell) {
        guard let product = cell.product else { return }
        viewModel?.didSelect(product)
    }

}

extension CatalogViewController: CatalogViewModelDisplayDelegate {

}
