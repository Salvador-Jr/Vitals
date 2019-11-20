//
//  ForgotPasswordViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 11/7/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        emailField.returnKeyType = .done
        // Do any additional setup after loading the view.
    }
    @IBAction func submitRequestButton(_ sender: Any) {
        PFUser.requestPasswordResetForEmail(inBackground: emailField.text!)

    }
    
    @IBAction func cancelBuuton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
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
