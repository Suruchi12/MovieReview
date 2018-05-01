//
//  MovieInfo.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class InfoCell: UITableViewCell{
    
    
    let header:DetailHeader = {
        
        let header = DetailHeader()
        return header
    }()
    
    let poster:DetailPoster = {
        
        let poster = DetailPoster()
        print("poster is : \(poster)")
        //poster.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.6644824423, blue: 0.747634101, alpha: 1)
        return poster
    }()
    
    
    let overview:DetailDescription = {
        
        let overview = DetailDescription()
        print("overview :  \(overview)")
        return overview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        let containerInfoView: UIView = {
            
            let containerInfo = UIView()
            containerInfo.backgroundColor = .clear
            return containerInfo
        }()
        
        //setupViews()
        //print(" Info Cell init :  \(String(describing: id))")
        //self.heightAnchor.constraint(lessThanOrEqualToConstant: 600)
        addSubview(containerInfoView)
        
        containerInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        containerInfoView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerInfoView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerInfoView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        //containerInfoView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        containerInfoView.addSubview(header)
        containerInfoView.addSubview(poster)
        containerInfoView.addSubview(overview)
        //constraints
        
        //Header Constraints
        header.translatesAutoresizingMaskIntoConstraints = false
        
        header.topAnchor.constraint(equalTo: containerInfoView.topAnchor).isActive = true
        //header.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //header.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: containerInfoView.leftAnchor).isActive = true
        //header.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: containerInfoView.heightAnchor, multiplier: 0.33).isActive = true
        header.widthAnchor.constraint(equalTo: containerInfoView.widthAnchor).isActive = true
        
        //header.backgroundColor = .red
        header.setupViews()
        
        //Poster Constraints
        
        
        //poster.movie = movie
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        poster.topAnchor.constraint(equalTo: self.header.bottomAnchor).isActive = true
        //poster.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor).isActive = true
        poster.leftAnchor.constraint(equalTo: containerInfoView.leftAnchor).isActive = true
        poster.widthAnchor.constraint(equalTo: containerInfoView.widthAnchor).isActive = true
        poster.heightAnchor.constraint(equalTo: containerInfoView.heightAnchor, multiplier: 0.33).isActive = true
        //poster.bottomAnchor.constraint(equalTo: self.overview.topAnchor).isActive = true
        poster.setupViews()
        poster.backgroundColor = .clear
        //poster.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.6644824423, blue: 0.747634101, alpha: 1)
        
        
        //OverView Constraints
        
        // overview.movie = movie
        
        overview.translatesAutoresizingMaskIntoConstraints = false
        
        overview.topAnchor.constraint(equalTo: self.poster.bottomAnchor).isActive = true
        overview.leftAnchor.constraint(equalTo: containerInfoView.leftAnchor).isActive = true
        //overview.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor).isActive = true
        //overview.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor).isActive = true
        overview.bottomAnchor.constraint(equalTo: containerInfoView.bottomAnchor).isActive = true
        overview.widthAnchor.constraint(equalTo: containerInfoView.widthAnchor).isActive = true
        //overview.heightAnchor.constraint(equalTo: containerInfoView.heightAnchor, multiplier: 0.33).isActive = true
        // overview.backgroundColor = UIColor.gray
        
        overview.setupViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
