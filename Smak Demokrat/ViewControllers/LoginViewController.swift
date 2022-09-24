//
//  LoginViewController.swift
//  Smak Demokrat
//
//  Created by Josef Jakobsson on 2022-09-18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestore
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
        
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUp()
    }
    
    
    func setUp()
    {
        //Hide error label
        errorLabel.alpha = 0
        
        //style buttons
        Utilities.styleTextField(userNameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //check if textfield is email or username
        let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if userName.contains("@")
        {
            //if its an email
            self.login(userName,pass)
            
        }else
        {
            //check if username exists
            checkUsername(userName) { (success) in
            if success == true {
                self.getEmail() { (email) in
                    
                    self.login(email, pass)
                }
            }else
            {
                //if no username exists
                self.printError("Användarnamnet existerar inte")
                self.passwordTextField.text = ""
            }
            }
        }
        
        
        


    }
    
    
    func login(_ emailString:String,_ pass:String)
    {
        //signing in user
        Auth.auth().signIn(withEmail: emailString, password: pass) { result, error in
            //if sign in not accepted
            if error != nil
            {
                self.printError("Användarnamn eller lösenord fel")
                self.passwordTextField.text = ""
            }else
            {
                // go to home screen
                let homeVC =
                self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as?
                HomeViewController
                
                self.view.window?.rootViewController = homeVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    
    func checkUsername(_ text:String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        collectionRef.whereField("username", isEqualTo: text).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["username"] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
    
    //get email by using username to be able to login
    func getEmail(completion: @escaping (String) -> Void)
    {
        let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let docRef = Firestore.firestore()
           .collection("users")
           .whereField("username", isEqualTo: userName)

        // Get data
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else if querySnapshot!.documents.count != 1 {
                print("More than one document or none")
            } else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                let email = dataDescription?["email"]
                completion(email as! String)
            }
        }
    }
    
    

    
    func printError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

