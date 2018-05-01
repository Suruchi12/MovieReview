//
//  Extentions.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/8/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

private var userProfilePhotoCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCacheWithURLString(urlString: String){
        
        self.image = nil
        //check if images are already cached
        
        if let cachedImage = userProfilePhotoCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //else download from firebase 
            let url = URL(string: urlString)
            print("Review Controller profilePicURL: " + String(describing: url))
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil{
                    print(error!)
                    return
                }
                
                print(data!)
                //DispatchQueue.main.async {cell.imageView?.image = UIImage(data: data!) }
                DispatchQueue.main.async {
                    //cell.imageView?.image = UIImage(data: data!)
                   // cell.profileImageView.image = UIImage(data: data!)
                    
                    if let firebaseImage = UIImage(data: data!){
                        
                        userProfilePhotoCache.setObject(firebaseImage, forKey: urlString as NSString)
                        //self.image = UIImage(data: data!)
                        self.image = firebaseImage
                    }
                    
                    
                }
                
            }).resume()
        
        
    }
}

//MARK:- Download Image from a URL
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func downloadImageUsingCache(_ urlLink: String){
        self.image = nil
        if urlLink.isEmpty {
            return
        }
        if let cachedImage = imageCache.object(forKey: urlLink as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlLink)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error{
                print(error)
                return
            }
            
            DispatchQueue.main.async() {
                if let newImage = UIImage(data: data!){
                    imageCache.setObject(newImage, forKey: urlLink as NSString)
                    self.image = newImage
                }
            }
            
            }.resume()
    }
}


//MARK:- Constraints
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}

//MARK:- Hex to String for colors
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//MARK:- Hide Keyboard 
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

/*
extension UITableViewController
{
    @objc func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
*/
