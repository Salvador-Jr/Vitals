//
//  SettingsViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 9/10/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class SettingsViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var sendHeartRateLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bdyLabel: UITextView!
    var sendTo = "NeeedToReplace@gmail.com"
    let HeartRateIntegerValue = 0
    var sendBody = "Default Body"
    let placeholderText = "Include a message here. Your data will be included at the end of this message. For example: \n\nDear Dr X,\nPlease see attached heart rate data for examination.\nThe folllowing is the data recorded by my device on December 30th, 2030 \nHeart Rate: 95 "
    var hr = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        bdyLabel.delegate = self
        bdyLabel.returnKeyType = .done
        emailTextField.delegate = self
        emailTextField.returnKeyType = .done
        bdyLabel.text = placeholderText
        bdyLabel.textColor = UIColor.lightGray
        if (bdyLabel.isFirstResponder)
        {
            textViewDidBeginEditing(bdyLabel)
        }
        else{
            bdyLabel.text = placeholderText
        }
//        print ("NEW screen", hr) //debug statement
        let HRdata = hr[0]
        let HeartRateIntegerValue = HRdata["HeartRateReading"] as? Int
        sendHeartRateLabel.text = String(HeartRateIntegerValue!)
        //        sendHeartRateLabel.text = HRdata["HeartRateReading"] as? String
        let createdAt = HRdata.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let myStringDBDateTime = formatter.string(from:createdAt!)
        sendDateLabel.text = String(myStringDBDateTime)
//        print (HRdata["HeartRateReading"])
//        print (String(myStringDBDateTime))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButton(_ sender: Any) {
        sendTo = emailTextField.text!
        sendBody = bdyLabel.text!
        sendBody = bdyLabel.text! + " \nThe folllowing is the data recorded by my device on " + sendDateLabel.text! + " \n Heart rate: " + sendHeartRateLabel.text!
        let mailComposeViewC = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            present(mailComposeViewC, animated: true, completion: nil)
        }
        else{
            print("canNotSend MAIL")
            showMailError()
        }
        
    }
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            textField.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    func configureMailController()->MFMailComposeViewController{
        let viewControllerComposeMail = MFMailComposeViewController()
        viewControllerComposeMail.mailComposeDelegate = self
        viewControllerComposeMail.setSubject("HealthData")
        viewControllerComposeMail.setToRecipients([sendTo])
        viewControllerComposeMail.setMessageBody(sendBody, isHTML: false)
        return viewControllerComposeMail
    }
    func showMailError(){
        let mailErrorAlert = UIAlertController(title: "could not send email", message: "your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Success", style: .default, handler: nil)
        mailErrorAlert.addAction(dismiss)
        self.present(mailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result{
        case .cancelled:
            print("Message Cancelled")
        case .failed:
            print("Message Failed to send")
        case.saved:
            print("Message Saved")
        case.sent:
            print("Message Sent Successfully")
        }
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
