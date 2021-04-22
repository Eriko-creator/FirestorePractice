//
//  InputViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/13.
//

import UIKit
import FirebaseFirestore

final class InputViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var decideButton: UIButton!{
        didSet{
            decideButton.addTarget(self, action: #selector(didTapDecideButton), for: .touchUpInside)
        }
    }
    static var collectionRef: CollectionReference{
        get{
            let db = Firestore.firestore()
            let uid = LoginViewController.uid
            return db.collection("users").document("\(uid)").collection("inputWord")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc private func didTapDecideButton(){
        saveInputWord()
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
    
    //入力したキーワードをfirestore上に保存する
    private func saveInputWord(){
        guard let keyWord = textField.text else { return }
        InputViewController.collectionRef.document("\(keyWord)").setData([
            "date": Timestamp(),
            "keyWord": "\(keyWord)"
        ]) { err in
            if let error = err{
                print("Error adding document: \(error)")
            }else{
                print("Successfully document added")
            }
        }
    }
    
    static func makeFromStoryboard()->InputViewController{
        UIStoryboard(name: "InputView", bundle: nil).instantiateInitialViewController() as! InputViewController
    }
}
