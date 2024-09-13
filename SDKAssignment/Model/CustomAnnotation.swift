//
//  CustomAnnotation.swift
//  SDKAssignment
//
//  Created by ceinfo on 10/09/24.
//

import Foundation
import MapplsMap

class CustomAnnotation: NSObject, MGLAnnotation {
    var mapplsPin: String?
    
    func updateMapplsPin(_ atMapplsPin: String, completionHandler completion: ((Bool, String?) -> Void)? = nil) {
        
    }
   
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var reuseIdentifier: String?

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String? ) {
        self.coordinate = coordinate
        self.title = title
        self.mapplsPin = title
        self.subtitle = subtitle
    }
}


class CustomAnnotationView: MGLAnnotationView {
    var imageView = UIImageView()
  
    init(reuseIdentifier: String?, image: UIImage) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
      //  centerOffset = CGVector(dx: 0.0, dy: layer.bounds.height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true
        {
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.duration = 0.1
            layer.add(animation, forKey: "borderWidth")
            let selectedImg = self.imageView.image
            let myImage = selectedImg?.cgImage
            layer.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
            layer.contents = myImage
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            layer.setNeedsLayout()
        }
        else
        {
             let nonSelectedImg = self.imageView.image
             let myImage =   nonSelectedImg?.cgImage
             layer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
             layer.contents = myImage
             layer.setNeedsLayout()
        }
    }
}
