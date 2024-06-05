//
//  CWHeaderCell.swift
//  CalculaWiz
//
//  Created by Perseus on 24.05.2024.
//

import UIKit

class CWHeaderCell: UICollectionReusableView {
        static let identifier = "CWHeaderCell"
    //MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .textRenk
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 72, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(currentCalcText: String) {
        self.label.text = currentCalcText
    }
    
    
    //MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .bgRenk
        self.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
            
        ])
    }
    
    
    
}
