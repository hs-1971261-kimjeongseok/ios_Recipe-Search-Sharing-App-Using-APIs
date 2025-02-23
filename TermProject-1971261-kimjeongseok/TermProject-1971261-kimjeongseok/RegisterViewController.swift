//
//  RegisterViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by b2u on 2024/05/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTextField.text, let pwd = pwdTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: pwd) { (authResult, error) in
                    if let error = error {
                        print("Sign up failed -  \(error.localizedDescription)")
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
    }
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
