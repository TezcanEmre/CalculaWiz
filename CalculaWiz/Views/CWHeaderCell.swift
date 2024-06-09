import UIKit

class CWHeaderCell: UICollectionReusableView {
    static let identifier = "CWHeaderCell"
    var viewModel: CWControllerViewModel?
    //MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .textRenk
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 72, weight: .regular)
        label.text = "Error"
        return label
    }()
    //MARK: - Menu VC Button
        let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bgRenk
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        let largeBoldDoc = UIImage(systemName: "list.dash", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = .textRenk
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    @objc func menuButtonClicked() {
        viewModel?.menuButtonTapped()
    }
    
    
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
        
        // Add subviews
        self.addSubview(label)
        self.addSubview(button)
        
        // Set up Auto Layout
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            self.label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            // Button constraints
            self.button.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
            self.button.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 10),
            self.button.widthAnchor.constraint(equalToConstant: 60),
            self.button.heightAnchor.constraint(equalToConstant: 30)
        ])
        button.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
    }
}
