//
//  CustomCell.swift
//  iOSEngineerCodeCheck
//
//  Created by zunda on 2020/06/30.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//
import UIKit

class CustomCell: UITableViewCell{
    func setCell(_ cell: UITableViewCell, _ movie: [String: Any]) -> Void{
        cell.textLabel?.text = movie["title"] as? String ?? ""
    }
}
