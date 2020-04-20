//
//  SearchByProductNameViewController.swift
//  IngSpector
//
//  Created by DKU on 14.04.2020.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class SearchByProductNameViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var checkAllegensBtnOutlet: UIButton!
    @IBOutlet weak var searchText: UITextField!
    
    var serverConnection : ServerConnection = ServerConnection()
    
    var defaultsAccess = DefaultsAccess()
    var allergensOfUser : [String] = [String]()
    var allergicIngredients : [String] = [String]()
    var allergicFoods : [String] = [String]()
    
    var internetConnection : InternetConnection = InternetConnection()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAllegensBtnOutlet.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        allergensOfUser = defaultsAccess.getAllergenListFromDefaults()
        allergicFoods = defaultsAccess.getFoodListFromDefaults()
        print(allergensOfUser);
        
        //Gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NutritionFactsViewController.viewTapped(gestureRecognnizer:))) ;
        view.addGestureRecognizer(tapGesture);
        self.searchText.delegate = self 
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showNutrition"){
            let vc = segue.destination as! NutritionFactsViewController;
            
            vc.incomingFoodName = searchText.text!.uppercased();
            
        }
    }

    @IBAction func checkAllergensButton(_ sender: Any) {
        if (!internetConnection.isConnected()) {
            showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
        }
        else {
            
            if(searchText.text != ""){
            
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setForegroundColor(UIColor.darkGray)
            SVProgressHUD.setBackgroundColor(UIColor.orange)
            SVProgressHUD.show(withStatus: "Checking Allergens...")
            
            
            var searchString : String = searchText.text!;
                    searchString = searchString.replacingOccurrences(of: " ", with: "%20")
                
                    let apiUrl : String = "http://www.recipepuppy.com/api/?q=\(searchString)&p=1"
                    
                       AF.request(apiUrl, method: .get).responseJSON {
                         response in
                            // SVProgressHUD.dismiss()
                             switch response.result {
                                 case let .success(value):
                                    let dataJSON : JSON = JSON(value)
                                     
                                    if let ingredientsOfSearchedProduct = dataJSON["results"][0]["ingredients"].string{
                                    let ingredientArray = ingredientsOfSearchedProduct.components(separatedBy: ",")
                                        print("ingredientArray")
                                    print(ingredientArray);
                                       
                                    for i in self.allergensOfUser{

                                    let searchStr = i
                                    let lowerCasedStr : String = searchStr.lowercased();
                                    for x in 0...ingredientArray.count-1{
  
                                        if(ingredientArray[x].contains(lowerCasedStr)){
                                        self.allergicIngredients.append(searchStr)
                                                
                                        }
                                    }
                                }
                                        let when = DispatchTime.now() + 2
                                        DispatchQueue.main.asyncAfter(deadline: when){
                                        SVProgressHUD.dismiss()
                                         
                                            if(self.allergicIngredients.count > 0){
                                                var result : String = "ALLERGIC ITEMS\n\n"
                                                    for i in 0...self.allergicIngredients.count-1{
                                                        result += "\(i+1)- \(self.allergicIngredients[i].uppercased()) "
                                                    }
                                                
                                                let alert = UIAlertController(title: "Allergic Item Found!", message: result , preferredStyle: .alert);

                                                let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                                                    alert.dismiss(animated: true) {
                                                        
                                                        var checkResult :Bool = true;
                                                        //check if there is any duplication
                                                        if(self.allergicFoods.count > 0){
                                                            for c in 0...self.allergicFoods.count-1{
                                                                if(self.searchText.text?.lowercased() == self.allergicFoods[c].lowercased()){
                                                                        checkResult = false
                                                                        break
                                                                    }
                                                                                                                       
                                                                else{
                                                                    checkResult = true
                                                                    }
                                                                                                                       
                                                            }
                                                        }
                                                       
                                                      
                                                        if(checkResult){
                                                            self.allergicFoods.append((self.searchText.text?.uppercased())!)
                                                            self.defaultsAccess.setFoodListToDefaults(foodList: self.allergicFoods)
                                                                                                                 
                                                            /* Add to server */
                                                            let email : String = self.defaultsAccess.getEmailFromDefaults()
                                                            let url : String = self.serverConnection.getURLAddFood() + "\(email)/\(self.searchText.text!.uppercased().replacingOccurrences(of: " ", with: "%20"))"
                                                            self.searchText.text=""
                                                            AF.request(url, method: .get).responseJSON {
                                                                response in
                                                                    switch response.result {
                                                                        case .success(_):
                                                                            print("")
                                                                        case let .failure(error):
                                                                            print(error)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                           
                                                alert.addAction(okAction);
                                                self.present(alert, animated: true, completion: nil)
                                                self.allergicIngredients.removeAll()
                                                }
                                            //if there is not any allergic item in food
                                            if(self.allergicIngredients.count == 0){
                                                let alertNot = UIAlertController(title: "\(self.searchText.text!.uppercased()) is not Allergic", message: "Do you want to learn nutrition facts of \(self.searchText.text!.uppercased())" , preferredStyle: .alert);
                                                let okActionn = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                                                    alertNot.dismiss(animated: true, completion: nil)
                                                
                                                    //segue to nutrituin facts
                                                     self.performSegue(withIdentifier: "showNutrition", sender: nil);
                                                     self.searchText.text=""
                                                    
                                                    
                                                }
                                                
                                                let noActionn = UIAlertAction(title: "No, I'm Okay", style: .default) { (UIAlertAction) in
                                                 alertNot.dismiss(animated: true, completion: nil)
                                                 self.searchText.text=""
   
                                                }
                                                
                                                alertNot.addAction(okActionn)
                                                alertNot.addAction(noActionn)
                                                self.present(alertNot, animated: true, completion: nil)
                                        }
                                    }
                                }
                                     
                                    //if not found
                                     else{
                                        print("not found")
                                        SVProgressHUD.dismiss()
                                        let alertNotFound = UIAlertController(title: "Food not exist", message: "Try another search", preferredStyle: .alert)
                                        let okActionnn = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                                            alertNotFound.dismiss(animated: true, completion: nil)
                                        self.searchText.text=""

                                     }
                                        alertNotFound.addAction(okActionnn)
                                        self.present(alertNotFound, animated: true, completion: nil)
                                }
                                     
                                     
                                 case let .failure(error):
                                     print(error)
                                   self.showToastMsg(msg: "Cannot Connect To Server.  Please Try Again.", seconds: 3)
                                     
                             }
                         }
                }
        else{
             showToastMsg(msg: "Please enter food name to search", seconds: 2)
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
            
