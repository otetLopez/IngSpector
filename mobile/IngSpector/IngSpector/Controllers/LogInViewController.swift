//
//  FirstPageViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import QuartzCore

class LogInViewController: UIViewController {

    @IBOutlet weak var tf_uname: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        /* TODO*/
        /* OTET: We need to check if the user is logged in, if so, there is no need to display this page
                 and we will proceed to Home Page*/
        
        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
        
        // Make sure keyboard hides after typing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    @objc func viewTapped() {
        tf_uname.resignFirstResponder()
        tf_pwd.resignFirstResponder()
    }
    
    @IBAction func logBtnPressed(_ sender: UIButton) {
        if tf_uname.text!.isEmpty || tf_pwd.text!.isEmpty {
            if tf_uname.text!.isEmpty {
                tf_uname.layer.borderWidth = 1
                tf_uname.layer.borderColor = UIColor.red.cgColor
            } else {
                tf_uname.layer.borderWidth = 0
            }
            
            if tf_pwd.text!.isEmpty {
                tf_pwd.layer.borderWidth = 1
                tf_pwd.layer.borderColor = UIColor.red.cgColor
            } else {
                tf_pwd.layer.borderWidth = 0
            }
            alert(title: "Error: ", msg: "Missing mandatory fields")
        } else {
            // Check user
        }
    }
    
    func alert(title: String, msg : String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         if let reg_delegate = (segue.destination as! UINavigationController).topViewController as? RegisterViewController {
//            reg_delegate.log_delegate = self
//        }
//    }
    

}
