//
//  ViewController.swift
//  SDKAssignment
//
//  Created by ceinfo on 06/09/24.
//

import UIKit

class HomeViewController: UIViewController {

    let tblView = UITableView()
    var tblCellDataArr: [SectionInfo] = []
    let tblData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.title = "SDK Assignment"
        self.navigationItem.title = "SDK Assignment"
        view.addSubview(tblView)
        tblView.frame = view.bounds
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        self.setTableData()
        
    }
    
    func setTableData() {
        var section1 = SectionInfo()
        section1.headerTitle = "Section 1"
        section1.cellInfo.append(CellInfo(name: "Show Popup / Plot a Marker / Custom popup on click", cellType: .showPopup))
        tblCellDataArr.append(section1)
        
        var section2 = SectionInfo()
        section2.headerTitle = "Section 2"
        section2.cellInfo.append(CellInfo(name: "Show Map", cellType: .showMap))
        section2.cellInfo.append(CellInfo(name: "Zoom Center", cellType: .zoomCenter))
        section2.cellInfo.append(CellInfo(name: "Zoom Center with Animation", cellType: .zoomCenterWithAnimation))
        section2.cellInfo.append(CellInfo(name: "Custom Marker", cellType: .customMarker))
        section2.cellInfo.append(CellInfo(name: "Custom Marker with highlighted", cellType: .customMarkerWithHighlighted))
        section2.cellInfo.append(CellInfo(name: "Plot a polyline", cellType: .plotPolyline))
        section2.cellInfo.append(CellInfo(name: "Plot a polyline with custom color", cellType: .plotPolylineWithCustomColor))
        section2.cellInfo.append(CellInfo(name: "Plot a polygon", cellType: .plotPolygon))
        section2.cellInfo.append(CellInfo(name: "Plot a polygon with custom color", cellType: .plotPolygonWithCustomColor))
        section2.cellInfo.append(CellInfo(name: "Plot a polygon with opacity", cellType: .plotPolygonWithOpacity))
        tblCellDataArr.append(section2)
        
        var section3 = SectionInfo()
        section3.headerTitle = "Section 3"
        section3.cellInfo.append(CellInfo(name: "Reverse geocode", cellType: .reverseGeocode))
        section3.cellInfo.append(CellInfo(name: "Details of a place", cellType: .detailsPlace))
        section3.cellInfo.append(CellInfo(name: "Distance between two locations", cellType: .distanceBetweenTwoLocations))
        section3.cellInfo.append(CellInfo(name: "Nearby places", cellType: .nearbyPlaces))
        section3.cellInfo.append(CellInfo(name: "Image of a map with markers", cellType: .imageWithMarkers))
        tblCellDataArr.append(section3)
        
        tblView.reloadData()
        
    }

    func showMap(name: String, type: CellType) {
        let vc = CommonMapVC()
        vc.screenType = type
        vc.title = name
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tblCellDataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblCellDataArr[section].cellInfo.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tblCellDataArr[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.textLabel?.text = tblCellDataArr[indexPath.section].cellInfo[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tblData = tblCellDataArr[indexPath.section].cellInfo[indexPath.row]
        if tblData.cellType == .imageWithMarkers {
            let vc = ImageOfMapVC()
            present(vc, animated: true, completion: nil)
            return
        }
        
        showMap(name: tblData.name!, type: tblData.cellType!)
    }
    
}
