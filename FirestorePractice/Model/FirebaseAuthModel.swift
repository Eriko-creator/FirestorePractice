//
//  FirebaseAuth.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/22.
//

import Foundation
import FirebaseUI
import Firebase

final class FirebaseAuthModel{
    
    static var uid = ""
    
    static func checkLoggedIn(completion: @escaping (LoginStatus)->Void){
        Auth.auth().addStateDidChangeListener{ auth, user in
            if user != nil{
                print("success")
                didLogin {
                    completion(.isAuthenticated)
                }
            } else {
                print("fail")
                completion(.userNotFound)
            }
        }
    }
    
    static func didLogin(completion: @escaping ()->Void){
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseAuthModel.uid = Auth.auth().currentUser?.uid ?? ""
        
        let docRef = db.collection("users").document("\(uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                completion()
            } else {
                //uidが存在しない場合firestoreに格納
                docRef.setData([
                    "createdAt": Timestamp(),
                    "userId": uid
                ])
                completion()
            }
        }
    }
    
    func makeAuthUI() -> FUIAuth?{
        guard let authUI = FUIAuth.defaultAuthUI() else {return nil}
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIOAuth.appleAuthProvider(),
            FUIGoogleAuth(authUI: authUI),
            FUIFacebookAuth(authUI: authUI),
            FUIOAuth.twitterAuthProvider()
        ]
        authUI.providers = providers
        return authUI
    }
}

enum LoginStatus{
    case isAuthenticated
    case userNotFound
    
    func moveToNextPage(_ viewController: UIViewController){
        switch self{
        case .isAuthenticated:
            viewController.performSegue(withIdentifier: "input", sender: nil)
        case .userNotFound:
            guard let auth = FirebaseAuthModel().makeAuthUI()?.authViewController() else { return }
            auth.modalPresentationStyle = .fullScreen
            viewController.present(auth, animated: true, completion: nil)
        }
    }
}
