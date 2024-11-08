//
//  LayersView.swift
//  Canvas
//
//  Created by Apple on 28.10.2024.
//

import UIKit

protocol LayersViewDelegate: AnyObject {
    func didAddLayer()
}

class LayersView: UIView {

    private var layers: [UIImage] = []
    private var layerVisibility: [Bool] = []
    weak var delegate: LayersViewDelegate?
    weak var layerCellDelegate: LayerCellDelegate?
    
    // MARK: - Подпредставления
    
    private lazy var addLayerButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.tintColor = .white
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 40 / 2
        view.addTarget(self, action: #selector(addLayerTap), for: .touchUpInside)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 210, height: 230)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(LayerCell.self, forCellWithReuseIdentifier: LayerCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .gray
        return collectionView
    }()
    
    // MARK: - Инициализация
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        applyShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(addLayerButton)
        addLayerButton.layout.top.equal(to: self, offset: 10)
        addLayerButton.layout.centerX.equal(to: self)
        addLayerButton.layout.height.equal(to: 40)
        addLayerButton.layout.width.equal(to: 40)
        
        addSubview(collectionView)
        collectionView.layout.top.equal(to: addLayerButton.layout.bottom, offset: 5)
        collectionView.layout.left.equal(to: self)
        collectionView.layout.right.equal(to: self)
        collectionView.layout.bottom.equal(to: self, offset: -5)

    }
    
    private func applyShadow() {
        backgroundColor = .gray
        clipsToBounds = true
        isHidden = true
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.shadowColor = UIColor(red: 0/255, green: 54/255,
                                    blue: 105/255, alpha: alpha).cgColor
        layer.shadowOffset = CGSize(width: 0,
                                    height: 1)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 16
    }
    
    // MARK: - Методы
    
    func addLayerToCollectionView(_ layerImage: UIImage) {
        layers.append(layerImage)
        layerVisibility.append(false)
        collectionView.reloadData()
    }
    
    func deleteLayerFromCollectionView(at index: Int) {
        guard index >= 0 && index < layers.count else { return }
        
        layers.remove(at: index)
        layerVisibility.remove(at: index)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }) { _ in
            self.collectionView.reloadData()
        }
    }
    
    func updateLayerVisibility(_ visibility: [Bool]) {
        layerVisibility = visibility
        collectionView.reloadData() 
    }
    
    func updateLayerVisibility(at index: Int, isHidden: Bool) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? LayerCell else { return }
        cell.configureEyeButton(isHidden: isHidden)
        layerVisibility[index] = isHidden
    }
    
    // MARK: - @objc Методы
        @objc private func addLayerTap() {
            delegate?.didAddLayer()
        }
}

// MARK: - UICollectionViewDataSource

extension LayersView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LayerCell.identifier, for: indexPath) as? LayerCell else {
            return UICollectionViewCell()
        }
        
        let layerImage = layers[indexPath.item]
        cell.configure(with: layerImage)
        cell.index = indexPath.item
        if indexPath.item < layerVisibility.count {
            cell.configureEyeButton(isHidden: layerVisibility[indexPath.item])
        } else {
            cell.configureEyeButton(isHidden: false)
        }
        cell.delegate = layerCellDelegate
        return cell
    }
}
