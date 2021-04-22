//
//  LoginViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/12.
//

import UIKit

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedIn()
    }
    
    private func checkLoggedIn(){
        FirebaseAuthModel.checkLoggedIn { (status) in
            status.moveToNextPage(self.navigationController, self)
        }
    }
}
