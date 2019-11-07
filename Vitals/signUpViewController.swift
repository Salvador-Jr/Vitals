//
//  signUpViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 11/6/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse

class signUpViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        usernameField.returnKeyType = .done
        
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        
        emailField.delegate = self
        emailField.returnKeyType = .done
        
        genderField.delegate = self
        genderField.returnKeyType = .done
        
        bloodTypeField.delegate = self
        bloodTypeField.returnKeyType = .done
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var bloodTypeField: UITextField!
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButton(_ sender: Any) {
//        let user = PFUser()

        if (((usernameField!.text) == "") || (passwordField!.text == "") || (emailField!.text == "") || (genderField!.text == "") || (bloodTypeField!.text) == "")
        {
            print("cant leave any blank")
        }
        else{
            let user = PFUser()
            user.username = usernameField.text!
            user.password = passwordField.text!
            user["Sex"] = genderField.text!
            user["bloodType"] = bloodTypeField.text!
            user["email"] = emailField.text!

            user.signUpInBackground { (success, error) in
                if success{
                    print("Created. Log in")
                }
                else{
                    print("error\(String(describing: error?.localizedDescription))")
                }
            }
        }
//        user.username = usernameField.text!
//        user.password = passwordField.text!
//        user["Sex"] = genderField.text!
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
