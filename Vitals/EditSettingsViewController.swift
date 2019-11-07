//
//  EditSettingsViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 11/6/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse

class EditSettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var bloodTypeField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderField.returnKeyType = .done
        genderField.delegate = self
        bloodTypeField.returnKeyType = .done
        bloodTypeField.delegate = self
        emailField.returnKeyType = .done
        emailField.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func updateGenderButton(_ sender: Any) {
        PFUser.current()!["Sex"] = genderField.text!
        PFUser.current()?.saveInBackground {(success, error) in
            if success {
                print("Gender saved")
            }
            else{
                print("error")
            }
        }
    }

    @IBAction func bloodTypeButton(_ sender: Any) {
        PFUser.current()!["bloodType"] = bloodTypeField.text!
        PFUser.current()?.saveInBackground {(success, error) in
            if success {
                print("blood Type saved")
            }
            else{
                print("error")
            }
        }
    }
    @IBAction func updateEmailButton(_ sender: Any) {
        PFUser.current()!["email"] = emailField.text!
        PFUser.current()?.saveInBackground {(success, error) in
            if success {
                print("Email saved")
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
