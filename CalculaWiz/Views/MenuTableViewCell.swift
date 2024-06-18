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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: UIImage, and label: String) {
        self.image_View.image = image
        self.labell.text = label
    }
    
    private func setupUI() {
        self.contentView.addSubview(image_View)
        self.contentView.addSubview(labell)
        image_View.translatesAutoresizingMaskIntoConstraints = false
        labell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image_View.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            image_View.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            image_View.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            image_View.widthAnchor.constraint(equalToConstant: 90),
            labell.leadingAnchor.constraint(equalTo: self.image_View.trailingAnchor, constant: 16),
            labell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            labell.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            labell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        
        ])
        
    }
    

}
