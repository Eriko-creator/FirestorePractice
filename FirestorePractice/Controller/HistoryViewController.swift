//
//  HistoryViewController.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/19.
//

import UIKit
import FirebaseFirestore

final class HistoryViewController: UIViewController {
    
    private var tableView = UITableView()
    static var documentCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableView()
    }
    
    private func setUptableView(){
        tableView.frame = self.view.frame
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
}

extension HistoryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        InputViewController.collectionRef.getDocuments { (querySnapshot, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                guard let querySnapshot = querySnapshot else { return }
                HistoryViewController.documentCount = querySnapshot.count
                print("query:\(querySnapshot.count)")
                self.tableView.reloadData()
            }
        }
        return HistoryViewController.documentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        InputViewController.collectionRef
            .getDocuments(completion: { (querySnapshot, err) in
            if let err = err{
                print(err)
            }else {
                guard let document = querySnapshot?.documents[indexPath.row] else { return }
                cell.textLabel?.text = document.data()["keyWord"] as? String
            }
        })
        return cell
    }
}
