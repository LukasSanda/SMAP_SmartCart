//
//  CLLocationCoordinate2D+Equatable.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 26/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import CoreLocation

internal extension CLLocationCoordinate2D {
    static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
