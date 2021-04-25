//
//  InputViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/13.
//

import UIKit

final class InputViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!{
        didSet{
            tableView.register(Cell.self, forCellReuseIdentifier: "cell")
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet private weak var decideButton: UIButton!{
        didSet{
            decideButton.addTarget(self, action: #selector(didTapDecideButton), for: .touchUpInside)
        }
    }
    private var keyWords = [String]()
    private var documentID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getKeywords()
    }
    
    private func getKeywords(){
        FirestoreModel.getWords { [weak self](result) in
            switch result{
            case .failure(let error):
                print("Error fetching document: \(error)")
            case .success(let data):
                self?.keyWords = data.keyWords
                self?.documentID = data.documentID
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func didTapDecideButton(){
        guard let inputWord = textField.text else { return }
        FirestoreModel.save(inputWord: inputWord)
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

extension InputViewController: UITableViewDelegate{
    
    //スワイプで削除するメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        keyWords.remove(at: indexPath.row)
        FirestoreModel.delete(documentID: documentID[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
