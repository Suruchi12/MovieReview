//
//  Reviews.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/14/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

@objcMembers
class Reviews: NSObject {
 
    var reviewId: String?
    var movieId: String?
    var review: String?
    var reviewUserId: String?
    var likeCount: Int?
    var disLikeCount: Int?
    
    init(dictionary: [String: AnyObject]) {
        self.movieId = dictionary["movieId"] as? String
        self.review = dictionary["review"] as? String
        self.reviewUserId = dictionary["reviewUserId"] as? String
        self.likeCount = dictionary["likeCount"] as? Int
        self.disLikeCount = dictionary["disLikeCount"] as? Int
    }
   
}
