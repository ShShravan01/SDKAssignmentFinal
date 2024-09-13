//
//  CommonMapVC.swift
//  SDKAssignment
//
//  Created by ceinfo on 06/09/24.
//

import UIKit
import MapplsMap
import MapplsAPIKit
import MapplsUIWidgets

class CommonMapVC: UIViewController {
    
    let mapView = MapplsMapView()
    var screenType: CellType = .showMap
    let searchbar = UISearchController(searchResultsController: nil)
    var tempAnnotations = [MGLPointAnnotation]()
    let rCoordinate = CLLocationCoordinate2D(latitude: 23.344315, longitude: 85.296013)
    
    var viewBottom: UIView = UIView()
    
    let txt: UILabel = {
        let txt = UILabel()
        txt.textColor = .white
        txt.font = .systemFont(ofSize: 15, weight: .semibold)
        txt.textAlignment = .center
        txt.numberOfLines = 0
        txt.text = "Wait.........."
        return txt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.viewBottom.backgroundColor = .darkGray
        self.txt.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        self.mapView.showsUserLocation = true
        view.addSubview(self.mapView)
        view.addSubview(self.viewBottom)
        self.mapView.frame = view.bounds
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
        
        self.viewBottom.addSubview(self.txt)
        self.viewBottom.isHidden = true
        self.txt.isHidden = true
        
        self.viewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.viewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.viewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.viewBottom.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.txt.topAnchor.constraint(equalTo: self.viewBottom.topAnchor, constant: 10).isActive = true
        self.txt.leadingAnchor.constraint(equalTo: self.viewBottom.leadingAnchor, constant: 10).isActive = true
        self.txt.trailingAnchor.constraint(equalTo: self.viewBottom.trailingAnchor, constant: -10).isActive = true
        self.txt.bottomAnchor.constraint(equalTo: self.viewBottom.bottomAnchor, constant: -10).isActive = true
        DispatchQueue.main.async {
            self.setupMapUI()
        }
        
    }
    
