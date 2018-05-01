//
//  MovieFavouriteCell.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/16/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

protocol FavoriteCellDelegate {
    
    func didFavorite(for cell: MovieFavouriteCell)
    func didUnFavorite(for cell: MovieFavouriteCell)
    
}

class MovieFavouriteCell: UITableViewCell {

   
    
    var cellFavoriteDelegate: FavoriteCellDelegate?
    
    lazy var favouriteButton: UIButton = {
        
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.tintColor = .blue
        //let tapGesture = UITapGestureRecognizer(target: self, action: "normalTap")
        //favouriteButton.addGestureRecognizer(tapGesture)
        favouriteButton.setImage(#imageLiteral(resourceName: "emptyStar").withRenderingMode(.alwaysOriginal), for: .normal)
        //favouriteButton.setImage(#imageLiteral(resourceName: "GoldStar").withRenderingMode(.alwaysOriginal), for: .selected)
        //favouriteButton.setImage(#imageLiteral(resourceName: "filledStar").withRenderingMode(.alwaysOriginal), for: .highlighted)
        favouriteButton.addTarget(self, action: #selector(handleFavourite), for: .touchUpInside)
        //favouriteButton.backgroundColor = .clear
        return favouriteButton
    }()
    
    @objc func handleFavourite() {
        
        print("favourite button tapped!")
        
        if favouriteButton.isSelected  == true{
        
                favouriteButton.isSelected = false
                favouriteButton.setImage(#imageLiteral(resourceName: "GoldStar").withRenderingMode(.alwaysOriginal), for: .normal)
                cellFavoriteDelegate?.didFavorite(for: self)
            
        }
        else{
            
                favouriteButton.isSelected = true
                favouriteButton.setImage(#imageLiteral(resourceName: "emptyStar").withRenderingMode(.alwaysOriginal), for: .normal)
                cellFavoriteDelegate?.didUnFavorite(for: self)
            

        }
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        favouriteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        favouriteButton.tintColor = .blue
        favouriteButton.setImage(#imageLiteral(resourceName: "emptyStar").withRenderingMode(.alwaysOriginal), for: .normal)
        //favouriteButton.setImage(#imageLiteral(resourceName: "GoldStar").withRenderingMode(.alwaysOriginal), for: .selected)
        
        //favouriteButton.setImage(#imageLiteral(resourceName: "filledStar").withRenderingMode(.alwaysOriginal), for: .highlighted)
        
        
        accessoryView = favouriteButton
//
//        addSubview(favouriteButton)
//
//        favouriteButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
//        favouriteButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
//        favouriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        favouriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
