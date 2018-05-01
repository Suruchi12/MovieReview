//
//  UserProfileViewController.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/7/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var tableVC: TableViewController?
    var topRatedVC: TopRatedTableViewController?
    var upcomingVC: UpcomingTableViewController?
    var favouriteVC: FavouriteViewController?
    
    var reviewVC: ReviewController?
    
    var name: String?
    var email: String?
    var profilePicUrl: String?
    
    let firstContainer: UIView = {
        let view = UIView()
        view.backgroundColor =  .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    let fullName: UITextField = {
        
        let nameField = UITextField()
        nameField.placeholder = "Full Name"
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        nameField.font = UIFont(name: "HoeflerText-BlackItalic", size: 20)
        return nameField
    }()
    let firstDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let birthdayField: UITextField = {
        
        let birthdayField = UITextField()
        //birthdayField.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7122066999, blue: 0.5894463828, alpha: 1)
        birthdayField.placeholder = "Birthday"
        birthdayField.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        birthdayField.translatesAutoresizingMaskIntoConstraints = false
        birthdayField.font = UIFont(name: "HoeflerText-BlackItalic", size: 22)
        return birthdayField
    }()
    
    let secondDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contactField: UITextField = {
        
        let contactField = UITextField()
        contactField.placeholder = "Phone Number"
        contactField.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        contactField.translatesAutoresizingMaskIntoConstraints = false
        contactField.font = UIFont(name: "HoeflerText-BlackItalic", size: 22)
        return contactField
    }()
    
    let thirdDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let universityField: UITextField = {
        let universityField = UITextField()
        //universityField.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7122066999, blue: 0.5894463828, alpha: 1)
        universityField.placeholder = "Name of University"
        universityField.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        universityField.font = UIFont(name: "HoeflerText-BlackItalic", size: 20)
        universityField.translatesAutoresizingMaskIntoConstraints = false
        return universityField
    }()
    
    lazy var profileImage: UIImageView = {
        
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "defaultProfileImage")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPicture)))
        profileImage.isUserInteractionEnabled = true
        return profileImage
    }()
    
    @objc func selectPicture(){
    
        print("User Profile Picture selected!")
        
        let picPicker = UIImagePickerController()
        picPicker.delegate = self
        
        present(picPicker, animated: true, completion: nil)
        
        picPicker.allowsEditing = true
        
    }
    
    //MARK:- Selecting photos for Profile image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let modifiedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            print(modifiedImage)
            selectedImage = modifiedImage
            
        }
            
        else if let orImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            print(orImage)
            selectedImage = orImage
        }
        
        if let selectedProfile = selectedImage{
            
            profileImage.image = selectedProfile
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Picker is cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.6117872174, blue: 0.6667950216, alpha: 1)
        signInCheck()
        view.addSubview(profileImage)
        view.addSubview(firstContainer)
        
        setupContainers()
        setUpProfileImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateUserDetails))

        
    }
    //MARK:- Update User Profile Details and save into Firebase
   @objc func updateUserDetails() {
    
    //let values = ["userName": nameAuth, "email": emailAuth, "password": passwordAuth]
    
    guard let userID = Auth.auth().currentUser?.uid else{
        return
    }
    
    let uniqueImageName = NSUUID().uuidString
    
    let storageReference = Storage.storage().reference().child("userProfilePhotos").child("\(uniqueImageName).jpg")
    
    if let userImage = self.profileImage.image, let uploadUserImage = UIImageJPEGRepresentation(userImage, 0.1){
    
   // if let uploadPicture = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){
    
    //if let uploadPicture = UIImagePNGRepresentation(profileImage.image!){
    
        storageReference.putData(uploadUserImage, metadata: nil, completion: { (storageMetaData, storageError) in
            
            if storageError != nil{
                print(storageError!)
                return
            }
            
        
            self.profilePicUrl = storageMetaData?.downloadURL()?.absoluteString
//                let values = ["fullName": self.fullName.text, "birthday": self.birthdayField.text, "contact": self.contactField.text, "university":           self.universityField.text, "profilePicUrl": profilePicUrl] as [String : AnyObject]
            self.updateUserFirebase(userID: userID)
            
            print(storageMetaData!)
        })
    }
    
  
    }
    
    func fetchUserInformation() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        // Fetch Info from Firebase
        Database.database().reference().child("allUsers").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = UsersModel(dictionary: dictionary)
                self.updateFields(user: user)
            }
            
        }, withCancel: nil)
    }
    
    
    func updateFields(user: UsersModel) {
        
        name = user.userName
        
        if let url = user.profilePicUrl {
           profileImage.loadImageUsingCacheWithURLString(urlString: url)
        }
        
        if let fullname = user.fullName {
            fullName.text = fullname
        }
        if let company = user.birthday {
            birthdayField.text = company
        }
        if let contact = user.contact {
            contactField.text = contact
        }
        if let newUniversity = user.university {
            universityField.text = newUniversity
        }
    }
    
    
    //MARK:- Updating all information into Firebase
    fileprivate func updateUserFirebase(userID: String){
        
        let values = ["userName": name,"email": email, "fullName": fullName.text, "birthday": birthdayField.text, "contact": contactField.text, "university": universityField.text, "profilePicUrl": profilePicUrl] as [String : AnyObject]
        
        let reference = Database.database().reference(fromURL: "https://assignment-4-18ffa.firebaseio.com")
        
        let usersRef = reference.child("allUsers").child(userID)
        usersRef.updateChildValues(values) { (updateError, reference) in
            
            if updateError != nil{
                print(updateError!)
                return
            }
            
            print("Saved Profile Information into Firebase")
            
            //self.dismiss(animated: true, completion: nil)
            
        }
        
//        let userInfo = UsersModel(dictionary: values)
//        self.tableVC?.navBarUserInfo(user: userInfo)
        
        //self.dismiss(animated: true, completion: nil)
        
        self.tableVC?.navigationController?.popViewController(animated: true)
        self.topRatedVC?.navigationController?.popViewController(animated: true)
        self.upcomingVC?.navigationController?.popViewController(animated: true)
        self.favouriteVC?.navigationController?.popViewController(animated: true)
        
       
    }
    
    //MARK:- Check if the user is signed in
    func signInCheck(){
        
        //user is not Signed In
        if Auth.auth().currentUser?.uid == nil{
            //perform(#selector(funcSignOut), with: nil, afterDelay: 0)
            return
        }
            
        else{
            
            if let name = name {
                
                navigationItem.title = name
//                let values = ["fullName": fullName.text, "birthday": birthdayField.text, "contact": contactField.text, "university": universityField.text, "profilePicUrl": profilePicUrl] as [String : AnyObject]
//
//                let userInfo = UsersModel(dictionary: values)
//                self.tableVC?.navBarUserInfo(user: userInfo)
            }
            navigationController?.navigationBar.isTranslucent = false
            
        }
    }
    
    
    //MARK:- Constraints for Profile Image
    func setUpProfileImage(){
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 165).isActive = true
       
        
    }
    
    
    //Heights so can use it outside of the following function
    var containerHeightAnchor: NSLayoutConstraint?
    var nameHeightAnchor: NSLayoutConstraint?
    var birthdayHeightAnchor: NSLayoutConstraint?
    var contactHeightAnchor: NSLayoutConstraint?
    var universityHeightAnchor: NSLayoutConstraint?
    
    //MARK:- Setting up constraints for User Details
    func setupContainers() {
        
        //Container Constraints
        firstContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //firstContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        firstContainer.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12).isActive = true
        firstContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        //firstContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        containerHeightAnchor = firstContainer.heightAnchor.constraint(equalToConstant: 180)
        containerHeightAnchor?.isActive = true
        
        //Adding all Subviews
        firstContainer.addSubview(fullName)
        firstContainer.addSubview(firstDivider)
        firstContainer.addSubview(birthdayField)
        firstContainer.addSubview(secondDivider)
        firstContainer.addSubview(contactField)
        firstContainer.addSubview(thirdDivider)
        firstContainer.addSubview(universityField)
        
        //Full Name
        fullName.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: 12).isActive = true
        fullName.topAnchor.constraint(equalTo: firstContainer.topAnchor).isActive = true
        fullName.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        
        nameHeightAnchor = fullName.heightAnchor.constraint(equalTo: firstContainer.heightAnchor, multiplier: 1/4)
        nameHeightAnchor?.isActive = true
        
        //Full Name Divider
        firstDivider.leftAnchor.constraint(equalTo: firstContainer.leftAnchor).isActive = true
        firstDivider.topAnchor.constraint(equalTo: fullName.bottomAnchor).isActive = true
        firstDivider.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        firstDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Birthday
        birthdayField.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: 12).isActive = true
        birthdayField.topAnchor.constraint(equalTo: fullName.bottomAnchor).isActive = true
        birthdayField.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        
        birthdayHeightAnchor = birthdayField.heightAnchor.constraint(equalTo: firstContainer.heightAnchor, multiplier: 1/4)
        birthdayHeightAnchor?.isActive = true
        
        //Birthday Divider
        secondDivider.leftAnchor.constraint(equalTo: firstContainer.leftAnchor).isActive = true
        secondDivider.topAnchor.constraint(equalTo: birthdayField.bottomAnchor).isActive = true
        secondDivider.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        secondDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Contact
        contactField.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: 12).isActive = true
        contactField.topAnchor.constraint(equalTo: birthdayField.bottomAnchor).isActive = true
        contactField.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        
        contactHeightAnchor = contactField.heightAnchor.constraint(equalTo: firstContainer.heightAnchor, multiplier: 1/4)
        contactHeightAnchor?.isActive = true
        
        //Contact Divider
        thirdDivider.leftAnchor.constraint(equalTo: firstContainer.leftAnchor).isActive = true
        thirdDivider.topAnchor.constraint(equalTo: contactField.bottomAnchor).isActive = true
        thirdDivider.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        thirdDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //University
        universityField.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: 12).isActive = true
        universityField.topAnchor.constraint(equalTo: contactField.bottomAnchor).isActive = true
        universityField.widthAnchor.constraint(equalTo: firstContainer.widthAnchor).isActive = true
        
        universityHeightAnchor = universityField.heightAnchor.constraint(equalTo: firstContainer.heightAnchor, multiplier: 1/4)
        universityHeightAnchor?.isActive = true
        
        
    }

}
