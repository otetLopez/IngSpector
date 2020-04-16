//
//  UserProfileViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    @IBOutlet weak var signoutBtn: UIButton!
    
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_ht: UITextField!
    @IBOutlet weak var tf_wt: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAllergensBtn: UIButton!
    
    var defaultsAccess = DefaultsAccess()
    var currentUser : UserDetails = UserDetails()
    var internetConnection : InternetConnection = InternetConnection()
    var serverConnection : ServerConnection = ServerConnection()
    var allergenList : [String] = [String]()
    
    let l_ht = CALayer()
    let l_wt = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentUser = defaultsAccess.setFromUserDefaults()
        configureView(editing: false)
        
        /* We need to make sure we have the latest data */
        refreshData(refreshView: true)
        
        /* Configure again even if it is configured in refreshData
            Because we just configure what we have in case return from server takes time */
        configureView()
    }
    
    @objc func viewTapped()  {
        tf_name.resignFirstResponder()
        tf_ht.resignFirstResponder()
        tf_wt.resignFirstResponder()
    }
    
    @IBAction func addAllergensPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Allergens", message: "Enter an ingredient you are allergic to", preferredStyle: .alert)
        
        alertController.addTextField { (nAllergen) in
            nAllergen.placeholder = "e.g. Peanut"
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textField = alertController.textFields![0]
            print("DEBUG: RegisterViewController::addAllergenList(): Will be adding folder \(textField.text!)")
            self.addAllergen(allergen: "\(textField.text!)")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutBtnPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Logging Out", message: "Are you sure?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
                self.defaultsAccess.removeUserFromDefaults()
                self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        configureView(editing: editing)
        // Confirm user on changes
        if editing == false {
            confirmChanges()
        }
    }
    
    func addAllergen(allergen: String) {
        allergenList.append(allergen)
        tableView.reloadData()
    }
    
    func confirmChanges() {
        if isChanged() {
            let alertController = UIAlertController(title: "Save Changes", message: "Are you sure?", preferredStyle: .alert)
        
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: {
                action in
                self.configureView()
            }))
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                action in
                self.saveChanges()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func promptChange(identifier: String) {
        if isChanged() {
            let alertController = UIAlertController(title: "Discard Changes?", message: "Are you sure?", preferredStyle: .alert)
        
            alertController.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {
                action in
                self.performSegue(withIdentifier: identifier, sender: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                action in
                self.saveChanges()
                self.performSegue(withIdentifier: identifier, sender: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveChanges() {
        currentUser.setHeight(height: Double(tf_ht.text!)!)
        currentUser.setWeight(weight: Double(tf_wt.text!)!)
        currentUser.setAllergens(allergens: allergenList)
        
        /* This is a flight case but why would a user do that? */
        //refreshData(refreshView: false)
        updateServer()
        
        
    }
    
    func isChanged() -> Bool {
        var changed : Bool = false
        if (tf_ht.text != "\(currentUser.getHeight())" || tf_wt.text != "\(currentUser.getWeight())") {
            changed = true
        }
        let originauxList : [String] = currentUser.getAllergens()
        if(allergenList.count == originauxList.count) {
            for (index, element) in allergenList.enumerated() {
                if element != originauxList[index] {
                    changed = true
                }
            }
        } else { changed = true }
        return changed
    }
    
    func configureView() {
        tf_name.text = currentUser.getName()
        tf_email.text = currentUser.getEmail()
        tf_ht.text = "\(currentUser.getHeight())"
        tf_wt.text = "\(currentUser.getWeight())"
        allergenList = currentUser.getAllergens()
        self.tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        //Highlight navigation button for current view
        homeBtn.tintColor = UIColor.white
        listBtn.tintColor = UIColor.white
        profileBtn.tintColor = UIColor.systemTeal
        
        addAllergensBtn.layer.cornerRadius = 10
        signoutBtn.layer.cornerRadius = 10
    }
    
    func configureView(editing: Bool) {
        if editing == true {
            tf_ht.isUserInteractionEnabled = true
            tf_wt.isUserInteractionEnabled = true
            addAllergensBtn.isUserInteractionEnabled = true
            addAllergensBtn.tintColor = UIColor.white
            addAllergensBtn.setTitleColor(UIColor.white, for: .normal)
            addAllergensBtn.alpha = 1
            
            // Height
            l_ht.frame = CGRect(x: 0.0, y: tf_ht.frame.height - 1, width: tf_ht.frame.width, height: 1.0)
            l_ht.backgroundColor = UIColor.white.cgColor
            tf_ht.layer.addSublayer(l_ht)
            tf_ht.textColor = UIColor.white

            // Weight
            l_wt.frame = CGRect(x: 0.0, y: tf_wt.frame.height - 1, width: tf_wt.frame.width, height: 1.0)
            l_wt.backgroundColor = UIColor.white.cgColor
            tf_wt.layer.addSublayer(l_wt)
            tf_wt.textColor = UIColor.white
        } else {
            tf_ht.isUserInteractionEnabled = false
            tf_wt.isUserInteractionEnabled = false
            addAllergensBtn.isUserInteractionEnabled = false
            addAllergensBtn.tintColor = UIColor.gray
            addAllergensBtn.setTitleColor(UIColor.gray, for: .normal)
            addAllergensBtn.alpha = 0
            
            tf_ht.layer.sublayers?.first?.removeFromSuperlayer()
            tf_wt.layer.sublayers?.first?.removeFromSuperlayer()
            
            tf_ht.textColor = UIColor.lightGray
            tf_wt.textColor = UIColor.lightGray
        }
    }

    func refreshData(refreshView: Bool) {
        let url : String = serverConnection.getURLinfo() + "\(currentUser.getEmail())/get"
        if (!internetConnection.isConnected()) {
            showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
        }  else {
            showProgress(msg: "Updating Data From Server")
            AF.request(url, method: .get).responseJSON {
            response in
                switch response.result {
                    case let .success(value):
                        let dataJSON : JSON = JSON(value)
                        self.currentUser = self.serverConnection.parseUserInfo(dataJSON: dataJSON)
                        self.setUpdatesFromServer(refreshView: refreshView)
                        SVProgressHUD.dismiss()
                    case let .failure(error):
                        print(error)
                }
            }
        }
    }

    func setUpdatesFromServer(refreshView: Bool) {
        defaultsAccess.setToUserDefaults(user: currentUser)
        if refreshView == true { configureView() } else {
            /* This is not a refrefresh View, user wish to change data*/
            
        }
    }
    
    func updateServer() {
        var url : String = serverConnection.getURLupd() + "\(currentUser.getEmail())/"
        if(allergenList.count > 0) {
            for allergen in allergenList {
                url = url + "\(allergen),"
            }
            url = String(url.dropLast())
        } else {
            url = url + "empty" }
        url = url + "/\(currentUser.getHeight())/\(currentUser.getWeight())"
        
        print("DEBUG: updateServer \(url)")
        if (!internetConnection.isConnected()) {
            showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
        } else {
            AF.request(url, method: .get).responseJSON {
            response in
                print("DEBUG: Updated user data")
            }
        }
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "foodlist" || identifier == "home") {
            if isEditing == true {
                promptChange(identifier: identifier)
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profile_cell", for: indexPath)
        cell.textLabel!.text = " \(indexPath.row + 1) \(allergenList[indexPath.row])"
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allergenList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.isEditing == true { return .delete } else { return .none }
    }

}
