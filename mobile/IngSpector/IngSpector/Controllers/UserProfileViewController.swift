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
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_ht: UITextField!
    @IBOutlet weak var tf_wt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing == true {
            tf_email.isUserInteractionEnabled = true
            tf_ht.isUserInteractionEnabled = true
            tf_wt.isUserInteractionEnabled = true
        } else {
            tf_email.isUserInteractionEnabled = false
            tf_ht.isUserInteractionEnabled = false
            tf_wt.isUserInteractionEnabled = false
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
//        tf_height.attributedPlaceholder = NSAttributedString(string: "Height (m)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Weight
        let l_wt = CALayer()
        l_wt.frame = CGRect(x: 0.0, y: tf_wt.frame.height - 1, width: tf_wt.frame.width, height: 1.0)
        l_wt.backgroundColor = UIColor.white.cgColor
        tf_wt.layer.addSublayer(l_wt)
//        tf_wt.attributedPlaceholder = NSAttributedString(string: "Weight (kg)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
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
