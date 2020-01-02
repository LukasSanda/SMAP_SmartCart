//
//  SettingsPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 17/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import CoreLocation

internal protocol SettingsPresenter {
    func saveLocation(_ location: CLLocationCoordinate2D)
    func removeLocation(_ location: CLLocationCoordinate2D)
    func deleteAllData(_ completion: @escaping () -> Void)
    func load()
}

internal protocol SettingsDelegate: class {
    func didLoadStoredSupermarkets(_ locations: [CLLocationCoordinate2D]?)
    func presentController(_ controller: UIViewController)
}

internal class SettingsPresenterImpl: SettingsPresenter {
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    private let marketsRepository: SupermarketRepository
    private let cartRepository: CartRepository
    
    // MARK: - Internal Properties
    
    internal weak var delegate: SettingsDelegate?
    
    // MARK: - Initialization
    
    internal init(marketsRepository: SupermarketRepository, cartRepository: CartRepository) {
        self.marketsRepository = marketsRepository
        self.cartRepository = cartRepository
    }
    
    // MARK: - Methods
    
    internal func load() {
        delegate?.didLoadStoredSupermarkets(marketsRepository.getStoredMarkets())
    }
    
    internal func saveLocation(_ location: CLLocationCoordinate2D) {
        marketsRepository.addMarket(location)
        startMonitoringGeofence(forLocation: location)
        load()
    }
    
    func removeLocation(_ location: CLLocationCoordinate2D) {
        marketsRepository.removeMarket(withLocation: location) {
            self.stopMonitoringGeofece(forLoation: location)
            self.load()
        }
    }
    
    internal func deleteAllData(_ completion: @escaping () -> Void) {
        let controller = UIAlertController(
            title: "Delete All Data",
            message: "You are about to delete all stored data. Are you sure you want to continue?",
            preferredStyle: .alert)
        
        controller.view.tintColor = .black
        
        controller.addAction(UIAlertAction(
            title: "Proceed",
            style: .destructive,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.eraseData {
                    completion()
                }
        }))
        
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        delegate?.presentController(controller)
    }
}

// MARK: - Helpers
private extension SettingsPresenterImpl {
    func eraseData(_ completion: @escaping () -> Void) {
        let group = DispatchGroup()
        // Remove All carts with items
        group.enter()
        cartRepository.removeAllCarts { _ in
            group.leave()
        }
        // Remove All Markets
        group.enter()
        marketsRepository.removeAllMarkets {
            group.leave()
        }
        // Stop monitoring all regions
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func startMonitoringGeofence(forLocation location: CLLocationCoordinate2D) {
        let geofenceRegion = CLCircularRegion(
            center: location,
            radius: 200,
            identifier: "MarketRegion_\(location.latitude),\(location.longitude)")
        geofenceRegion.notifyOnEntry = true
        
        locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func stopMonitoringGeofece(forLoation location: CLLocationCoordinate2D) {
        locationManager.monitoredRegions.forEach {
            // Region identifier is contains its latitude and longitude
            guard $0.identifier.contains(location.latitude.description) && $0.identifier.contains(location.longitude.description) else { return }
            
            locationManager.stopMonitoring(for: $0)
        }
    }
}
