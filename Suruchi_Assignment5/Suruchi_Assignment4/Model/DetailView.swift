//
//  DetailView.swift
//  JSON
//
//  Created by Suruchi Singh on 3/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class DetailHeader: UIView{
    
    
    var movie: MovieInfo?{
        didSet{
            starRating.rating = (movie?.rating)!/2
            //print("\(starRating.rating)")
            //print(movie?.rating! as Any)
            releaseDate.text? = "Release Date : \(((movie?.releaseDate)!))"
            originalTitle.text? = "Original Title : \((movie?.originalTitle)!)"
           
        }
    }
    
    let releaseDate:UILabel = {
        let label = UILabel()
        label.text = "Release Date : "
        label.lineBreakMode = .byWordWrapping
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.font = UIFont(name: "GillSans-Bold", size: 18)
        label.textAlignment = .justified
        //label.textColor = #colorLiteral(red: 0.05113129139, green: 0.2124793829, blue: 0.3647023833, alpha: 1)
        //label.textColor = #colorLiteral(red: 0.7499549801, green: 0.6194272855, blue: 0.1780379241, alpha: 1)
        label.textColor = #colorLiteral(red: 0.867128014, green: 0.06622438255, blue: 0.3932782574, alpha: 1)
        label.backgroundColor = .clear
        
        return label
    }()
    
    let starRating: FiveStarRating = {
        let starRating = FiveStarRating(frame: CGRect(x: 100, y: 100, width: 120, height: 120))
        
        return starRating
    }()
    
    let dividerLineView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    let originalTitle:UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.text = "Original Title: "
        label.font = UIFont(name: "GillSans-Bold", size: 15)
        label.textAlignment = .justified
        label.textColor = #colorLiteral(red: 0.867128014, green: 0.06622438255, blue: 0.3932782574, alpha: 1)
        label.backgroundColor = .clear
        return label
    }()
    
    
    func setupViews(){
        
        let stackView:UIStackView = {
            
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillProportionally
            
            
            addSubview(originalTitle)
            addSubview(releaseDate)
            addSubview(starRating)
            addConstraintsWithFormat(format: "H:|-20-[v0(300)]", views: originalTitle)
            addConstraintsWithFormat(format: "H:|-20-[v0]", views: starRating)
            addConstraintsWithFormat(format: "H:|-20-[v0(300)]", views: releaseDate)
            addConstraintsWithFormat(format: "V:[v0][v1(20)][v2]-10-|", views: starRating,releaseDate,originalTitle)
//            stackView.addSubview(starRating)
//            addConstraintsWithFormat(format: "H:|-20-[v0]", views: starRating)
//            addConstraintsWithFormat(format: "V:[v0(20)]|", views: starRating)

            return stackView
            
        }()
        
        addSubview(stackView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: stackView)
        addConstraintsWithFormat(format: "V:|[v0]-30-|", views: stackView)
        
        /*
        addSubview(releaseDate)
        addSubview(starRating)
       
        
        addConstraintsWithFormat(format: "H:|-20-[v0]", views: starRating)
        addConstraintsWithFormat(format: "V:[v0(20)]-5-[v1]|", views: releaseDate,starRating)
        addConstraintsWithFormat(format: "H:|-20-[v0(300)]", views: releaseDate)
        */
        
        //addConstraintsWithFormat(format: "V:[v0(75)]|", views: starRating) //works

    }
    
}
class DetailDescription: UIView{
    
    //var movie: MovieInfo?
    
    var movie: MovieInfo?{
        didSet{
            if movie?.overview == nil{
                textView.text = "No Plot"
            }
            else{
            
                textView.text = "Plot \n\n\((movie?.overview)!)"
            }
            
        }
    }
    
    let textView : UITextView = {
       
        let textView = UITextView()
        textView.text = "Plot:\n\n"
        textView.font = UIFont(name: "HoeflerText-BlackItalic", size: 18)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textAlignment = .justified
        textView.textColor = #colorLiteral(red: 0.05113129139, green: 0.2124793829, blue: 0.3647023833, alpha: 1)
        textView.backgroundColor = .clear
        textView.sizeToFit()
        textView.isEditable = false
        //textView.textContainer.maximumNumberOfLines = 0;
        
        return textView
    }()
    
    let dividerLineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    func setupViews(){
        
        //textView.text.append((movie?.overview)!)
        addSubview(textView)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: textView)
        //addConstraintsWithFormat(format: "V:|[v0]-30-|", views: textView)
        addConstraintsWithFormat(format: "V:|-10-[v0]|", views: textView)
        
        
        //addSubview(dividerLineView)
        //addConstraintsWithFormat(format: "V:[v0(20)]|", views: dividerLineView)
    
    }
    
}

class DetailPoster: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
 
   
    var urlSample = URL(string : "")
    var backdropUrl = URL(string : "")
    var stringBackdrop : String = ""
    
    var movie: MovieInfo?{
        didSet{
            
            let posterpath = (movie?.posterPath)!
            let link = "https://image.tmdb.org/t/p/w154/\(posterpath)"
            stringBackdrop = link
            urlSample = URL(string: link)
            
            print((movie?.posterPath)!)
            
            let urlBackdrop = (movie?.backdrop)!
            let backdropLink = "http://image.tmdb.org/t/p/w154/" + urlBackdrop
            print((movie?.backdrop)!)
            backdropUrl = URL(string: backdropLink)
        }
    }
    
    let imageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let backImage:UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let dividerLineView:UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white:0.4, alpha:0.4)
        return view
    }()
    
    let label:UILabel = {
        let label = UILabel()
        label.text = "Testing"
        return label
    }()
    
    //Collection View
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame:.zero, collectionViewLayout:layout)
        return cv
    }()
    
    func setupViews(){

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        addSubview(collectionView)
        //addSubview(dividerLineView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(PosterImageCell.self, forCellWithReuseIdentifier: "cellId")
        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
//
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PosterImageCell
       // cell.imageView.contentMode = .scaleAspectFill
        //cell.imageView.layer.masksToBounds = false
         cell.imageView.clipsToBounds = false
        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
        if indexPath.item%2 == 0{
            cell.imageView.downloadImageUsingCache(String(describing: urlSample!))
            cell.imageView.contentMode = .scaleAspectFit
            print("%2 == 0")
         }
         else{
            print("%2!=0")
            //cell.imageView.downloadedFrom(link: stringBackdrop)
            cell.imageView.downloadImageUsingCache(stringBackdrop)
            cell.imageView.contentMode = .scaleAspectFit

          
         }
        //cell.imageView.image = #imageLiteral(resourceName: "About")
        //cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //return CGSize(width: 155, height: 200)
        return CGSize(width: 100, height: 100)
    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        var numberOfCellInRow : Int = 3
//        var padding : Int = 5
//        var collectionCellWidth : CGFloat = (view.frame.size.width/CGFloat(numberOfCellInRow)) - CGFloat(padding)
//        return CGSize(width: collectionCellWidth , height: collectionCellWidth)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    
    fileprivate class PosterImageCell: UICollectionViewCell {
        var imageView: UIImageView = {
            let iv = UIImageView()
            //iv.contentMode = .scaleAspectFit
            return iv
        }()
        
        fileprivate func  setupViews(){
            
            layer.masksToBounds = true
            self.imageView.autoresizingMask.insert(.flexibleHeight)
            self.imageView.autoresizingMask.insert(.flexibleWidth)
            addSubview(imageView)
            self.translatesAutoresizingMaskIntoConstraints = false

//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))

            addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
            addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    
}
