//
//  CustomTabBarController.swift
//  Suruchi_Assignment3
//
//  Created by Suruchi Singh on 3/19/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = TableViewController()
        let popularController = UINavigationController(rootViewController: controller)
        popularController.tabBarItem.title = "Popular"
        popularController.tabBarItem.image = UIImage(named: "PopularIcon")
        
        let topRatedController = TopRatedTableViewController()
        let topRatedMovies = UINavigationController(rootViewController: topRatedController)
        topRatedMovies.tabBarItem.title = "Top Rated"
        topRatedMovies.tabBarItem.image = UIImage(named: "Favorite")
        
        let upcomingController = UpcomingTableViewController()
        let upcomingMovies = UINavigationController(rootViewController: upcomingController)
        upcomingMovies.tabBarItem.title = "Upcoming"
        upcomingMovies.tabBarItem.image = UIImage(named: "Upcoming")
        
        let favouriteController = FavouriteViewController()
        let favouriteMovies = UINavigationController(rootViewController: favouriteController)
        favouriteMovies.tabBarItem.title = "Favourites"
        favouriteMovies.tabBarItem.image = UIImage(named: "bookmark")
        
        viewControllers = [popularController,upcomingMovies,topRatedMovies,favouriteMovies]
    }
    
    
    private func createNavigationController(title: String, imageName: String)->UINavigationController{
        
        let viewController = TableViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
        
    }
}
