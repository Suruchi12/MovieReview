//
//  DetailViewController.swift
//  JSON
//
//  Created by Suruchi Singh on 3/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var link: String = ""
    var movie : MovieInfo?{
        
        didSet{
            
            navigationItem.title = self.movie?.title
       
            let id = movie?.id
            print("DVC didSet Movie ID is : \(id!)")
            link = "https://api.themoviedb.org/3/movie/\(id!)?api_key=9833efb4636d8626663b18c31ccdc1a9"
        }
    }
    
    let header:DetailHeader = {
        
        let header = DetailHeader()
        print("Detail View Controller Header movie title : \(header.releaseDate.text!)")
        return header
    }()
    
    let poster:DetailPoster = {
        
        let poster = DetailPoster()
        print("poster is : \(poster)")
        return poster
    }()
    
    
     let overview:DetailDescription = {
     
       let overview = DetailDescription()
        print("overview :  \(overview)")
       return overview
     }()
 
    func setupViews(){
        
        //view.backgroundColor = UIColor.cyan
        //let view = UIView()
        //view.backgroundColor = #colorLiteral(red: 0.6141117286, green: 0.9503401797, blue: 0.9686274529, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 1, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        header.movie = movie
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
 
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //header.backgroundColor = .red
        header.setupViews()
        
        poster.movie = movie
        view.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        poster.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        poster.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        poster.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        poster.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        //poster.bottomAnchor.constraint(equalTo: overview.topAnchor).isActive = true
        poster.setupViews()
        poster.backgroundColor = .clear
        //poster.backgroundColor = .green
        
        overview.movie = movie
        view.addSubview(overview)
        overview.translatesAutoresizingMaskIntoConstraints = false
        
        overview.topAnchor.constraint(equalTo: poster.bottomAnchor).isActive = true
        overview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       // overview.backgroundColor = UIColor.gray
        
        overview.setupViews()
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    
    }
    
}

