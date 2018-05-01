//
//  Favourites.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/20/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

class Favourites: NSObject {
    
    var movieID: String?
    var movieName: String?
    var posterPath: String?
    var userID: String?
    
    let backdrop: String?
    let releaseDate: String?
    let rating:String?
    let overview:String?
    let originalTitle:String?
    
    init(dictionary: [String: AnyObject]) {
        self.movieID = dictionary["movieID"] as? String
        self.movieName = dictionary["movieName"] as? String
        self.posterPath = dictionary["moviePosterPath"] as? String
        self.userID = dictionary["userId"] as? String
        
        self.backdrop = dictionary["backdrop"] as? String
        self.releaseDate = dictionary["releaseDate"] as? String
        self.rating = dictionary["rating"] as? String
        self.overview = dictionary["overview"] as? String
        self.originalTitle = dictionary["originalTitle"] as? String
    }


}
