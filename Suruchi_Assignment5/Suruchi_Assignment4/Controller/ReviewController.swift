//
//  ReviewController.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/6/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase





//class ReviewController: UITableViewController {
class ReviewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, ReviewCellDelegate {
   
    
    
    var link: String = ""
    var tableVC: TableViewController?
    var name: String?
    var email: String?
    var profilePicUrl: String?
    var movieReviewCount: Int = 0
    
    var movie1 : MovieInfo?{
        
        didSet{
            
            setNavBar()
            let id = movie1?.id
            print("RVC didSet Movie ID is : \(id!)")
            link = "https://api.themoviedb.org/3/movie/\(id!)?api_key=9833efb4636d8626663b18c31ccdc1a9"
        }
    }
    
    //Set the Table View
    let tableView: UITableView = {
        
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        //tv.delegate = self
        //tv.dataSource = self
        return tv
    }()
    
    
    let cellId = "cellId"
    let infoId = "infoId"
    var usersModel = [UsersModel]()
    var likeButtonCount = 0
    //var reviewCount: Int = 0
    var userName: String?
    var profileUrl: String?
    var allReviews = [Reviews]()
    var specificReviews = [Reviews]()
    
    
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
       
        //let tabBarControllerItems = self.tabBarController?.tabBar.items
        
//        if let tabArray = tabBarControllerItems {
//            let tabBarItem1 = tabArray[0]
//            let tabBarItem2 = tabArray[1]
//            let tabBarItem3 = tabArray[2]
//            let tabBarItem4 = tabArray[3]
//
//            tabBarItem1.isEnabled = false
//            tabBarItem2.isEnabled = false
//            tabBarItem3.isEnabled = false
//            tabBarItem4.isEnabled = false
//        }
        
