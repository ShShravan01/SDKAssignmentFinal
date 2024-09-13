//
//  mapExtension.swift
//  SDKAssignment
//
//  Created by ceinfo on 09/09/24.
//

import Foundation
import MapplsMap

extension CLLocationCoordinate2D {
    func isValid() -> Bool {
        let ne = CLLocationCoordinate2D(latitude: 36.261688, longitude: 97.403023)
        let sw = CLLocationCoordinate2D(latitude: 6.747100, longitude: 68.032318)
        
        let IndiaBounds: MGLCoordinateBounds = MGLCoordinateBounds(sw: sw, ne: ne)
        return MGLCoordinateInCoordinateBounds(self, IndiaBounds)
    }
}
