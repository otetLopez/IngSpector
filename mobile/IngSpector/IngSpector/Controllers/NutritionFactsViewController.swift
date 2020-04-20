//
//  NutritionFactsViewController.swift
//  IngSpector
//
//  Created by DKU on 16.04.2020.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class NutritionFactsViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var weightOfFood: UITextField!
    

    @IBOutlet weak var resultLabel: UILabel!
    
    var defaultsAccess = DefaultsAccess()
    
    var height = 0.0
    var weight = 0.0
    
    var internetConnection : InternetConnection = InternetConnection()
    
    var incomingFoodName = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infoLabel.text = "Just enter the weight of \(incomingFoodName) to learn percentage of daily needs"
        height = (defaultsAccess.getHeightFromDefaults() as NSString).doubleValue
        weight = (defaultsAccess.getWeightFromDefaults() as NSString).doubleValue
        

        
        //Gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NutritionFactsViewController.viewTapped(gestureRecognnizer:))) ;
        view.addGestureRecognizer(tapGesture);
        self.weightOfFood.delegate = self 
    }
    

    @IBAction func checkPercentageButton(_ sender: UIButton) {
      if (!internetConnection.isConnected()) {
                showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
            }
      
      else {
        if(weightOfFood.text != ""){
            let  searchString = incomingFoodName.replacingOccurrences(of: " ", with: "%20")
             let apiUrl = "https://api.edamam.com/search?q=\(searchString)&app_id=b08257a1&app_key=98394a3aa4aa67613ded3d2f91f96e7c&from=0&to=1"
              
            AF.request(apiUrl, method: .get).responseJSON {
            response in
                print("girdi")
              print(apiUrl)
                switch response.result {
                    case let .success(value):
                        let dataJSON : JSON = JSON(value)
                  print(dataJSON)
                
                        let calorie  = dataJSON["hits"][0]["recipe"]["calories"].stringValue
                        let totalWeight  = dataJSON["hits"][0]["recipe"]["totalWeight"].stringValue
                 
                  
                        if(calorie != ""){
                          let doubleValueOfCalorie = (calorie as NSString).doubleValue
                      
                          let doubleValueOfTotalWeight = (totalWeight as NSString).doubleValue
          
                          let doubleValueOfInput = (self.weightOfFood.text! as NSString).doubleValue
                      
                          let gramCalorie = doubleValueOfCalorie/doubleValueOfTotalWeight
                          let totalCalorie = gramCalorie*doubleValueOfInput
                         
                          let basalMetabolicRate = ((10*self.weight) + (6.25*self.height) - (5*30) + 5) * 1.2
                         
                          let percentage = (totalCalorie/basalMetabolicRate) * 100
                          let doubleStr = Double(String(format: "%.2f", percentage))
                          
                            self.resultLabel.text = "%\n \(doubleStr!) \n Of Your Daily \n Calorie Needs"
                            
                          
                      }
                  
                        else{
                          //notfound
                          
                  }
                  
                      
                        
                    case let .failure(error):
                        print(error)
                        self.showToastMsg(msg: "Cannot Connect To Server.  Please Try Again.", seconds: 3)
                    }
                }
                      
            }
        
        else{
             showToastMsg(msg: "Please enter the weight of food", seconds: 2)
        }
    }
         view.endEditing(true);
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
    
    //Gesture recognizer methods
    
    //When tapped rather than keyboard , keyboard will closed
     @objc func viewTapped(gestureRecognnizer : UITapGestureRecognizer){

         view.endEditing(true);
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
