//
//  HistoryViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/19.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    private var tableView = UITableView()
    private var keyWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableView()
        getKeywords()
    }
    
    private func setUptableView(){
        tableView.frame = self.view.frame
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
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
}

extension HistoryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        keyWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = keyWords[indexPath.row]
        return cell
    }
}
