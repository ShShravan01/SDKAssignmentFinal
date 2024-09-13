//
//  ImageOfMapVC.swift
//  SDKAssignment
//
//  Created by ceinfo on 11/09/24.
//

import UIKit

class ImageOfMapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.imageOfMap()
    }
    
    func imageOfMap() {
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
    }

}
