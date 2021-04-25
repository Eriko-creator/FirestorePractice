//
//  Cell.swift
//  FirestorePractice
//
//  Created by 肥沼英里 on 2021/04/21.
//

import Foundation
import UIKit

final class Cell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
