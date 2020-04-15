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

class FoodListTableViewController: UITableViewController {

    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    
    var foodList : [String] = [String]()
    var serverConnection : ServerConnection = ServerConnection()
    var defaultsAccess : DefaultsAccess = DefaultsAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return foodList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodlist", for: indexPath)
        cell.textLabel!.text = " \(indexPath.row + 1) \(foodList[indexPath.row])"
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
    
    func retrieveFoodList() {
        let email : String = defaultsAccess.getEmailFromDefaults()
        let url : String = serverConnection.getURLinfo() + email + "/get"
        
        print("DEBUG: FoodList retrieveFoodList() \(url)")
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.darkGray)
        SVProgressHUD.setBackgroundColor(UIColor.orange)
        SVProgressHUD.show(withStatus: "Updating List From Server")
        
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
                    print(error)
            }
        }
    }
}
