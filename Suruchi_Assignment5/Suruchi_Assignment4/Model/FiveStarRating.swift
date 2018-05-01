//
//  FiveStarRating.swift
//  JSON
//
//  Created by Suruchi Singh on 3/18/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class FiveStarRating: UIStackView{
    
    private var ratingButtons = [UIButton]()
    var rating : Double = 0.0 {
        
        didSet{
            updateButtonSelected()
        }
    }
    
    var starCount:Int = 5 {
        
        didSet{
            setupButtons()
        }
    }
    
    override init(frame:CGRect){
        
        super.init(frame:frame)
        
        isUserInteractionEnabled = false
        spacing = 8
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if Double(selectedRating) == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = Double(selectedRating)
            print(rating)
        }
    }
    
    private func setupButtons(){
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        for _ in 0..<starCount{
            
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "filledStar"), for: .selected)
            button.setImage(#imageLiteral(resourceName: "highlightedStar"), for: .highlighted)
            button.setImage(#imageLiteral(resourceName: "highlightedStar"), for: [.highlighted,.selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            ratingButtons.append(button)
            
        }
         updateButtonSelected()
    }
    
     func updateButtonSelected() {
        
        let myIntRate = Int(rating.rounded(.towardZero))
        
        for (index, button) in ratingButtons.enumerated() {
           
            if index < myIntRate {
                button.isSelected = true
            }
            
            else if(rating - rating.rounded(.towardZero) > 0.0 && (index == Int(rating.rounded(.towardZero)))){
                
                button.setImage(#imageLiteral(resourceName: "starHalfSelected"), for: .selected)
                button.isSelected = true
            }
            
            else{
                button.isSelected = false
            }
         
        }
    }
    
    
}
