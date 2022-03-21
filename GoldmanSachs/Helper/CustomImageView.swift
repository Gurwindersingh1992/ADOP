//
//  CustomImageView.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImgUrlUsedToLoadImage: String?
    
    //// Returns activity indicator view centrally aligned inside the UIImageView
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    override func layoutSubviews() {
            layer.cornerRadius = 8
    }
    
    func loadImage(with urlString: String) {
        
        // set image to nil
        self.image = nil
        let activityIndicator = self.activityIndicator
        
        // set lastImgUrlUsedToLoadImage
        lastImgUrlUsedToLoadImage = urlString
        
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
        
        // check if image exists in cache
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            removeindicatior(indicator: activityIndicator)
            return
        }
        
        // url for image location
        guard let url = URL(string: urlString) else {
            removeindicatior(indicator: activityIndicator)
            return
        }
        
        // fetch contents of URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle error
            if let error = error {
                print("Failed to load image with error", error.localizedDescription)
            }
            
            if self.lastImgUrlUsedToLoadImage != url.absoluteString {
                self.removeindicatior(indicator: activityIndicator)
                return
            }
            
            // image data
            guard let imageData = data else {
                self.removeindicatior(indicator: activityIndicator)
                return
            }
            // create image using image data
            let photoImage = UIImage(data: imageData)?.resizeImage(With: CGSize(width: 200, height: 200))
            // set key and value for image cache
            imageCache[url.absoluteString] = photoImage
            
            // set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
            self.removeindicatior(indicator: activityIndicator)
        }.resume()
    }
    
    func removeindicatior(indicator : UIActivityIndicatorView){
        DispatchQueue.main.async {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}


extension UIImage{
    func resizeImage(With size : CGSize) -> UIImage?{
         
         //create graphic context.
         UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
         
         //Draw Image in graphic context.
        draw(in: CGRect(origin: .zero, size: size))
         
         //create image from Current Graphic Context.
         let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
         
         //clean up graphic context.
         UIGraphicsEndImageContext()
         
         return resizeImage
     }
}
