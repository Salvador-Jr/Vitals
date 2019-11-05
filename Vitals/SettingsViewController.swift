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

class SettingsViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var sendHeartRateLabel: UILabel!
    @IBOutlet weak var emalLabel: UITextField!
    @IBOutlet weak var bdyLabel: UITextView!
    var sendTo = "chillsss@gmail.com"
    let HeartRateIntegerValue = 0
    var sendBody = "Default Body"
    let placeholderText = "Include a message here. Your data will be included at the end of this message. For example: Dear Dr X, Please see attached heart rate data for examination."
    var hr = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        bdyLabel.delegate = self
        bdyLabel.returnKeyType = .done
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
        sendTo = emalLabel.text!
        sendBody = bdyLabel.text!
        sendBody = bdyLabel.text! + " \nThe folllowing is the data recorded by my device on " + sendDateLabel.text! + " \n Heart rate: " + sendHeartRateLabel.text!
        showMailComposer()
    }
    func showMailComposer(){
        print("mail composer")
        guard MFMailComposeViewController.canSendMail()else{
            print("can not send mail")
            return
        }
//        sendTo = "chill@gmail.com"
        let composer  = MFMailComposeViewController()
        composer.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        composer.setToRecipients([sendTo])//will want to replace with whatever is in the text field
//        composer.setToRecipients([sendTo])
        composer.setSubject("HEALTH DATA")
//        composer.setMessageBody("BODY info", isHTML: false)
        composer.setMessageBody(sendBody , isHTML: false)
        present(composer, animated: true)
        
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
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
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


extension MailComposerViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            controller.dismiss(animated: true)
            return
        }
        switch result{
        case .cancelled:
            print("can")
        case .failed:
            print("fail")
        case.saved:
            print("save")
        case.sent:
            print("sent")
        }
        controller.dismiss(animated: true)
    }
}

