//
//  RegisterViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {

    weak var log_delegate: FirstPageViewController?
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_eadd: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var tf_cpwd: UITextField!
    @IBOutlet weak var tf_height: UITextField!
    @IBOutlet weak var tf_weight: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Name
        let l_name = CALayer()
        l_name.frame = CGRect(x: 0.0, y: tf_name.frame.height - 1, width: tf_name.frame.width, height: 1.0)
        l_name.backgroundColor = UIColor.white.cgColor
        tf_name.layer.addSublayer(l_name)
        tf_name.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Email
        let l_email = CALayer()
        l_email.frame = CGRect(x: 0.0, y: tf_eadd.frame.height - 1, width: tf_eadd.frame.width, height: 1.0)
        l_email.backgroundColor = UIColor.white.cgColor
        tf_eadd.layer.addSublayer(l_email)
        tf_eadd.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Height
        let l_ht = CALayer()
        l_ht.frame = CGRect(x: 0.0, y: tf_height.frame.height - 1, width: tf_height.frame.width, height: 1.0)
        l_ht.backgroundColor = UIColor.white.cgColor
        tf_height.layer.addSublayer(l_ht)
        tf_height.attributedPlaceholder = NSAttributedString(string: "Height (m)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Weight
        let l_wt = CALayer()
        l_wt.frame = CGRect(x: 0.0, y: tf_weight.frame.height - 1, width: tf_weight.frame.width, height: 1.0)
        l_wt.backgroundColor = UIColor.white.cgColor
        tf_weight.layer.addSublayer(l_wt)
        tf_weight.attributedPlaceholder = NSAttributedString(string: "Weight (kg)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Password
        let l_pwd = CALayer()
        l_pwd.frame = CGRect(x: 0.0, y: tf_pwd.frame.height - 1, width: tf_pwd.frame.width, height: 1.0)
        l_pwd.backgroundColor = UIColor.white.cgColor
        tf_pwd.layer.addSublayer(l_pwd)
        tf_pwd.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Confirm Password
        let l_cpwd = CALayer()
        l_cpwd.frame = CGRect(x: 0.0, y: tf_cpwd.frame.height - 1, width: tf_cpwd.frame.width, height: 1.0)
        l_cpwd.backgroundColor = UIColor.white.cgColor
        tf_cpwd.layer.addSublayer(l_cpwd)
        tf_cpwd.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func configure_tf() {
        
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mapDelegate = segue.destination as? MapViewController {
//                   mapDelegate.delegate = self
//               }
//    }
    

}
