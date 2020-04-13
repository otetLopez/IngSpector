//
//  UserProfileViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

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
        configureView(editing: false)
        currentUser = defaultsAccess.setFromUserDefaults()
        configureView()
    }
    
    @objc func viewTapped()  {
        tf_name.resignFirstResponder()
        tf_ht.resignFirstResponder()
        tf_wt.resignFirstResponder()
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
    }
    
    func configureView() {
        tf_name.text = currentUser.getName()
        tf_email.text = currentUser.getEmail()
        tf_ht.text = "\(currentUser.getHeight()) cm"
        tf_wt.text = "\(currentUser.getWeight()) kg"
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
