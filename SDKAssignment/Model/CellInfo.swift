//
//  CellInfo.swift
//  SDKAssignment
//
//  Created by ceinfo on 06/09/24.
//

import Foundation

struct SectionInfo {
    var cellInfo : [CellInfo] = []
    var headerTitle : String?
}

struct CellInfo {
    var name: String?
    var cellType: CellType?
}

enum CellType {
    case showPopup
    case showMap
    case zoomCenter
    case zoomCenterWithAnimation
    case customMarker
    case customMarkerWithHighlighted
    case plotPolyline
    case plotPolylineWithCustomColor
    case plotPolygon
    case plotPolygonWithCustomColor
    case plotPolygonWithOpacity
    case reverseGeocode
    case detailsPlace
    case distanceBetweenTwoLocations
    case nearbyPlaces
    case imageWithMarkers
}