    func setupMapUI() {
        switch screenType {
        case .showPopup:
            let point = CustomAnnotation(coordinate: rCoordinate, title: "Ranchi, Jharkhand, India", subtitle: nil)
           
            self.mapView.addAnnotation(point)
            self.mapView.setCenter(rCoordinate, zoomLevel: 15, animated: false)
            
        case .showMap:
            self.mapView.userTrackingMode = .followWithCourse
            
        case .zoomCenter:
            self.mapView.setCenter(rCoordinate, zoomLevel: 15, animated: false)
            
        case .zoomCenterWithAnimation: break
            
        case .customMarker:
            let image = UIImage(named: "location_on_24dp")
            let point = CustomAnnotation(coordinate: rCoordinate, title: "Ranchi, Jharkhand, India", subtitle: nil)
            point.reuseIdentifier = "customAnnotation"
            point.image = image
            self.mapView.addAnnotation(point)
            self.mapView.zoomLevel = 15
            self.mapView.centerCoordinate = rCoordinate
            
        case .customMarkerWithHighlighted:
            var pointAnnotations = [CustomAnnotation]()
            
            let places = self.markerCoordinates()
            places.forEach { (key: String, value: (Double, Double)) in
                let coordinate = CLLocationCoordinate2D(latitude: value.0, longitude: value.1)
                let count = pointAnnotations.count + 1
                let annotation = CustomAnnotation(coordinate: coordinate, title: key, subtitle: nil)
                annotation.reuseIdentifier =  "CustomAnnotation\(count)"
                annotation.image = UIImage(named: "location_on_24dp")
                pointAnnotations.append(annotation)
            }
            
            self.mapView.addAnnotations(pointAnnotations)
            if let annotations = mapView.annotations {
                self.mapView.showAnnotations(annotations, animated: true)
            }
            
        case .plotPolyline, .plotPolylineWithCustomColor :
            var coordinates = self.dummyCoordinate()
            let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
            self.mapView.addAnnotation(polyline)
            let shapeCam = mapView.cameraThatFitsShape(polyline, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            self.mapView.setCamera(shapeCam, animated: false)
            
        case .plotPolygon, .plotPolygonWithCustomColor, .plotPolygonWithOpacity:
            var coordinates = self.dummyCoordinate()
            let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
            self.mapView.addAnnotation(polygon)
            
            let shapeCam = self.mapView.cameraThatFitsShape(polygon, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            self.mapView.setCamera(shapeCam, animated: false)
            
        case .reverseGeocode:
            self.reverseGeocode()
            
        case .detailsPlace:
            navigationItem.searchController = self.searchbar
            self.searchbar.searchBar.delegate = self
            
        case .distanceBetweenTwoLocations:
            self.distanceBetween()
            
        case .nearbyPlaces: break
            
        case .imageWithMarkers: break
            
        }
    }
    
    func alertShow(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    
    func distanceBetween() {
        let distanceMatrixManager = MapplsDrivingDistanceMatrixManager.shared
        let distanceMatrixOptions = MapplsDrivingDistanceMatrixOptions(center:
            CLLocation(latitude: 23.344315, longitude: 85.296013), points:
            [CLLocation(latitude: 24.11718, longitude: 85.8121)])
        distanceMatrixOptions.resourceIdentifier = .eta
        
        var point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 23.344315, longitude: 85.296013)
        point.title = "Ranchi, Jharkhand, India"
        self.mapView.addAnnotation(point)
        tempAnnotations.append(point)
        
        point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 24.11718, longitude: 85.8121)
        point.title = "unnamed road, Giridih, -, Jharkhand, India"
        self.mapView.addAnnotation(point)
        tempAnnotations.append(point)
        
        self.mapView.showAnnotations(tempAnnotations, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
        
        distanceMatrixManager.getResult(distanceMatrixOptions) { (result, error) in
            if let error = error {
                NSLog("%@", error)
            } else if let result = result, let results = result.results, let durations = results.durations?[0], let distances = results.distances?[0] {
                let pointCount = distanceMatrixOptions.points?.count ?? -1
                for i in 0..<pointCount {
                    if i < distances.count {
                        var distance = distances[i].intValue
                        var dist: String = ""
                        if distance > 1000 {
                            dist = "Distance : \(distance / 1000) km"
                        } else {
                            dist = "Distance : \(distance) m"
                        }
                        
                        DispatchQueue.main.async {
                            self.viewBottom.isHidden = false
                            self.txt.isHidden = false
                            self.txt.text = dist
                        }
                        if (i == 0) {
                            break
                        }
                    }
                }
            } else {
                print("No results")
            }
        }
    }

    func reverseGeocode() {
        self.viewBottom.isHidden = false
        self.txt.isHidden = false
        self.txt.text = "latitude: 23.344315, longitude: 85.296013"
        
        let coordinate = CLLocationCoordinate2D(latitude: 23.344315, longitude: 85.296013)
        self.mapView.setCenter(coordinate, zoomLevel: 15, animated: false)
        
        let point = MGLPointAnnotation()
        point.coordinate = coordinate
        self.mapView.addAnnotation(point)
        
        let reverseGeocodeManager = MapplsReverseGeocodeManager.shared
        
        let revOptions = MapplsReverseGeocodeOptions(coordinate: coordinate, withRegion: .india)
        reverseGeocodeManager.reverseGeocode(revOptions) { (placemarks, attribution, error) in
            if let error = error {
                self.txt.text = "Something went wrong."
                self.txt.textColor = .red
                print("%@", error)
            } else if let placemarks = placemarks, !placemarks.isEmpty {
                self.txt.text = placemarks[0].formattedAddress
                
            } else {
                self.txt.text = "No results"
               
            }
        }
    }
    
    func nearbyPlace() {
        let nearByManager = MapplsNearByManager.shared
        let filter = MapplsNearbyKeyValueFilter(filterKey: "brandId", filterValues: ["String","String"])
        let sortBy = MapplsSortByDistanceWithOrder(orderBy: .ascending)
        let nearByOptions = MapplsNearbyAtlasOptions(query: "Restaurants", location: "23.344315,85.296013")
        nearByOptions.sortBy = sortBy
        nearByOptions.searchBy = .distance
        
        nearByManager.getNearBySuggestions(nearByOptions) { (suggestions, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let suggestions = suggestions?.suggestions, !suggestions.isEmpty {
                
                var mapplsPin: [String] = []
                var annotations: [MapplsPointAnnotation] = []
                for i in 0..<suggestions.count {
                    let point = MapplsPointAnnotation(mapplsPin: suggestions[i].mapplsPin ?? "")
                    point.title = "nearByAnnotations"
                    annotations.append(point)
                    
                    mapplsPin.append(suggestions[i].mapplsPin ?? "")
                }
                self.mapView.addMapplsAnnotations(annotations) { success, error in
                    
                    self.mapView.addAnnotations(annotations)
                }
                DispatchQueue.main.async {
                    self.mapView.showMapplsPins(mapplsPin, animated: true)
                }
                
            }
        }
    }
    
}

extension CommonMapVC: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if screenType == .zoomCenterWithAnimation {
             let coordinate = CLLocationCoordinate2D(latitude: 23.344315, longitude: 85.296013)
             mapView.setCenter(coordinate, zoomLevel: 15, animated: true)
        }
        if screenType == .nearbyPlaces {
            
            self.nearbyPlace()
        }
        
    }
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if screenType == .customMarkerWithHighlighted {
            if let point = annotation as? CustomAnnotation {
                
            }
        }
        
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if screenType == .customMarker || screenType == .customMarkerWithHighlighted {
            if let point = annotation as? CustomAnnotation ,
                let image = point.image,
                let reuseIdentifier = point.reuseIdentifier {
                if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier) {
                    return annotationImage
                } else {
                    return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
                }
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if screenType == .customMarkerWithHighlighted {
            guard annotation is CustomAnnotation, let customPointAnnotation = annotation as? CustomAnnotation else {
                return nil
            }
           
            let reuseIdentifier = "\(customPointAnnotation.coordinate.longitude)"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier, image: customPointAnnotation.image!)
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
      return 10.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking
        if screenType == .plotPolylineWithCustomColor {
            if annotation is MGLPolyline {
                if let customPolyline = annotation as? MGLPolyline {
                    return .green
                }
                return .red
            }
        }
        
        return mapView.tintColor
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        if screenType == .plotPolygonWithCustomColor {
            return UIColor.red
        }
        
        return UIColor.blue
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        if screenType == .plotPolygonWithOpacity {
            return 0.5
        }
        return  1.0
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        if screenType == .showPopup {
            return CustomCalloutView(representedObject: annotation)
        }
        return nil
    }
}

extension CommonMapVC: UISearchBarDelegate, MapplsAutocompleteViewControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let autoCompleteVC = MapplsAutocompleteViewController()
        autoCompleteVC.delegate = self
        present(autoCompleteVC, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withSuggestion suggestion: MapplsAPIKit.MapplsSearchPrediction) {
        
    }
    
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withPlace place: MapplsAPIKit.MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        self.dismiss(animated: true)
        
