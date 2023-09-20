//
//  LocationService.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 25.12.2022.
//

import Foundation

final class LocationService {

    static let shared = LocationService()

    private(set) var currentLat: Double?
    private(set) var currentLon: Double?

    private var canChangeLocation = true

    private var timer: Timer?

    private init() {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 5 * 60, repeats: true) { [weak self] _ in
                self?.canChangeLocation = true
            }
        }
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }

    func setCoordinates(lat: Double, lon: Double) {
        if canChangeLocation {
            currentLat = lat
            currentLon = lon
            canChangeLocation = false
            log.debug("Current location: \(lat) \(lon)")
            NotificationCenter.default.post(Notification(name: .didUpdateLocation))
        }
    }
}

extension Notification.Name {
    static let didUpdateLocation = Notification.Name("didUpdateLocation")
}
