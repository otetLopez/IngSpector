//
//  HomeViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/8/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    weak var home_delegate: LogInViewController?
    @IBOutlet weak var analyzeFoodBtn: UIButton!
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    @IBAction func takePhotoBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {

    }
    func promptAnalyzeOptions() {
        let alertController = UIAlertController(title: "Analyze Food", message: "Analyze food from the following options", preferredStyle: .alert)
    
        let cameraAction = UIAlertAction(title: "Take Photo of Food Label", style: .default) { (action) in
        
        }
        
        let nameAction = UIAlertAction(title: "Photo Gallery", style: .default) { (action) in
            self.promptFoodName()
        }
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(nameAction)

        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func promptFoodName() {
        let alertController = UIAlertController(title: "Food Name", message: "Input name of food to analyze ingredients", preferredStyle: .alert)

        alertController.addTextField { (nFoodName) in
            nFoodName.placeholder = "Food Name"
        }
        
        let searchFoodAction = UIAlertAction(title: "IngSpect!", style: .default) { (action) in
            let textField = alertController.textFields![0]
            print("DEBUG: Searching for food  \(textField.text!)")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(searchFoodAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
