//
//  TopRatedViewController.swift
//  Suruchi_Assignment3
//
//  Created by Suruchi Singh on 3/19/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase

class TopRatedTableViewController: UITableViewController, FavoriteCellDelegate{
    
    
    var results: MovieResults?
    let reviewVC = ReviewController()
    
    var usersModel = [UsersModel]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 195
        tableView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        
        //navigationItem.title =  "Top Rated Movies"
        //navigationController?.navigationBar.prefersLargeTitles = true
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(funcSignOut))
        signInCheck()
        
        //reviewVC.delegate = self 
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 195
        tableView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        setNavBar()
        
        //navigationItem.title =  "Popular Movies"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        tableView.register(MovieFavouriteCell.self, forCellReuseIdentifier: cellId)

        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0

        downloadJSON {
            print("Successfull")
            self.tableView.reloadData()
        }
        
         self.tableView.reloadData()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        setNavBar()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tableView.reloadData()
    }
    
    //MARK:- JSON Parsing
    func downloadJSON(completed: @escaping () -> ()){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=9833efb4636d8626663b18c31ccdc1a9")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil{
                guard let jsondata = data else {return}
                
                do{
                    self.results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch{
                    
                    print("JSON Error")
                }
            }
            }.resume()
        
    }
    
    

    func signInCheck(){
        
        //user is not Signed In
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(funcSignOut), with: nil, afterDelay: 0)
        }
            
        else{
            
            setNavBar()
            //DispatchQueue.main.async { self.tableView.reloadData() }
            
        }
    }
    
    //MARK:- Set Navigation bar with user name and user profile
    func setNavBar(){
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        print(userID)
        
        Database.database().reference().child("allUsers").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("Inside when user is signed in")
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //self.navigationItem.title = dictionary["userName"] as? String
                //user picture and name in the navBar
                
                let userInfo = UsersModel(dictionary: dictionary)
                
                print(userInfo)
                print(dictionary)
                //userInfo.setValuesForKeys(dictionary)
                self.navBarUserInfo(user: userInfo)
                
                //print("Current Title is" + self.navigationItem.title!)
                DispatchQueue.main.async { self.tableView.reloadData() }
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
    
    //Functionality when selecting navigation bar
    @objc private func selectNavigationBar(){
        
        print("Nav Bar Tapped - display user info")
        let userProfileVC = UserProfileViewController()
        userProfileVC.topRatedVC = self
        userProfileVC.fetchUserInformation()
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    //Functionality when signing out
    @objc func funcSignOut(){
        
        do{
            try Auth.auth().signOut()
        } catch let signOutError{
            print(signOutError)
        }
        let loginVC = LoginViewController()
        loginVC.topRatedVC = self
        present(loginVC, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK:- Get the count of rows in the Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let number = results?.movies.count{
            return number
        }
        else {return 0}
    }
    
    //MARK:- Height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189
    }
    
    //MARK:- Customizing a Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let posterpath = results?.movies[indexPath.row].posterPath
        let movieID = (results?.movies[indexPath.row].id)!
        let StringMovieID = String(movieID)
        let link = "https://image.tmdb.org/t/p/w185/\(posterpath!)"
        let name = results?.movies[indexPath.row].title
        
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellid")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieFavouriteCell
        cell.cellFavoriteDelegate = self

        
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        cell.imageView?.downloadImageUsingCache(link)
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        cell.textLabel?.font = UIFont(name: "HoeflerText-BlackItalic", size: 28)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.text = name
        
        
        var initialCount: Int = 0
        cell.detailTextLabel?.text = "Reviews: \(initialCount)"
        
        let ref = Database.database().reference().child("movie-reviews")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(StringMovieID){
                let newRef = Database.database().reference().child("movie-reviews").child(StringMovieID)
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
        //DispatchQueue.main.async { self.tableView.reloadData() }
        
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
    
    
    //MARK:- Delete a cell from Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            results?.movies.remove(at: indexPath.row)
            print("Deleting movie at \(indexPath.row)")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
    }
    
    //MARK:- Go to Details View Controller
    func showMovie(movie : MovieInfo){
        
//        let detailController = DetailViewController()
//        detailController.movie = movie
//        navigationController?.pushViewController(detailController, animated: true)
        
        let reviewVC1 = ReviewController()
        reviewVC1.movie1 = movie
        //reviewVC1.delegate = self
        navigationController?.pushViewController(reviewVC1, animated: true)
        
    }
    
    //MARK:- If Row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let movie = results?.movies[indexPath.row]{
            self.showMovie(movie:movie)
            print("\(movie.title!) selected")
            
        }
    }
    
    //MARK:- User favourited Movie
    func didFavorite(for cell: MovieFavouriteCell) {
        
        print("didFavorite")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let favoriteMovie = self.results?.movies[(indexPath.item)]
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        guard let movieID = favoriteMovie?.id else { return }
        guard let title = favoriteMovie?.title else {return}
        guard let posterPath = favoriteMovie?.posterPath else {return}
        guard let backdrop = favoriteMovie?.backdrop else {return}
        guard let releaseDate = favoriteMovie?.releaseDate else {return}
        guard let rating = favoriteMovie?.rating else {return}
        guard let overview = favoriteMovie?.overview else {return}
        guard let originalTitle = favoriteMovie?.originalTitle else {return}
        
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
    
    //User Unfavourited Movie
    func didUnFavorite(for cell: MovieFavouriteCell) {
        
        print("did un favorite")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let movieID = (results?.movies[indexPath.row].id)!
        let StringMovieID = String(movieID)
        
        //print("favoriteMovie \(StringMovieID)")
        
        
            Database.database().reference().child("favorites").child(StringMovieID).removeValue() { (error1, ref) in
            if error1 != nil{
                print("Failed to delete movie", error1!)
                return
            
                }
            
        }
    }
    

    
}

