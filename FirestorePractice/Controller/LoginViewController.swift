//
//  LoginViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/12.
//

import UIKit
import FirebaseUI
import Firebase

final class LoginViewController: UIViewController {
    
    private let appleProvider = FUIOAuth.appleAuthProvider()
    private let twitterProvider = FUIOAuth.twitterAuthProvider()
    private let authUI = FUIAuth.defaultAuthUI()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAuthUI()
        checkLoggedIn()
    }
    
    private func setUpAuthUI(){
        guard let authUI = authUI else { return }
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIOAuth.appleAuthProvider(),
            FUIGoogleAuth(authUI: authUI),
            FUIFacebookAuth(authUI: authUI),
            FUIOAuth.twitterAuthProvider()
        ]
        authUI.providers = providers
    }
    
    private func checkLoggedIn(){
        Auth.auth().addStateDidChangeListener{ auth, user in
            if user != nil{
                print("success")
            } else {
                print("fail")
                self.login()
            }
        }
    }
    
    private func login() {
        let authViewController = authUI!.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: FUIAuthDelegate{
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard let error = error else { return }
        print(error.localizedDescription)
    }
}
