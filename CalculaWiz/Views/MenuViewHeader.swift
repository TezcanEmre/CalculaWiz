//
//  MenuViewHeader.swift
//  CalculaWiz
//
//  Created by Perseus on 18.06.2024.
//

import UIKit

class MenuViewHeader: UIView {
    private let image_View: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "LaunchScreen")
        imgView.tintColor = .bgRenk
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(image_View)
        image_View.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image_View.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image_View.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image_View.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
