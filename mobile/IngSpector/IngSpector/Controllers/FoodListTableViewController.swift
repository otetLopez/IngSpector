//
//  FoodListTableViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Remove data from server
            
            // Update userdefaults?
            
            foodList.remove(at: indexPath.row)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        var detailStr = "\nFood List:\n"
        for idx in foodList {
            detailStr += "\t \(idx)\n"
        }
        print("DEBUG: FoodList() \(detailStr)")
        tableView.reloadData()
    }

}
