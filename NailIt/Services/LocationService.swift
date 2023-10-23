//
//  LocationService.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 25.12.2022.
//

import CoreLocation

final class LocationService: NSObject {

    static let shared = LocationService()

    private let locationManager: CLLocationManager = CLLocationManager()

    private(set) var currentLat: Double?
    private(set) var currentLon: Double?

    private var canChangeLocation = true

    private var timer: Timer?

    deinit {
        timer?.invalidate()
        timer = nil
    }

    func start() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 5 * 60, repeats: true) { [weak self] _ in
                self?.canChangeLocation = true
            }
        }
    }

    private func setCoordinates(lat: Double, lon: Double) {
        if canChangeLocation {
            currentLat = lat
            currentLon = lon
            canChangeLocation = false
            log.debug("Current location: \(lat) \(lon)")
            NotificationCenter.default.post(Notification(name: .didUpdateLocation))
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
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
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        @unknown default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        setCoordinates(lat: locValue.latitude, lon: locValue.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

extension Notification.Name {
    static let didUpdateLocation = Notification.Name("didUpdateLocation")
}
