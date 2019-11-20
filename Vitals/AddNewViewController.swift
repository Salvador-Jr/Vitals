//
//  AddNewViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 11/7/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse

class AddNewViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var beatsField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        beatsField.delegate = self
        beatsField.returnKeyType = .done

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButton(_ sender: Any) {
        print(PFUser.current()!)
        let beatsAsInt = (Int(beatsField.text!)! * 4)
        let HeartData = PFObject(className: "HeartRate")
        HeartData["HeartRateReading"] = beatsAsInt
        HeartData["User"] = PFUser.current()
//        PFUser.current()?["User"] = PFUser.current()?.objectId
        HeartData.saveInBackground {(success, error) in
            if success {
                print("Saved both")
            }
            else{
                print("error")
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            textField.resignFirstResponder()
        }
        return true
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
