//
//  SupermarketRepository.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 17/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation
import CoreLocation

internal protocol SupermarketRepository {
    func getStoredMarkets() -> [CLLocationCoordinate2D]?
    func removeMarket(withLocation location: CLLocationCoordinate2D, _ completion: @escaping () -> Void)
    func addMarket(_ location: CLLocationCoordinate2D)
    func removeAllMarkets(_ completion: @escaping () -> Void)
}

internal class SupermarketRepositoryImpl: SupermarketRepository {
    
    // MARK: - Properties
    
    private struct Keys {
        static let markets: String = "Settings.StoredMarkets"
    }
    
    private let storage = UserDefaults.standard
    
    // MARK: - Initialization
    
    // MARK: - Methods
    
    internal func getStoredMarkets() -> [CLLocationCoordinate2D]? {
        guard
            let dict = storage.object(forKey: Keys.markets) as? [Dictionary<String,NSNumber>] else {
                return nil
        }
        
        var result = [CLLocationCoordinate2D]()
        
        for element in dict {
            guard
                let locationLat = element["lat"]?.doubleValue,
                let locationLon = element["lon"]?.doubleValue else { continue }
            
            result.append(CLLocationCoordinate2D(
                latitude: locationLat,
                longitude: locationLon))
        }
        
        return result
    }
    
    internal func addMarket(_ location: CLLocationCoordinate2D) {
        if let locations = getStoredMarkets() {
            let locationLat = NSNumber(value: location.latitude)
            let locationLon = NSNumber(value: location.longitude)
            
            var result = [Dictionary<String,NSNumber>]()
            
            for location in locations {
                let element = [
                    "lat": NSNumber(value: location.latitude),
                    "lon": NSNumber(value: location.longitude)]
                
                result.append(element)
            }
            
            result.append([
                "lat": locationLat,
                "lon": locationLon])
            
            storage.set(result, forKey: Keys.markets)
            
        } else {
            let locationLat = NSNumber(value: location.latitude)
            let locationLon = NSNumber(value: location.longitude)
            
            storage.set([["lat": locationLat, "lon": locationLon]], forKey: Keys.markets)
        }
        
        storage.synchronize()
    }
    
    internal func removeMarket(withLocation location: CLLocationCoordinate2D, _ completion: @escaping () -> Void) {
        guard let locations = getStoredMarkets() else { return }
        
        var result = [Dictionary<String,NSNumber>]()
        
        for storedLocation in locations {
            if location.latitude == storedLocation.latitude &&
                location.longitude == storedLocation.longitude { continue }
            
            let element = [
                "lat": NSNumber(value: storedLocation.latitude),
                "lon": NSNumber(value: storedLocation.longitude)]
            
            result.append(element)
        }
        
        storage.set(result, forKey: Keys.markets)
        storage.synchronize()
        completion()
    }
    
    internal func removeAllMarkets(_ completion: @escaping () -> Void) {
        storage.removeObject(forKey: Keys.markets)
        completion()
    }
}
