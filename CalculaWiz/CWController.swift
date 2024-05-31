//
//  ViewController.swift
//  CalculaWiz
//
//  Created by Perseus on 24.05.2024.
//

import UIKit

class CWController: UIViewController {
    // Varriables
    let viewModel: CWControllerViewModel
    
    
    //UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .bgRenk
        collectionView.register(CWHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CWHeaderCell.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)
        return collectionView
    } ()
    
    // Lifecycle
    init( viewModel: CWControllerViewModel = CWControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        self.setupUI()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.viewModel.updateView = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData() 
            }
            
        }
    }

    //UI Setup
    private func setupUI() {
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

        ])
        
    }

}
//CollectionView Methods
extension CWController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Section Header Cell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CWHeaderCell.identifier, for: indexPath)as? CWHeaderCell else {
            fatalError("failed to deque cwheadercell in cwcontroller")
        }
        header.configure(currentCalcText: self.viewModel.CWHeaderLabel)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Cell Spacing
        let totalCellHeight = view.frame.size.width
        let totalVerticalCellSpacing: CGFloat = CGFloat(10*4)
        // Screen Height
        let window = view.window?.windowScene?.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        let availableScreenHeight = view.frame.size.height - topPadding - bottomPadding
        // Calculate Headher Height
        let headherHeight = availableScreenHeight - totalCellHeight - totalVerticalCellSpacing
        return CGSize(width: view.frame.size.width, height: headherHeight)
        
        
        
    }
    
//Normal Cells (Buttons)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.CWButtonCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell else {
            fatalError("Failed to deque buttoncell")
        }
        let CWButton = self.viewModel.CWButtonCells[indexPath.row]
        cell.configure(with: CWButton)
        
        if let operation = self.viewModel.operation, self.viewModel.secondNumber == nil {
            if operation.title == CWButton.title {
                cell.setOperationSelected()
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/5 , height: view.frame.size.width/5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width/5)/3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = self.viewModel.CWButtonCells[indexPath.row]
        self.viewModel.didSelectButton(with: buttonCell)
    }
    
}

