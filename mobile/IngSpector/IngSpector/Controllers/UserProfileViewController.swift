//
//  UserProfileViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    @IBOutlet weak var viewListBtn: UIButton!
    @IBOutlet weak var signoutBtn: UIButton!
    
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_ht: UITextField!
    @IBOutlet weak var tf_wt: UITextField!
    
    @IBOutlet weak var addAllergensBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing == true {
            //tf_email.isUserInteractionEnabled = true
            //tf_name.isUserInteractionEnabled = true
            tf_ht.isUserInteractionEnabled = true
            tf_wt.isUserInteractionEnabled = true
            addAllergensBtn.isUserInteractionEnabled = true
            //addAllergensBtn.isHidden = false
    
        } else {
            //tf_name.isUserInteractionEnabled = false
            //tf_email.isUserInteractionEnabled = false
            tf_ht.isUserInteractionEnabled = false
            tf_wt.isUserInteractionEnabled = false
            addAllergensBtn.isUserInteractionEnabled = false
            //addAllergensBtn.isHidden = true
        }
    }
    
    func configureView() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        //Highlight navigation button for current view
        homeBtn.tintColor = UIColor.white
        listBtn.tintColor = UIColor.white
        profileBtn.tintColor = UIColor.systemTeal
        
        viewListBtn.layer.cornerRadius = 10
        addAllergensBtn.layer.cornerRadius = 10
        signoutBtn.layer.cornerRadius = 10
        
        
        // Name
        let l_name = CALayer()
        l_name.frame = CGRect(x: 0.0, y: tf_name.frame.height - 1, width: tf_name.frame.width, height: 1.0)
        l_name.backgroundColor = UIColor.white.cgColor
        tf_name.layer.addSublayer(l_name)
        
        
        // Email
        let l_email = CALayer()
        l_email.frame = CGRect(x: 0.0, y: tf_email.frame.height - 1, width: tf_email.frame.width, height: 1.0)
        l_email.backgroundColor = UIColor.white.cgColor
        tf_email.layer.addSublayer(l_email)
        
        // Height
        let l_ht = CALayer()
        l_ht.frame = CGRect(x: 0.0, y: tf_ht.frame.height - 1, width: tf_ht.frame.width, height: 1.0)
        l_ht.backgroundColor = UIColor.white.cgColor
        tf_ht.layer.addSublayer(l_ht)

        
        // Weight
        let l_wt = CALayer()
        l_wt.frame = CGRect(x: 0.0, y: tf_wt.frame.height - 1, width: tf_wt.frame.width, height: 1.0)
        l_wt.backgroundColor = UIColor.white.cgColor
        tf_wt.layer.addSublayer(l_wt)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
