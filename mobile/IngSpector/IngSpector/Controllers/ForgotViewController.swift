//
//  ForgotViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/13/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var sendEmailBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    
    @IBAction func sendEmail(_ sender: UIButton) {
//        if MFMailComposeViewController.canSendMail() {
//            //let mailComposeViewController = configureMailComposer(newMsg: msgToSend)
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.mailComposeDelegate = self
//            mail.setSubject("IngSpector Account Forget Password")
//            mail.setToRecipients()
//            mail.setMessageBody(, isHTML: true)
//            present(mail, animated: true, completion: nil)
//        } else { print("DEBUG: Cannot send email") }
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        sendEmailBtn.layer.cornerRadius = 10
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
