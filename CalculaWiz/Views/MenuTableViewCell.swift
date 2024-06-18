//
//  MenuTableViewCell.swift
//  CalculaWiz
//
//  Created by Perseus on 10.06.2024.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    static let identifier = "MenuTableViewCell"
    private let image_View: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(systemName: "questionmark")
        imgView.tintColor = .label
        return imgView
    }()
    
    private let labell: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24)
        label.text = "error"
        return label
    }()
    

}
