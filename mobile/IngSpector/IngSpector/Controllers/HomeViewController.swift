//
//  HomeViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/8/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    weak var home_delegate: LogInViewController?
    @IBOutlet weak var analyzeFoodBtn: UIButton!
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    var defaultsAccess : DefaultsAccess = DefaultsAccess()
    var serverConnection : ServerConnection = ServerConnection()
    var internetConnection : InternetConnection = InternetConnection()
    override func viewDidLoad() {
        super.viewDidLoad()

        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
        
        /* For Testing purposes only.  Adding Dummy food */
        //addFood(newFood: "Cajun Shrimps")
        //addFood(newFood: "Peanut Butter")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()        
    }
    
    @IBAction func takePhotoBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {

    }

    func addFood(newFood: String) {
        if isFoodRecorded(newFood: newFood) == false {
            var foodList : [String] = defaultsAccess.getFoodListFromDefaults()
            
            /* Add to user defaults */
            foodList.append(newFood)
            defaultsAccess.setFoodListToDefaults(foodList: foodList)
            
            /* Add to server */
            let email : String = defaultsAccess.getEmailFromDefaults()
            let url : String = serverConnection.getURLAddFood() + "\(email)/\(newFood.replacingOccurrences(of: " ", with: "%20"))"
            print("DEBUG: addFood food to user details \(url)")
 
            if (!internetConnection.isConnected()) {
                showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
            }  else {
                AF.request(url, method: .get).responseJSON {
                response in
                    print("Sending new food to server")
                }
            }
        }
    }
    
    func isFoodRecorded(newFood: String) -> Bool {
        let foodList : [String] = defaultsAccess.getFoodListFromDefaults()
        for food in foodList {
            if food == newFood {
                return true
            }
        }
        return false
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
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        //Highlight navigation button for current view
        homeBtn.tintColor = UIColor.systemTeal
        listBtn.tintColor = UIColor.white
        profileBtn.tintColor = UIColor.white
        
        cameraBtn.layer.cornerRadius = 10
        searchBtn.layer.cornerRadius = 10
    }
}
