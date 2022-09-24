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
class LoginViewController: UIViewController {
    
    
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
        
        getEmail()
//        let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//          guard let strongSelf = self else { return }
//          // ...
//        }
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
    
    func getEmail()
    {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("email")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
               
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //RETURN STRING VAR!!!!!!!!!!!!!!!!!!
}
