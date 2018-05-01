//
//  ReviewCell.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

protocol ReviewCellDelegate {
    func didLike(for cell: ReviewCell)
    func didDisLike(for cell: ReviewCell)
    func didEdit(for cell: ReviewCell)
}

class ReviewCell: UITableViewCell{
    
    var cellDelegate: ReviewCellDelegate?
    
    var likeButtonCount: Int = 0
    var disLikeButtonCount: Int = 0
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 90, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 90, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        
    }
    let profileImageView: UIImageView = {
        
        let userProfileImageView = UIImageView()
        userProfileImageView.image = UIImage(named: "defaultProfileImage")
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.layer.cornerRadius = 30
        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.contentMode = .scaleAspectFill
        return userProfileImageView
    }()
    
    lazy var editButton: UIButton = {
        
        let editButton = UIButton()
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        return editButton
    }()
    
    @objc func handleEdit() {
        
        cellDelegate?.didEdit(for: self)
    }
    
    lazy var likeButton: UIButton = {
        
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(#imageLiteral(resourceName: "like_icon"), for: .normal)
        //likeButton.setImage(#imageLiteral(resourceName: "icon-like-filled-2"), for: .selected)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return likeButton
    }()
    
    @objc func handleLike() {
        //print("Handle Like")
        self.likeButtonCount = self.likeButtonCount + 1
        print("likeButtonCount : \(String(describing: likeButtonCount))")
        cellDelegate?.didLike(for: self)
        //self.likeButtonLabel.text = "Likes: \(likeButtonCount)"
    }
    
    let likeButtonLabel: UILabel = {
        
        let likeButtonLabel = UILabel()
        //likeButtonLabel.text = "Likes: 0"
        likeButtonLabel.lineBreakMode = .byWordWrapping
        likeButtonLabel.font = UIFont(name: "GillSans", size: 12)
        likeButtonLabel.textAlignment = .justified
        likeButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return likeButtonLabel
    }()
    
    lazy var disLikeButton: UIButton = {
        
        let disLikeButton = UIButton()
        disLikeButton.translatesAutoresizingMaskIntoConstraints = false
        disLikeButton.setImage(#imageLiteral(resourceName: "200px-Broken_heart"), for: .normal)
        disLikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        return disLikeButton
    }()
    
    @objc func handleDisLike() {
        print("Handle Dis Like")
        self.disLikeButtonCount = self.disLikeButtonCount + 1
        print("DislikeButtonCount : \(String(describing: disLikeButtonCount))")
        cellDelegate?.didDisLike(for: self)
        //self.likeButtonLabel.text = "DisLikes: \(disLikeButtonCount)"
        
        
    }
    
    let disLikeButtonLabel: UILabel = {
        
        let disLikeButtonLabel = UILabel()
        disLikeButtonLabel.lineBreakMode = .byWordWrapping
        disLikeButtonLabel.font = UIFont(name: "GillSans", size: 12)
        disLikeButtonLabel.textAlignment = .justified
        //disLikeButtonLabel.text = "DisLikes: 0"
        disLikeButtonLabel.lineBreakMode = .byWordWrapping
        disLikeButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return disLikeButtonLabel
    }()
    
    
    let customTitleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "GillSans", size: 15)
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "HoeflerText-BlackItalic", size: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
        
        return titleLabel
    }()
    
    let customDetailLabel: UILabel = {
        
        let customDetailLabel = UILabel()
        customDetailLabel.lineBreakMode = .byWordWrapping
        customDetailLabel.font = UIFont(name: "GillSans", size: 20)
        //customDetailLabel.textAlignment = .left
        customDetailLabel.sizeToFit()
        customDetailLabel.numberOfLines = 2
        customDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        customDetailLabel.backgroundColor = .clear
        
        return customDetailLabel
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        customDetailLabel.sizeToFit()
        
        addSubview(profileImageView)
        setupButtons()
        addSubview(editButton)
        addSubview(customTitleLabel)
        addSubview(customDetailLabel)
        
        //addSubview(likeButton)
        //addSubview(likeButtonLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        editButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        editButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        customTitleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        customTitleLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        customTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        customTitleLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 5).isActive = true
        
        
        customDetailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        customDetailLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        customDetailLabel.topAnchor.constraint(equalTo: customTitleLabel.bottomAnchor, constant: 5).isActive = true
        customDetailLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
//        likeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        likeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        likeButton.leftAnchor.constraint(equalTo: (detailTextLabel?.leftAnchor)!).isActive = true
//        likeButton.topAnchor.constraint(equalTo: (detailTextLabel?.bottomAnchor)!, constant: 8).isActive = true
//
//        likeButtonLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        likeButtonLabel.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 8).isActive = true
//        likeButtonLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        likeButtonLabel.topAnchor.constraint(equalTo: (detailTextLabel?.bottomAnchor)!, constant: 8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupButtons(){
        
        let stackView = UIStackView(arrangedSubviews: [likeButton,likeButtonLabel,disLikeButton,disLikeButtonLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 0
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            //stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            //stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            //stackView.topAnchor.constraint(equalTo: customDetailLabel.bottomAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 80),
            stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 20)
            ])
        
    }
    
 
}






