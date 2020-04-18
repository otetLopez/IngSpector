//
//  FoodListTableViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class FoodListTableViewController: UITableViewController , UISearchResultsUpdating{
  
    

    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    
    var foodList : [String] = [String]()
    var serverConnection : ServerConnection = ServerConnection()
    var defaultsAccess : DefaultsAccess = DefaultsAccess()
    var internetConnection : InternetConnection = InternetConnection()
    
    var filteredFoods : [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var  refreshContinue = false
    var sender : UIRefreshControl? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Allergic Foods"

        definesPresentationContext = true
              
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        //White text color on searchbar...
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey:"searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
    }
    
    @IBAction func refreshControl(_ sender: UIRefreshControl) {
        self.refreshContinue = true
        self.sender = sender
        retrieveFoodList()
    
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
         self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let searchBar = searchController.searchBar
        filterContentSearchBar(searchText: searchBar.text!) ;
    }
    
    func filterContentSearchBar(searchText : String ){

        filteredFoods = foodList.filter{ (foods : String) -> Bool in
        return foods.lowercased().contains(searchText.lowercased())
        }
            
        self.tableView.reloadData();
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: FoodList Count \(foodList.count)")
        
        if(isFiltering){
            return filteredFoods.count
        }
        
        else{
            return foodList.count
        }
        
      
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodlist", for: indexPath)
        
        var food : String ;
        
        if(isFiltering){
            food = filteredFoods[indexPath.row]
        }
        
        else{
            food = foodList[indexPath.row]
        }

        
        cell.textLabel!.text = " \(indexPath.row + 1) \(food)"
        cell.layer.cornerRadius = 10
        return cell
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        
        //Highlight navigation button for current view
        homeBtn.tintColor = UIColor.white
        listBtn.tintColor = UIColor.systemTeal
        profileBtn.tintColor = UIColor.white
        
        //Retrieve Data but make sure we have the latest (one in the server)
        foodList = defaultsAccess.getFoodListFromDefaults()
        retrieveFoodList()
        
        var detailStr = "\nFood List:\n"
        for idx in foodList {
            detailStr += "\t \(idx)\n"
        }
        print("DEBUG: FoodList() \(detailStr)")
        tableView.reloadData()
    }
    
    func showToastMsg(msg: String, seconds: Double) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alertController.view.alpha = 0.5
        alertController.view.layer.cornerRadius = 15
        
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alertController.dismiss(animated: true)
        }
    }

    func showProgress(msg: String) {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.darkGray)
        SVProgressHUD.setBackgroundColor(UIColor.orange)
        SVProgressHUD.show(withStatus: msg)
    }

    
    func retrieveFoodList() {
        let email : String = defaultsAccess.getEmailFromDefaults()
        let url : String = serverConnection.getURLinfo() + email + "/get"
        
        if (!internetConnection.isConnected()) {
            showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
        } else {
            AF.request(url, method: .get).responseJSON {
            response in
                SVProgressHUD.dismiss()
                switch response.result {
                    case let .success(value):
                        let dataJSON : JSON = JSON(value)
                        let user = self.serverConnection.parseUserInfo(dataJSON: dataJSON)
                        self.defaultsAccess.setFoodListToDefaults(foodList: user.getFoodList())
                        self.foodList = user.getFoodList()
                        self.tableView.reloadData()
                    case let .failure(error):
                        self.showToastMsg(msg: "Cannot Connect To Server.  Please Try Again.", seconds: 3)
                        print(error)
                }
            }
        }
        if(refreshContinue){
            self.sender?.endRefreshing()
        }
    }
}
