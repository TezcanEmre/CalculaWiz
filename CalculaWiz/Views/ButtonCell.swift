//
//  ButtonCell.swift
//  CalculaWiz
//
//  Created by Perseus on 24.05.2024.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    static let identifier = "ButtonCell"
    //MARK: - Varriables
    private(set) var CWButtonn : CWButton!
    
    //MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .regular)
        label.text = "Error"
        return label
    }()
    private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            return imageView
        }()
    //MARK: - Configure
    public func configure(with CWButtonn: CWButton) {
        self.CWButtonn = CWButtonn
        self.titleLabel.text = CWButtonn.title
        self.backgroundColor = CWButtonn.colors
        
        switch CWButtonn {
        case .ACButton, .plusMinus, .percentage, .divide, .multiply, .subtract, .add, .equals,.number, .decimal, .backspace:
            self.titleLabel.textColor = .buttonTextRenk }
        if let icon = CWButtonn.icon {
            self.iconImageView.image = icon
            self.iconImageView.isHidden = false
            self.titleLabel.isHidden = true
        } else {
            self.iconImageView.isHidden = true
            self.titleLabel.isHidden = false
        }

        self.setupUI()
        
    }
    public func setOperationSelected() {
        self.titleLabel.textColor = .buttonClickedRenk
        self.backgroundColor = .buttonTextRenk
    }
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(iconImageView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = self.frame.size.width/2
        NSLayoutConstraint.activate( [
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            self.iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.iconImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.iconImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ] )
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.removeFromSuperview()
        self.iconImageView.removeFromSuperview()
    }
    
}
