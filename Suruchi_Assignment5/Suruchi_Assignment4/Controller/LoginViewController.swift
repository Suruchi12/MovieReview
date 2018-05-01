//
//  LoginViewController.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/5/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var tableVC: TableViewController?
    var topRatedVC: TopRatedTableViewController?
    var upcomingVC: UpcomingTableViewController?
    var favouriteVC: FavouriteViewController?
    
    //"https://assignment4-809ac.firebaseio.com/"
    
    let containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor =  .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginSignupSegment: UISegmentedControl = {
        
        let seg = UISegmentedControl(items: ["Sign In","Sign Up"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        seg.selectedSegmentIndex = 1
        seg.addTarget(self, action: #selector(toggleFunc), for: .valueChanged)
        return seg
    }()
    
    @objc func toggleFunc(){
        
        let titleToggle = loginSignupSegment.titleForSegment(at: loginSignupSegment.selectedSegmentIndex)
        registerButton.setTitle(titleToggle, for: .normal)
        
         //height of container view in Sign In
        containerHeightAnchor?.constant = loginSignupSegment.selectedSegmentIndex == 0 ? 160 :210
        
        //Remove Name from Sign In
        nameHeightAnchor?.isActive = false
        nameHeightAnchor = nameText.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: loginSignupSegment.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameHeightAnchor?.isActive = true
        
        //Adjust height of Email in Sign In
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailText.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: loginSignupSegment.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailHeightAnchor?.isActive = true
        
        //Adjust height of Password in Sign In
        passwordHeightAnchor?.isActive = false
        passwordHeightAnchor = passwordText.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: loginSignupSegment.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHeightAnchor?.isActive = true
    }
    
    
    lazy var registerButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), for: .normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(signInSignOut), for: .touchUpInside)
        return button
        
    }()
    
    @objc func signInSignOut(){
        
        if loginSignupSegment.selectedSegmentIndex == 0{
            signIn()
        }
        else{
            signUp()
        }
        
    }
    
    @objc func signIn(){
        
        guard let emailAuth = emailText.text, let passwordAuth = passwordText.text else{
            print("Email and password haven't been entered")
            return
        }
        
        Auth.auth().signIn(withEmail: emailAuth,password: passwordAuth) { (user, signInError) in
            
            if signInError != nil {
                print(signInError!)
                return
            }
            
            self.tableVC?.setNavBar()
            self.topRatedVC?.setNavBar()
            //self.upcomingVC?
            self.dismiss(animated: true, completion: nil)
            //self.tableVC?.navigationController?.popViewController(animated: true)
            
           
        }
    }
    
    @objc func signUp(){
        guard let emailAuth = emailText.text, let passwordAuth = passwordText.text, let nameAuth = nameText.text else{
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: emailAuth, password: passwordAuth, completion: { (user, error) in
            
            if error != nil{
                print(error!)
                return
            }
            //print(nameAuth)
//            guard let userID = Auth.auth().currentUser?.uid != nil else{
//                return
//            }
            
            guard let userID = user?.uid else {
                return
            }
            
            let userProfileVC = UserProfileViewController()
            userProfileVC.tableVC = self.tableVC
            userProfileVC.topRatedVC = self.topRatedVC
            
            userProfileVC.name = nameAuth
            userProfileVC.email = emailAuth

            self.tableVC?.navigationController?.pushViewController(userProfileVC, animated: true)
            self.topRatedVC?.navigationController?.pushViewController(userProfileVC, animated: true)
            //self.present(userProfileVC, animated: true, completion: nil)
           
            let values = ["userName": nameAuth, "email": emailAuth, "password": passwordAuth]
            
            //let reference = Database.database().reference(fromURL: "https://assignment-4-18ffa.firebaseio.com")
            let reference = Database.database().reference()
            let usersRef = reference.child("allUsers").child(userID)
            usersRef.updateChildValues(values) { (updateError, reference) in
                
                if updateError != nil{
                    print(updateError!)
                    return
                }
                
                print("Saved Registration into Firebase")
                
                self.tableVC?.setNavBar()
                self.topRatedVC?.setNavBar()
                //self.tableVC?.navigationItem.title = values["userName"]
 
//                let dictionaryValues = ["fullName": fullName.text, "birthday": birthdayField.text, "contact": contactField.text, "university": universityField.text, "profilePicUrl": profilePicUrl] as [String : AnyObject]
//
//                let userInfo = UsersModel(dictionary: dictionaryValues as [String : AnyObject])
//                self.tableVC?.navBarUserInfo(user: userInfo)
                self.dismiss(animated: true, completion: nil)
                
            }
            //self.dismiss(animated: true, completion: nil)
             //self.tableVC?.navigationController?.popViewController(animated: true)
        })
        
     
        
        //print("Sign Up!")
    }
    
    let nameText: UITextField = {
        
        let nameField = UITextField()
        nameField.placeholder = "User Name"
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()
    let firstDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailText: UITextField = {
        
        let emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.translatesAutoresizingMaskIntoConstraints = false
        return emailField
    }()
    
    let secondDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let passwordText: UITextField = {
        
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

            view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.6117872174, blue: 0.6667950216, alpha: 1)
            view.addSubview(containerView)
            setupConstraints()
            setupButtons()
        
    }
    
    var containerHeightAnchor: NSLayoutConstraint?
    var nameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    func setupConstraints(){
        
        //var viewHeightAnchor: NSLayoutConstraint?
        //var nameTextHeight: NSLayoutConstraint?
        //var emailHeightAnchor: NSLayoutConstraint?
        //var passwordTextHeight: NSLayoutConstraint?
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        
        containerHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 210)
        
        containerHeightAnchor?.isActive = true
        
        containerView.addSubview(nameText)
        containerView.addSubview(firstDivider)
        containerView.addSubview(emailText)
        containerView.addSubview(secondDivider)
        containerView.addSubview(passwordText)
        
        nameText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        nameText.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameText.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        nameHeightAnchor = nameText.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        nameHeightAnchor?.isActive = true
        
        firstDivider.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        firstDivider.topAnchor.constraint(equalTo: nameText.bottomAnchor).isActive = true
        firstDivider.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        firstDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Email
        emailText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        emailText.topAnchor.constraint(equalTo: nameText.bottomAnchor).isActive = true
        emailText.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        emailHeightAnchor = emailText.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        
        
        secondDivider.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        secondDivider.topAnchor.constraint(equalTo: emailText.bottomAnchor).isActive = true
        secondDivider.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        secondDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Password
        passwordText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        passwordText.topAnchor.constraint(equalTo: emailText.bottomAnchor).isActive = true
        passwordText.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        passwordHeightAnchor = passwordText.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        

    }
     fileprivate func setupButtons(){
        
        let stackView = UIStackView(arrangedSubviews: [loginSignupSegment,registerButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            //stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 110)
            ])
        
    }
 
    
    override var preferredStatusBarStyle: UIStatusBarStyle{

        return .lightContent
    }
    

}
