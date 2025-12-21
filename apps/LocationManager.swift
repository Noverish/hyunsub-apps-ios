//
//  LocationManager.swift
//  apps
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func startMonitoringSignificantLocationChanges() {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.startMonitoringSignificantLocationChanges()
            Logger.log("Started monitoring significant location changes")
        } else {
            Logger.log("Significant location change monitoring is not available")
        }
    }

    func stopMonitoringSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
        Logger.log("Stopped monitoring significant location changes")
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let locationTimeStr = dateFormatter.string(from: location.timestamp)

        Logger.log("Did update location: timestamp=\(locationTimeStr), lat=\(location.coordinate.latitude), lng=\(location.coordinate.longitude)")

        let params = TimelineCreateParams(
            timestamp: Int64(location.timestamp.timeIntervalSince1970 * 1000),
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            speed: location.speed >= 0 ? location.speed : nil,
            course: location.course >= 0 ? location.course : nil,
            horizontalAccuracy: location.horizontalAccuracy >= 0 ? location.horizontalAccuracy : nil,
            verticalAccuracy: location.verticalAccuracy >= 0 ? location.verticalAccuracy : nil,
            speedAccuracy: location.speedAccuracy >= 0 ? location.speedAccuracy : nil,
            courseAccuracy: location.courseAccuracy >= 0 ? location.courseAccuracy : nil
        )

        TimelineAPI.shared.sendTimeline(params: params)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.log("Did fail with error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            Logger.log("Authorization: Always")
            startMonitoringSignificantLocationChanges()
        case .authorizedWhenInUse:
            Logger.log("Authorization: When In Use")
            startMonitoringSignificantLocationChanges()
        case .denied:
            Logger.log("Authorization: Denied")
        case .restricted:
            Logger.log("Authorization: Restricted")
        case .notDetermined:
            Logger.log("Authorization: Not Determined")
        @unknown default:
            Logger.log("Authorization: Unknown")
        }
    }
}
