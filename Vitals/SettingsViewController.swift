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

class SettingsViewController: UIViewController {
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var sendHeartRateLabel: UILabel!
    @IBAction func sendButton(_ sender: Any) {
        showMailComposer()
    }
    func showMailComposer(){
        print("mail composer")
        guard MFMailComposeViewController.canSendMail()else{
            print("can not send mail")
            return
        }
        let composer  = MFMailComposeViewController()
        composer.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        composer.setToRecipients(["salvador.rodriguez01@sjsu.edu"])//will want to replace with whatever is in the text field
        composer.setSubject("HEALTH DATA")
        composer.setMessageBody("BODY info", isHTML: false)
        present(composer, animated: true)
        
    }
    var hr = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("NEW screen", hr) //debug statement
        let HRdata = hr[0]
        let HRint = HRdata["HeartRateReading"] as? Int
        sendHeartRateLabel.text = String(HRint!)
//        sendHeartRateLabel.text = HRdata["HeartRateReading"] as? String
        let createdAt = HRdata.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let myStringDBDateTime = formatter.string(from:createdAt!)
        sendDateLabel.text = String(myStringDBDateTime)
        print (HRdata["HeartRateReading"])
        print (String(myStringDBDateTime))

        
        // Do any additional setup after loading the view.
    }
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
