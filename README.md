# Section 1: 
## How to integrate Mappls SDKs?
Sign Up and Get API Key to Visit :- https://apis.mappls.com/console/
Add API key in your project AppDelegate file : 
```
MapplsAccountManager.setMapSDKKey(".....")
MapplsAccountManager.setRestAPIKey("....")
MapplsAccountManager.setClientId("....")
MapplsAccountManager.setClientSecret("....")
MapplsAccountManager.setGrantType("client_credentials")
```
Add some Pods and install it :
```
pod 'MapplsAPICore', '1.0.11'
pod 'MapplsMap'
pod 'MapplsUIWidgets', '1.0.6'
```

## How does it initialize Mappls SDKs?
```
MapplsMapAuthenticator.sharedManager().initializeSDKSession { isSucess, error in
  if let error = error {
    // Map cannot be initilize
    print("error: \(error.localizedDescription)")
  } else {
    // Map is authorized sucessfully.
  }
}
```

## How to show a popup on click of Map Marker?
Add marker 

Use MGLAnnotation create custom Object and use Object as a MGLPointAnnotation().

```
let rCoordinate = CLLocationCoordinate2D(latitude: 23.344315, longitude: 85.296013)
let point = CustomAnnotation(coordinate: rCoordinate, title: "Ranchi, Jharkhand, India", subtitle: nil) 
        
self.mapView.addAnnotation(point)
```
Write custom code before use below code. Use this function to write popup on click of map marker.

```
func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
  return CustomCalloutView(representedObject: annotation) // Custom Annotation view
}
```

# Section 2: 
## How to show Mappls Map?
```
import MapplsMap
let mapView = MapplsMapView()
view.addSubview(self.mapView)
self.mapView.frame = view.bounds
```
## How to set zoom level and center of Map?
```
self.mapView.setCenter(rCoordinate, zoomLevel: 15, animated: false)
```

## How to set zoom level and center of Map with Animation.?
```
mapView.setCenter(coordinate, zoomLevel: 15, animated: true)
```
## How to plot a marker on Mappls Map?.
```
let point = MGLPointAnnotation()
point.coordinate = rCoordinate
point.title = "Annotation"
self.mapView.addAnnotation(point)
```

## Add a custom marker and when we click on the marker then display an InfoWindow/pop-up.
Use MGLAnnotation create custom Object and use Object as a MGLPointAnnotation().
```
let image = UIImage(named: "location_on_24dp")
let point = CustomAnnotation(coordinate: rCoordinate, title: "Ranchi, Jharkhand, India", subtitle: nil)
point.reuseIdentifier = "customAnnotation"
point.image = image
self.mapView.addAnnotation(point)
```

## Add 50 custom markers and when we click on a particular marker, the marker should be highlighted

```
var pointAnnotations = [CustomAnnotation]()      
let places = self.markerCoordinates() // it gives place name and coordinate list
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
```
Marker Add success then you can use this function to highlight code : 
```
func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {}
```

create custom Object use MGLAnnotationView.

## How to plot a polyline on Mappls Map?.
```
var coordinates = self.dummyCoordinate() // it gives coordinate list
let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
self.mapView.addAnnotation(polyline)
let shapeCam = mapView.cameraThatFitsShape(polyline, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
self.mapView.setCamera(shapeCam, animated: false)
```   
## How to plot a polyline with custom color on Mappls Map?
Write plot a polyline code before use below code. Use this function to change polyline color.

```
func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
  if annotation is MGLPolyline {
    if let customPolyline = annotation as? MGLPolyline {
      return .green
    }
    return .red
  }
}
```

## How to plot a polygon on Mappls Map?
```
var coordinates = self.dummyCoordinate() // it gives coordinate list
let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
self.mapView.addAnnotation(polygon)
let shapeCam = self.mapView.cameraThatFitsShape(polygon, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
self.mapView.setCamera(shapeCam, animated: false)
```

## How to plot a polygon with custom color?
Write plot a polygon code before use below code. Use this function to change polygon color.
```
func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
  return UIColor.red
}
```

## How to plot a polygon with opacity?
Write plot a polygon code before use below code. Use this function to change polygon opacity.
```
func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
  return 0.5
}
```
## How to show a custom popup on click of Map Marker?
Write custom code before use below code. Use this function to custom popup on click of map marker.
```
func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
  return CustomCalloutView(representedObject: annotation)
}
```

# Section 3:

## How to get human readable address information at a location/coordinate?
```
let coordinate = CLLocationCoordinate2D(latitude: 23.344315, longitude: 85.296013)
let reverseGeocodeManager = MapplsReverseGeocodeManager.shared
let revOptions = MapplsReverseGeocodeOptions(coordinate: coordinate, withRegion: .india)
reverseGeocodeManager.reverseGeocode(revOptions) { (placemarks, attribution, error) in
  if let error = error {
    print("%@", error)
  } else if let placemarks = placemarks, !placemarks.isEmpty {
    print(" Address: \(placemarks[0].formattedAddress)")
  } else {
    print("No results")
  }
}
```
## How to get details of a place by its name?
Add a search input box, and when the input box is clicked, open the search widget.
```
let searchbar = UISearchController(searchResultsController: nil)
navigationItem.searchController = self.searchbar
self.searchbar.searchBar.delegate = self
```
Search widget write in this function :
```
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
 let autoCompleteVC = MapplsAutocompleteViewController()
 autoCompleteVC.delegate = self
 present(autoCompleteVC, animated: true, completion: nil)
}
```	
When you search for a place, it should display a marker on that location.
Use this delegate ``` MapplsAutocompleteViewControllerDelegate ```

Use this function :
```
func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withPlace place: MapplsAPIKit.MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
  self.dismiss(animated: true)
  print("\(place.placeName!) , \(place.placeAddress!)")
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
}
```
## How to get road distance between two locations?
```
let distanceMatrixManager = MapplsDrivingDistanceMatrixManager.shared
let distanceMatrixOptions = MapplsDrivingDistanceMatrixOptions(center: CLLocation(latitude: 23.344315, longitude: 85.296013), points: [CLLocation(latitude: 24.11718, longitude: 85.8121)])
distanceMatrixOptions.resourceIdentifier = .eta  
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
        if (i == 0) {
          break
        }
      }
    }
  } else {
    print("No results")
  }
}
```

## How to get nearby places from a location of some specific category?
``` 
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
```
## How to get an image of a map with markers?
```
var urlComponents = URLComponents(string: "https://apis.mappls.com/advancedmaps/v1/b266d36c46a279bf83f769e3a184d4a3/still_image")
let queryItems = [
  URLQueryItem(name: "center", value: "23.344315,85.296013"),
  URLQueryItem(name: "zoom", value: "13"),
  URLQueryItem(name: "size", value: "400x400"),
  URLQueryItem(name: "ssf", value: "1"),
  URLQueryItem(name: "markers", value: "23.344315,85.296013"),
  URLQueryItem(name: "markers_icon", value: "https://cdn0.iconfinder.com/data/icons/essentials-solid-glyphs-vol-1/100/Location-Pin-Map-80.png")
]
        
urlComponents?.queryItems = queryItems
let url = urlComponents?.url
if let url = url {
  var request = URLRequest(url: url)
  request.httpMethod = "GET"
  NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
    guard let data = data else { return }
    if let image = UIImage(data: data) {
      let imageView = UIImageView(image: image)
      imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
      imageView.contentMode = .scaleAspectFit
      self.view.addSubview(imageView)
      return
    } else {
      print("Failed to convert data to image.")
    }
  }
}
```
