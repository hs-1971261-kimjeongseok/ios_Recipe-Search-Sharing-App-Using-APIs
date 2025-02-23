//
//  LoginViewController.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by b2u on 2024/05/23.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBAction func registerClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    @IBAction func loginActionPerformed(_ sender: Any) {
        guard let email = emailTextField.text, let pwd = pwdTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: pwd) { (authResult, error) in
                    if let error = error {
                        print("Login failed - \(error.localizedDescription)")
                        return
                    }
                    // 로그인 성공 후 메인 화면으로 이동
                    self.performSegue(withIdentifier: "toMap", sender: self)
                }
    }
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toMap" {
                if let destinationVC = segue.destination as? UITabBarController {
                    destinationVC.isModalInPresentation = true
                }
            }
        }
}
