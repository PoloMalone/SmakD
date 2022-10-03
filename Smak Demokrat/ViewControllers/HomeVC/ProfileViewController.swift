//
//  ProfileViewController.swift
//  Smak Demokrat
//
//  Created by Josef Jakobsson on 2022-10-03.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestore

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        table.delegate = self
        table.dataSource = self
    }
    


    @IBAction func logoutButtonTapped(_ sender: Any) {
        
            do { try Auth.auth().signOut() }
            catch { print("already logged out") }
        let startVC =
        self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.startViewController) as?
        ViewController
        
        self.view.window?.rootViewController = startVC
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    

}
extension ProfileViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Utapped me")
    }
}

extension ProfileViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}