        self.viewBottom.isHidden = false
        self.txt.isHidden = false
        self.txt.text = "\(place.placeName!) , \(place.placeAddress!)"
       
        if let lat = place.latitude, let lng = place.longitude {
            
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
            
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = place.placeName
            self.mapView.addAnnotation(point)
            
        } else {
            let point  = MapplsPointAnnotation(mapplsPin: place.mapplsPin!)
            point.title = "nearByAnnotations"
            mapView.addMapplsAnnotation(point)
        }
        self.dismiss(animated: true)
    }
    
    func didFailAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withError error: NSError) {
        
    }
    
    func wasCancelled(viewController: MapplsUIWidgets.MapplsAutocompleteViewController) {
        
    }
    
}

extension CommonMapVC {
    
    func dummyCoordinate() -> [CLLocationCoordinate2D] {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
            CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
            CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
            CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
            CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
            CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
        ]
        
        return coordinates
    }
    
    func markerCoordinates() -> [String: (Double, Double)] {
        let placesCoordinates: [String: (Double, Double)] = [
            "Delhi": (28.6139, 77.2090),
            "Mumbai": (19.0760, 72.8777),
            "Bangalore": (12.9716, 77.5946),
            "Kolkata": (22.5726, 88.3639),
            "Chennai": (13.0827, 80.2707),
            "Hyderabad": (17.3850, 78.4867),
            "Ahmedabad": (23.0225, 72.5714),
            "Pune": (18.5204, 73.8567),
            "Jaipur": (26.9124, 75.7873),
            "Lucknow": (26.8467, 80.9462),
            "Kanpur": (26.4499, 80.3319),
            "Nagpur": (21.1458, 79.0882),
            "Indore": (22.7196, 75.8577),
            "Bhopal": (23.2599, 77.4126),
            "Patna": (25.5941, 85.1376),
            "Vadodara": (22.3072, 73.1812),
            "Ludhiana": (30.9010, 75.8573),
            "Agra": (27.1767, 78.0081),
            "Nashik": (19.9975, 73.7898),
            "Faridabad": (28.4089, 77.3178),
            "Meerut": (28.9845, 77.7064),
            "Rajkot": (22.3039, 70.8022),
            "Varanasi": (25.3176, 82.9739),
            "Srinagar": (34.0837, 74.7973),
            "Aurangabad": (19.8762, 75.3433),
            "Dhanbad": (23.7957, 86.4304),
            "Amritsar": (31.6340, 74.8723),
            "Jodhpur": (26.2389, 73.0243),
            "Raipur": (21.2514, 81.6296),
            "Kota": (25.2138, 75.8648),
            "Guwahati": (26.1445, 91.7362),
            "Chandigarh": (30.7333, 76.7794),
            "Mysore": (12.2958, 76.6394),
            "Ranchi": (23.3441, 85.3096),
            "Dehradun": (30.3165, 78.0322),
            "Gwalior": (26.2183, 78.1828),
            "Vijayawada": (16.5062, 80.6480),
            "Jalandhar": (31.3260, 75.5762),
            "Madurai": (9.9252, 78.1198),
            "Tiruchirappalli": (10.7905, 78.7047),
            "Udaipur": (24.5854, 73.7125),
            "Salem": (11.6643, 78.1460),
            "Ajmer": (26.4499, 74.6399),
            "Guntur": (16.3067, 80.4365),
            "Solapur": (17.6599, 75.9064),
            "Thiruvananthapuram": (8.5241, 76.9366),
            "Warangal": (17.9784, 79.6010),
            "Hubli": (15.3647, 75.1240),
            "Shimla": (31.1048, 77.1734)
        ]
        return placesCoordinates
    }
    
}
