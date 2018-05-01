//
//  FavouriteViewController.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/16/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase

class FavouriteViewController: UITableViewController, FavoriteCellDelegate{
    
    var results: MovieResults?
    var favourites = [Favourites]()
    var favouritesDictionary = [String: Favourites]()
    var movieData = [MovieInfo]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(funcSignOut))
        signInCheck()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 195
        tableView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        setNavBar()

        tableView.register(MovieFavouriteCell.self, forCellReuseIdentifier: cellId)
        
        fetchFavourites()
        
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        setNavBar()
        fetchFavourites()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tableView.reloadData()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
        fetchFavourites()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tableView.reloadData()
    }
    
    func signInCheck(){
        
        //user is not Signed In
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(funcSignOut), with: nil, afterDelay: 0)
            //DispatchQueue.main.async { self.tableView.reloadData() }
        }
            
        else{
            
            setNavBar()
            //DispatchQueue.main.async { self.tableView.reloadData() }
        }
        
         //DispatchQueue.main.async { self.tableView.reloadData() }
        
    }
    
    func setNavBar(){

        favourites.removeAll()
        favouritesDictionary.removeAll()
        self.doReloadTable()
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        print(" userID from favorites: \(userID)")
        
        Database.database().reference().child("allUsers").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in

            print("Favourites- Inside when user is signed in")
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{

                let userInfo = UsersModel(dictionary: dictionary)
    
                self.navBarUserInfo(user: userInfo)
                
                //print("Current Title is" + self.navigationItem.title!)
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
            
        }, withCancel: nil)
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    
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
    
    @objc private func selectNavigationBar(){
        
        print("Favourites -Nav Bar Tapped - display user info")
        let userProfileVC = UserProfileViewController()
        userProfileVC.favouriteVC = self
        userProfileVC.fetchUserInformation()
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    @objc func funcSignOut(){
        
        do{
            try Auth.auth().signOut()
        } catch let signOutError{
            print(signOutError)
        }
        let loginVC = LoginViewController()
        loginVC.favouriteVC = self
        present(loginVC, animated: true, completion: nil)
        
    }
    
    
    func fetchFavourites(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference().child("favorites")
        reference.observe(.childAdded, with: { (snapshot) in
        //Database.database().reference().child("favorites").observe(.childAdded, with: { (snapshot) in
            print("in fetch favourites")
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let favFromFB = Favourites(dictionary: dictionary)

//                var newMovie = MovieInfo()
//
//                newMovie.id = Int(favFromFB.movieID!)
//                newMovie.title = favFromFB.movieName!
//                newMovie.posterPath = favFromFB.posterPath!
//                newMovie.backdrop = favFromFB.backdrop!
//                newMovie.originalTitle = favFromFB.originalTitle!
//                newMovie.overview = favFromFB.overview!
//                newMovie.rating = Double(favFromFB.rating!)
//                newMovie.releaseDate = favFromFB.releaseDate!
//
//               // self.movieData.append(newMovie)
                
                //self.favourites.append(favFromFB)
                
                if uid == favFromFB.userID{
                
                    if let ID = favFromFB.movieID{
                        
                        self.favouritesDictionary[ID] = favFromFB
                        self.favourites = Array(self.favouritesDictionary.values)
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                    //DispatchQueue.main.async { self.tableView.reloadData() }
                }
            
            }
            
        }, withCancel: nil)
        
         //DispatchQueue.main.async { self.tableView.reloadData() }
        
        reference.observe(.childRemoved, with: { (snapshot) in
        //reference.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
          
            print("snapshot.key : \(snapshot.key)")
            let movieIDfromFB = snapshot.key

            self.favouritesDictionary.removeValue(forKey: movieIDfromFB)
            self.doReloadTable()

            DispatchQueue.main.async { self.tableView.reloadData() }

        }, withCancel: nil)
        
        DispatchQueue.main.async { self.tableView.reloadData() }
        
    }
    
    func doReloadTable() {
          self.favourites = Array(self.favouritesDictionary.values)
        DispatchQueue.main.async{self.tableView.reloadData()}
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        
        return favourites.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellid")
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieFavouriteCell
        cell.cellFavoriteDelegate = self

        let fav = favourites[indexPath.row]
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        cell.textLabel?.font = UIFont(name: "HoeflerText-BlackItalic", size: 28)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0;
        
        cell.textLabel?.text = fav.movieName
        
        let posterpath = fav.posterPath
        let link = "https://image.tmdb.org/t/p/w185/\(posterpath!)"
   
        cell.imageView?.downloadImageUsingCache(link)
        
        var initialCount: Int = 0
        cell.detailTextLabel?.text = "Reviews: \(initialCount)"
        let ref = Database.database().reference().child("movie-reviews")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(fav.movieID!){
                let newRef = Database.database().reference().child("movie-reviews").child(fav.movieID!)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //print("snapshot.childrenCount : \(snapshot.childrenCount)")
                    initialCount = Int(snapshot.childrenCount)
                    cell.detailTextLabel?.text = "Reviews: \(initialCount)"
                }, withCancel: nil)
                
            }
            
        }, withCancel: nil)
        
        cell.detailTextLabel?.backgroundColor = .clear
        cell.detailTextLabel?.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        if indexPath.row % 2 == 0 {
            
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#EE6868")
            cell.backgroundColor = hexStringToUIColor(hex: "#EE6868")
            cell.textLabel?.textColor = #colorLiteral(red: 0.9567734772, green: 0.9567734772, blue: 0.9567734772, alpha: 1)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        else{
            
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#FF9B9B" )
            cell.backgroundColor = hexStringToUIColor(hex: "#FF9B9B" )
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        
        return cell
    }
    
    //MARK:- Go to the detail view controller
    func showMovie(movie : MovieInfo){
 
        let reviewVC1 = ReviewController()
        reviewVC1.movie1 = movie
        //reviewVC1.delegate = self
        navigationController?.pushViewController(reviewVC1, animated: true)
        
    }
    
    //MARK:- Select a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("did select row")
        //print(self.movieData[indexPath.row] as Any)
        
        let favFromDict = favourites[indexPath.row]
        var newMovie = MovieInfo()
        
        newMovie.id = Int(favFromDict.movieID!)
        newMovie.title = favFromDict.movieName!
        newMovie.posterPath = favFromDict.posterPath!
        newMovie.backdrop = favFromDict.backdrop!
        newMovie.originalTitle = favFromDict.originalTitle!
        newMovie.overview = favFromDict.overview!
        newMovie.rating = Double(favFromDict.rating!)
        newMovie.releaseDate = favFromDict.releaseDate!
        
        
        //let movie = self.movieData[indexPath.row]
        let movie = newMovie
        //print("indexpath.row : \(indexPath.row)")
        self.showMovie(movie:movie)
        //print("\(movie.title!) selected")
    }
    
    //MARK:- Delete a cell from Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            //guard let indexPath = tableView.indexPath(for: cell) else { return }
            
           // let movieID = (results?.movies[indexPath.row].id)!
             let movieID = (favourites[indexPath.row].movieID)!
            let StringMovieID = String(movieID)
             print("Deleting movie at \(indexPath.row)")
            //print("favoriteMovie \(StringMovieID)")
            
            Database.database().reference().child("favorites").child(StringMovieID).removeValue() { (error1, ref) in
                if error1 != nil{
                    print("Failed to delete movie", error1!)
                    return
                }
                
                
            }
            let movieIDfromFB = (favourites[indexPath.row].movieID)!
            
            self.favouritesDictionary.removeValue(forKey: movieIDfromFB)
            self.doReloadTable()
             print("Deleting movie at \(movieIDfromFB)")
            //favourites.remove(at: indexPath.row)
           
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
        
        
    }
    
    func didFavorite(for cell: MovieFavouriteCell) {
        
        print("didFavorite")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let favoriteMovie = favourites[(indexPath.item)]
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        guard let movieID = favoriteMovie.movieID else { return }
        guard let title = favoriteMovie.movieName else {return}
        guard let posterPath = favoriteMovie.posterPath else {return}
        guard let backdrop = favoriteMovie.backdrop else {return}
        guard let releaseDate = favoriteMovie.releaseDate else {return}
        guard let rating = favoriteMovie.rating else {return}
        guard let overview = favoriteMovie.overview else {return}
        guard let originalTitle = favoriteMovie.originalTitle else {return}
        
        let movieIdString = "\(movieID)"
        let ratingString = "\(rating)"
        
        let favoriteMovieRef = Database.database().reference().child("favorites").child(movieIdString)
        let postId = favoriteMovieRef.key
        print("Send to FB:- Favorite Movie ID: \(postId)")
        
        
        let movieValues = ["movieID": movieIdString,"movieName": title, "userId": userID, "moviePosterPath": posterPath,"backdrop": backdrop,"releaseDate": releaseDate,"rating": ratingString, "overview": overview, "originalTitle": originalTitle] as [String : AnyObject]
        
        
        favoriteMovieRef.updateChildValues(movieValues) { (error, reviewRef) in
            
            if error != nil{
                print(error!)
                return
            }
            
        }
        DispatchQueue.main.async { self.tableView.reloadRows(at: [indexPath], with: .none) }
        
    }
    
    func didUnFavorite(for cell: MovieFavouriteCell) {
        
        print("did un favorite")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let movieID = (favourites[indexPath.row].movieID)!
        let StringMovieID = String(movieID)
        print("Deleting movie at \(indexPath.row)")
        //print("favoriteMovie \(StringMovieID)")
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        //Delete only if the signed in user has favourited it 
        if userID == favourites[indexPath.row].userID {
        
            Database.database().reference().child("favorites").child(StringMovieID).removeValue() { (error1, ref) in
            if error1 != nil{
                
                print("Failed to delete movie", error1!)
                return
            
                }
            }
            
            let movieIDfromFB = (favourites[indexPath.row].movieID)!
            self.favouritesDictionary.removeValue(forKey: movieIDfromFB)
            self.doReloadTable()
        }
        
        //self.doReloadTable()
        
    }
    

}
