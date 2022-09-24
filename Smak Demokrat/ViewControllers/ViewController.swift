//
//  ViewController.swift
//  Smak Demokrat
//
//  Created by Josef Jakobsson on 2022-09-18.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var LogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }

    func setUp()
    {
        //style buttons
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(LogInButton)
    }
 
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
    
    
    
    @IBAction func logInTapped(_ sender: Any) {
    }
    
    
    

}

