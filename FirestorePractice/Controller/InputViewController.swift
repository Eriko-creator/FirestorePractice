//
//  InputViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/13.
//

import UIKit

final class InputViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(Cell.self, forCellReuseIdentifier: "cell")
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var decideButton: UIButton!{
        didSet{
            decideButton.addTarget(self, action: #selector(didTapDecideButton), for: .touchUpInside)
        }
    }
    private var keyWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getKeywords()
    }
    
    private func getKeywords(){
        FirestoreModel.getWords { [weak self](result) in
            switch result{
            case .failure(let error):
                print("Error fetching document: \(error)")
            case .success(let keyWordArray):
                self?.keyWords = keyWordArray
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func didTapDecideButton(){
        guard let inputWord = textField.text else { return }
        FirestoreModel.save(inputWord: inputWord)
    }
    
    static func makeFromStoryboard()->InputViewController{
        UIStoryboard(name: "InputView", bundle: nil).instantiateViewController(withIdentifier: "input") as! InputViewController
    }
}

extension InputViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        keyWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = keyWords[indexPath.row]
        return cell
    }
}