        tableView.delegate = self
        tableView.dataSource = self
//        view.addSubview(tableView)

        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(funcCancel))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(funcCancel))
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = "Detail View"
        tableView.register(ReviewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(InfoCell.self, forCellReuseIdentifier: infoId)
        //view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        fetchFirebaseUsers()
        
        self.tableVC?.setNavBar()
        
        fetchReviews()
        //fetchUserReviews()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.reloadData()
        

    }
    
    
    func fetchUserReviews(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("user-reviews").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let reviewIdFireB = snapshot.key
            let reviewRef = Database.database().reference().child("reviews").child(reviewIdFireB)
            
            reviewRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let reviewDictionary = snapshot.value as? [String: AnyObject] {
                    
                    let reviewsFromFir = Reviews(dictionary: reviewDictionary)
                    reviewsFromFir.reviewId = String(snapshot.key)
                    print(" reviewsFromFir.reviewId : \(String(describing: reviewsFromFir.reviewId))")
                    self.allReviews.append(reviewsFromFir)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //MARK:- Fetch Reviwes from Firebase
    func fetchReviews(){
        
        let ref = Database.database().reference().child("reviews")
        ref.observe(.childAdded, with: { (snapshot) in
//
            print("fetchREVIEWS : \(snapshot)")
            
//            if let reviewDictionary = snapshot.value as? [String: AnyObject]{
//
//                let userReviews = Reviews()
//                userReviews.setValuesForKeys(reviewDictionary)
//                self.allReviews.append(userReviews)
//                print(" userReviews : \(reviewDictionary)")
//                print(userReviews.review!)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }

           // Database.database().reference().child("allUsers").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let reviewDictionary = snapshot.value as? [String: AnyObject] {
                    
                    let reviewsFromFir = Reviews(dictionary: reviewDictionary)
                    let fetchMovieId = Int(reviewsFromFir.movieId!)
                    
                    if self.movie1?.id == fetchMovieId {
                        
                        reviewsFromFir.reviewId = String(snapshot.key)
                        print("fetchMovieID : \(String(describing: fetchMovieId))")
                        self.allReviews.append(reviewsFromFir)
                    
                    }
                     DispatchQueue.main.async { self.tableView.reloadData() }
                    
                }
            
        }, withCancel: nil)
    }
    
    //MARK:- Set the Text Field
    lazy var reviewTextField: UITextField = {
        
        let textField = UITextField()
        textField.backgroundColor = hexStringToUIColor(hex: "#ffe9ec")
        textField.placeholder = "Type your reviews..."
        textField.font = UIFont(name: "HoeflerText-BlackItalic", size: 18)
        textField.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        textField.textAlignment = .justified
        textField.sizeToFit()
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    func setConstraints(){

        let bottomContainer: UIView = {
            
            let bottomContainer = UIView()
            bottomContainer.backgroundColor = .white
            bottomContainer.translatesAutoresizingMaskIntoConstraints = false

            return bottomContainer
        }()
        
        
        
        let sendButon: UIButton = {
            
            let sendButton = UIButton(type: .system)
            sendButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            sendButton.setTitle("Send", for: .normal)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setTitleColor(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), for: .normal)
            sendButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
            sendButton.layer.cornerRadius = 8
            sendButton.addTarget(self, action: #selector(sendReviews), for: .touchUpInside)

            sendButton.translatesAutoresizingMaskIntoConstraints = false
            return sendButton
        }()
        
        let separatorLine = UIView ()
        separatorLine.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        
        //bottomContainer.backgroundColor = .red
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(reviewTextField)
        bottomContainer.addSubview(sendButon)
        bottomContainer.addSubview(separatorLine)
        view.addSubview(tableView)
        
        
        
        bottomContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
      
        sendButon.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor).isActive = true
        sendButon.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor).isActive = true
        sendButon.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor).isActive = true
        sendButon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButon.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        
        reviewTextField.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor).isActive = true
        reviewTextField.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor).isActive = true
        //reviewTextField.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor).isActive = true
        reviewTextField.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor).isActive = true
        reviewTextField.rightAnchor.constraint(equalTo: sendButon.leftAnchor).isActive = true
        reviewTextField.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        
        separatorLine.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    //MARK:- Send Reviews to Firebase
    @objc func sendReviews(){
        
        print(reviewTextField.text!)
        
        let reviewRef = Database.database().reference().child("reviews")
        let childReference = reviewRef.childByAutoId()
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        
        let reviewUserID = userID
        let movieID = String(describing: (movie1?.id)!)
        let LikebuttonCount = 0
        let disLikeButtonCount = 0
        
        let reviewValues = ["review": reviewTextField.text!, "reviewUserId": reviewUserID, "movieId": movieID, "likeCount": LikebuttonCount, "disLikeCount": disLikeButtonCount] as [String : AnyObject]

        //let reviewValues = ["review": reviewTextField.text!, "reviewUserId": reviewUserID, "movieId": movieID, "likeCount": buttonCount] as [String : AnyObject]
        //let reviewValues = ["review": reviewTextField.text!, "reviewUserId": reviewUserID, "movieId": movieID] as [String : AnyObject]
        //childReference.updateChildValues(reviewValues)
        
        childReference.updateChildValues(reviewValues) { (error, reviewRef) in
            
            if error != nil{
                print(error!)
                return
            }
            
            let userReviewsRef = Database.database().reference().child("user-reviews").child(reviewUserID)
            let reviewId = childReference.key
            userReviewsRef.updateChildValues([reviewId: 1])
            
           
            guard let movieIdFB = (self.movie1?.id) else {return}
            let movieID = String(movieIdFB)
            let moviesReviewsRef = Database.database().reference().child("movie-reviews").child(movieID)
            let reviewID = childReference.key
            moviesReviewsRef.updateChildValues([reviewID: 1])
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendReviews()
        return true
    }
    
    
    //MARK:- View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
//        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
      setNavBar()
        /*
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem2 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            let tabBarItem4 = tabArray[3]
            
            tabBarItem1.isEnabled = false
            tabBarItem2.isEnabled = false
            tabBarItem3.isEnabled = false
            tabBarItem4.isEnabled = false
        }*/
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setNavBar()
        self.tabBarController?.tabBar.layer.zPosition = -1
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
   
    }
    
    //MARK:- set the navigation bar
    func setNavBar(){
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        print(userID)
        
        Database.database().reference().child("allUsers").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("Inside when user is signed in")
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let userInfo = UsersModel(dictionary: dictionary)
                self.navBarUserInfo(user: userInfo)
                //DispatchQueue.main.async { self.tableView.reloadData() }
            }
            
        }, withCancel: nil)
    }
    
    
    //MARK:- User picture and name in the Nav Bar
    
    func navBarUserInfo(user: UsersModel){
        
        let titleUser = UIView()
        self.navigationItem.titleView = titleUser
        titleUser.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleUser.backgroundColor = .blue
        
        
        //SELECTING NAVIGATION TITLE
        let selectTitle = UITapGestureRecognizer(target: self, action: #selector(selectNavigationBar))
        titleUser.isUserInteractionEnabled = true
        selectTitle.delegate = self as? UIGestureRecognizerDelegate
        titleUser.addGestureRecognizer(selectTitle)
        
        
        
        //SETTING CONSTRAINTS FOR NAVIGATION TITLE
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleUser.addSubview(containerView)
        
        let profileImage = UIImageView()
        let userNameLabel = UILabel()
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        if let profileImageUrl = user.profilePicUrl{
            
             profileImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImage)
        containerView.addSubview(userNameLabel)
        
        containerView.centerYAnchor.constraint(equalTo: titleUser.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleUser.centerXAnchor).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        userNameLabel.text = user.userName
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.lineBreakMode = .byWordWrapping
        userNameLabel.numberOfLines = 0
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        
        
    }
    
    //Tapping on Navigation Bar
    @objc private func selectNavigationBar(){
        
        print("Nav Bar Tapped - display user info")
        let userProfileVC = UserProfileViewController()
        userProfileVC.reviewVC = self
        userProfileVC.fetchUserInformation()
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    

    //MARK:- Fetch Firebase Users
    func fetchFirebaseUsers(){
    
        //Database.database().reference().child("allUsers").observeSingleEvent(of: .childAdded, with: { (snapshot) in
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("allUsers").queryOrdered(byChild: "userName")
        query.observe(.value) { (snapshot) in
            print("ReviewVC : " + String(describing: snapshot))
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    //if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.userName = value["userName"] as? String ?? "Name not found"
                    self.profileUrl = value["profilePicUrl"] as? String
                    
                    //let user = User()
                    let name = value["userName"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    
                    let fullName = value["fullName"] as? String ?? "Email not found"
                    let birthday = value["birthday"] as? String ?? "Birthday not found"
                    let contact = value["contact"] as? String ?? "Contact not found"
                    let university = value["university"] as? String ?? "University not found"
                    let modelPic = value["profilePicUrl"] as? String
                    
                    let userModelObj = UsersModel(dictionary: value as! [String : AnyObject])
                    userModelObj.userName = name
                    userModelObj.email = email
                    
                    userModelObj.fullName = fullName
                    userModelObj.birthday = birthday
                    userModelObj.contact = contact
                    userModelObj.university = university
                    userModelObj.profilePicUrl = modelPic
                    
                    self.usersModel.append(userModelObj)
                    DispatchQueue.main.async { self.tableView.reloadData() }
        
                }
            }
        }
    }
    
    //MARK:- Go to Master View
    @objc func funcCancel(){

  
        self.navigationController?.popViewController(animated: true)
    }
    
    //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0{
            return 1
        }
        
        else{
            
            return allReviews.count
        }
    }
    
    //MARK:- Sections
   // override func numberOfSections(in tableView: UITableView) -> Int {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK:- Header of each section
    //override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let heading = UILabel()
        heading.font = UIFont(name: "GillSans-Bold", size: 15)
        heading.textColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        heading.textAlignment = .justified
        
        if section == 0 {
        
            heading.text = "Movie Information"
        }
        else{
            
            heading.text = "Movie Reviews"
        }
        heading.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return heading
    }
    
    //MARK:- edit rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0{
            
            return false
        }
        else {
        
            return true
        }
    }
    
    //MARK:- Delete reviews from the table and Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let review = self.allReviews[indexPath.row]
            //So, only logged in User can delete their Review!
            if uid == review.reviewUserId {
                
                //let movieID = "\(String(describing: movie1?.id))"
                //let movieID = String(temp)
                Database.database().reference().child("movie-reviews").child(review.movieId!).child(review.reviewId!).removeValue() { (error1, ref) in
                    if error1 != nil{
                        print("Failed to delete movie-review", error1!)
                        return
                    }
                
                    Database.database().reference().child("user-reviews").child(review.reviewUserId!).child(review.reviewId!).removeValue() { (error1, ref) in
                        if error1 != nil{
                            print("Failed to delete user-review", error1!)
                            return
                        }
                //remove from Firebase
                Database.database().reference().child("reviews").child(review.reviewId!).removeValue { (error, ref) in
                    if error != nil{
                        print("Failed to delete reviews", error!)
                        return
                    }
                    
                   
                    //remove from review model
                    self.allReviews.remove(at: indexPath.row)
                    //self.tableView.delete(indexPath.row)
                    
                    //remove from table view
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadData()
                }
            }
                }
            }
            else{
                let alert = UIAlertController(title: "Can't Perform Delete", message: "Can't Delete a review you haven't written", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            tableView.endUpdates()
        }
        
    }
    
    // MARK:- Set up cells in each section
    //override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: infoId, for: indexPath) as! InfoCell
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
            cell.header.movie = movie1
            cell.poster.movie = movie1
            cell.overview.movie = movie1
            
            
            return cell
        }
        
        else  {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReviewCell
            cell.cellDelegate = self
            cell.backgroundColor =  hexStringToUIColor(hex: "#ffdae0")
            cell.customDetailLabel.sizeToFit()
            let cellReview = allReviews[indexPath.row]
            print(cellReview)
            let fetchMovieId = Int(cellReview.movieId!)
            //check if the review is for this movie
            if movie1?.id == fetchMovieId{
                
//                let ref = Database.database().reference().child("user-reviews").child(cellReview.reviewUserId!)
//                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    //let userId = snapshot.key
                //Fetching users
                let userId = cellReview.reviewUserId!
                    let userRef = Database.database().reference().child("allUsers").child(userId)
                    
                    userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let userDictionary = snapshot.value as? [String: AnyObject] {
                            
                            let userFromFB = UsersModel(dictionary: userDictionary)
                            
                            //cell.textLabel?.text = userFromFB.userName
                            cell.customTitleLabel.text = userFromFB.userName
                            
                            
                            let profilePicURL1 = userDictionary["profilePicUrl"] as? String
                            if profilePicURL1 == nil{
                                cell.profileImageView.image =  UIImage(named: "defaultProfileImage")
                                cell.profileImageView.contentMode = .scaleAspectFill
                            }
                            else{
                                //print(" user.profilePicUrl" + .profilePicUrl!)
                                if let profilePicURL = userDictionary["profilePicUrl"] as? String {//user.profilePicUrl{
                                    print("REVIEW CONTROLLER :  " + profilePicURL)
                                    //cell.profileImageView.loadImageUsingCacheWithURLString(urlString: profilePicURL)
                                }
                            }
                            
                            //DispatchQueue.main.async { self.tableView.reloadData() }
                            
                        }
                        
                    }, withCancel: nil)
                //}, withCancel: nil)
                
                //Fetching Reviews of that user
                let reviewRef = Database.database().reference().child("reviews").child(cellReview.reviewId!)
                print("reviewRef: \(reviewRef)")
                
                reviewRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let reviewDictionary = snapshot.value as? [String: AnyObject]{
                        
                        let reviewFromFB = Reviews(dictionary: reviewDictionary)
                        //cell.detailTextLabel?.text = reviewFromFB.review
                        cell.customDetailLabel.text = reviewFromFB.review
                        
                        guard let likeCountFB = reviewFromFB.likeCount else {return}
                        let likeCountFBInt = Int(likeCountFB)
                        cell.likeButtonLabel.text = "Likes: \(likeCountFBInt)"
                        
                        guard let disLikeCountFB = reviewFromFB.disLikeCount else {return}
                        let disLikeCountFBInt = Int(disLikeCountFB)
                        cell.disLikeButtonLabel.text = "DisLikes: \(disLikeCountFBInt)"
                    }
                }, withCancel: nil)
                
            }
            
            return cell
        }
    }

    
    //MARK:- Height of the rows in both section
    //override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            
            return 350
        }
        else{
        
            return 200
        }
    }
    
    //MARK:- Update Like Count
    func didLike(for cell: ReviewCell) {
        
        print("didLike")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post1 = self.allReviews[(indexPath.item)]
        
        guard let postId = post1.reviewId else { return }
        guard let firebaseCount = post1.likeCount else {return}
        print("post1.likeCOunt =  \(String(describing: firebaseCount))")
        let newCount = firebaseCount + 1
        Database.database().reference().child("reviews").child(postId).child("likeCount").setValue(newCount)
        
        self.allReviews[indexPath.item] = post1
        //DispatchQueue.main.async { self.tableView.reloadData() }
        DispatchQueue.main.async { self.tableView.reloadRows(at: [indexPath], with: .none) }
        
    }
    
    //MARK:- Update DisLike Count
    func didDisLike(for cell: ReviewCell) {
        
        print("didDisLike")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post1 = self.allReviews[(indexPath.item)]
        
        guard let postId = post1.reviewId else { return }
        guard let firebaseDisLikeCount = post1.disLikeCount else {return}
        print("post1.disLikeCount =  \(String(describing: firebaseDisLikeCount))")
        let newCount = firebaseDisLikeCount + 1
         print("newCount =  \(String(describing: newCount))")
        Database.database().reference().child("reviews").child(postId).child("disLikeCount").setValue(newCount)
        
        self.allReviews[indexPath.item] = post1
        //DispatchQueue.main.async { self.tableView.reloadData() }
        DispatchQueue.main.async { self.tableView.reloadRows(at: [indexPath], with: .none) }
        
    }
    
    //MARK:- Update user review
    func didEdit(for cell: ReviewCell) {
        
        print("didEdit")
        
        tableView.beginUpdates()
        
        //Confrim current user
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let review = self.allReviews[indexPath.item]
        guard let reviewId = review.reviewId else { return }
        //So, only logged in User can delete their Review!
        if uid == review.reviewUserId {
 
            
            let alertController = UIAlertController(title: "Edit Review", message: "Please input your new Review:", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                
                if let field = alertController.textFields?[0] {
                     print("Text field: \(String(describing: field.text!))")
                     let newReview = field.text!
                    
                    //Update the review in Firebase
                     Database.database().reference().child("reviews").child(reviewId).child("review").setValue(newReview)
                    //Update the review in Review Model
                     self.allReviews[indexPath.item] = review
                     DispatchQueue.main.async { self.tableView.reloadRows(at: [indexPath], with: .none) }
                }
                else {
                    // user did not input values
                    return
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Write your Review here..."
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Can't Perform Edit", message: "Can't Edit a review you haven't written", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.endUpdates()
    
    }
    
}


