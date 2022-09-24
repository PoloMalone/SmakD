//
//  SignUpViewController.swift
//  Smak Demokrat
//
//  Created by Josef Jakobsson on 2022-09-18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestore
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
        
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
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(userNameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPassTextField)
        Utilities.styleFilledButton(signUpButton)
                
    }
    
    func validateTextFields() -> String?
    {
        //check if all textfields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || confirmPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Fyll i alla fält"
        }
        
        //check if password is safe enough
        let cleanPass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.isPasswordValid(cleanPass)
        {
            return "Lösenordet måste bestå av åtminstone 8 karaktärer med minst ett nummer och ett särkilt tecken"
        }
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            != confirmPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            return "Lösenorden måste matcha"
        }
        
        
        
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
   
    let db = Firestore.firestore()
    //validate textfields
 
    let error = validateTextFields()
    if error != nil
    {
        printError(error!)
    }else
    {
        //cleaned strings
        let first = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let last = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     
        //check username if it already exists, if not, continue to check email
        checkUsername(userName) { (success) in
        if success == true {
            print("Username is taken")
            self.printError("Användarnamnet existerar redan")
        }else
        {
        
        
        //create user
        Auth.auth().createUser(withEmail: email, password: pass) { result, err in
            //check errors
            if err != nil
            {
                //error was found
                //email already exists
                self.printError("Konto med angivet email finns redan")
                
            }else
            {
                // Add a new document with a generated ID
                var ref: DocumentReference? = nil
                ref = db.collection("users").addDocument(data: [
                    "first": first,
                    "last": last,
                    "username": userName,
                    "email": email,
                    "pass": pass,
                    "uid": result!.user.uid
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                //go to home screen
                self.goToVc()
            }
        }
        }
        }
    }
    }

    func printError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func goToVc()
    {
        let homeVC =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


   /**
    * Called when the user click on the view (outside the UITextField).
    */
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
