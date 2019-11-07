//
//  LoginViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 9/10/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        usernameField.delegate = self
        usernameField.returnKeyType = .done
        passwordField.returnKeyType = .done
        // Do any additional setup after loading the view.
    }
    @IBAction func onSignIn(_ sender: Any) {
        let user = PFUser()
        let username = usernameField.text!
        let password = passwordField.text!
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil
            {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else
            {
                print("Error \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        print("sign up selected")
//        let user = PFUser()
//        user.username = usernameField.text!
//        user.password = passwordField.text!
//        user.signUpInBackground { (success, error) in
//            if success{
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
//            }
//            else{
//                print("error\(String(describing: error?.localizedDescription))")
//            }
//        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("in HEREEEEE!!")
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
