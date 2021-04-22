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
    static var uid = ""

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
                self.didLogin()
            } else {
                print("fail")
                self.login()
            }
        }
    }
    
    private func login() {
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    private func didLogin(){
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        LoginViewController.uid = Auth.auth().currentUser?.uid ?? ""
        
        let docRef = db.collection("users").document("\(uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                //uidがfirestoreに存在する場合InputViewに飛ぶ
                self.moveToInputView()
            } else {
                //uidが存在しない場合firestoreに格納
                docRef.setData([
                    "createdAt": Timestamp(),
                    "userId": uid
                ])
                self.moveToInputView()
            }
        }
    }
    
    private func moveToInputView(){
        let input = InputViewController.makeFromStoryboard()
        self.navigationController?.pushViewController(input, animated: true)
    }
}

extension LoginViewController: FUIAuthDelegate{
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard let error = error else { return }
        print(error.localizedDescription)
    }
}
