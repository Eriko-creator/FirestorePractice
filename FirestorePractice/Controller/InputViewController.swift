//
//  InputViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/13.
//

import UIKit

final class InputViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var decideButton: UIButton!{
        didSet{
            decideButton.addTarget(self, action: #selector(didTapDecideButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc private func didTapDecideButton(){
        guard let inputWord = textField.text else { return }
        FirestoreModel.save(inputWord: inputWord) {
            let history = HistoryViewController()
            self.navigationController?.pushViewController(history, animated: true)
        }
    }
    
    static func makeFromStoryboard()->InputViewController{
        UIStoryboard(name: "InputView", bundle: nil).instantiateInitialViewController() as! InputViewController
    }
}
