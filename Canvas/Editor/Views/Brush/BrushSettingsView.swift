//
//  Untitled.swift
//  Canvas
//
//  Created by Apple on 23.10.2024.
//

import UIKit

protocol BrushSettingsViewDelegate: AnyObject {
    func brushSettingsView(_ settingsView: BrushSettingsView, didChangeOpacity opacity: CGFloat)
    func brushSettingsView(_ settingsView: BrushSettingsView, didChangeSize size: CGFloat)
    func brushSettingsView(_ settingsView: BrushSettingsView, didSelectTexture texture: TextureModel)
    func DidSelectedColorPickerButton()
    func backButton()
    func showColorPickerFromBrushSettingsView(_ view: BrushSettingsView)
}

class BrushSettingsView: UIView {
    
    weak var delegate: BrushSettingsViewDelegate?
    
    private lazy var titleScreenLabel: UILabel = {
        let view = UILabel()
        view.text = "WaterColor"
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        view.tintColor = .lightGray
        view.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var opacitylabel: UILabel = {
        let view = UILabel()
        view.text = "OPACITY"
        view.textColor = .black
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()
    
    private lazy var sizeSliderlabel: UILabel = {
        let view = UILabel()
        view.text = "SIZE"
        view.textColor = .black
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()
    
    private lazy var opacitySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        slider.addTarget(self, action: #selector(opacityChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var sizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 50
        slider.value = 10
        slider.addTarget(self, action: #selector(sizeChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var textureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextureCell.self, forCellWithReuseIdentifier: "TextureCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var colorPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 40 / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.addTarget(self, action: #selector(openColorPicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(backButton)
        backButton.layout.top.equal(to: view, offset: 10)
        backButton.layout.left.equal(to: view, offset: 20)
        backButton.layout.height.equal(to: 25)
        backButton.layout.width.equal(to: 25)
        view.addSubview(titleScreenLabel)
        titleScreenLabel.layout.top.equal(to: view, offset: 10)
        titleScreenLabel.layout.centerX.equal(to: view)
        view.addSubview(opacitylabel)
        opacitylabel.layout.top.equal(to: view, offset: 45)
        opacitylabel.layout.left.equal(to: view, offset: 20)
        view.addSubview(opacitySlider)
        opacitySlider.layout.top.equal(to: opacitylabel, offset: 20)
        opacitySlider.layout.left.equal(to: view, offset: 16)
        opacitySlider.layout.height.equal(to: 30)
        opacitySlider.layout.width.equal(to: 160)
        view.addSubview(sizeSliderlabel)
        sizeSliderlabel.layout.top.equal(to: view, offset: 45)
        sizeSliderlabel.layout.right.equal(to: view, offset: -140)
        view.addSubview(sizeSlider)
        sizeSlider.layout.top.equal(to: sizeSliderlabel, offset: 20)
        sizeSlider.layout.right.equal(to: view, offset: -16)
        sizeSlider.layout.height.equal(to: 30)
        sizeSlider.layout.width.equal(to: 160)
        view.addSubview(textureCollectionView)
        textureCollectionView.layout.top.equal(to: sizeSlider.layout.bottom, offset: 15)
        textureCollectionView.layout.left.equal(to: view, offset: 150)
        textureCollectionView.layout.right.equal(to: view, offset: -16)
        textureCollectionView.layout.height.equal(to: 60)
        view.addSubview(colorPickerButton)
        colorPickerButton.layout.top.equal(to: sizeSlider.layout.bottom, offset: 25)
        colorPickerButton.layout.left.equal(to: view, offset: 100)
        colorPickerButton.layout.height.equal(to: 40)
        colorPickerButton.layout.width.equal(to: 40)
        return view
    }()
    
    private var texturesIm: [TextureModel] = [
        TextureModel(textures: UIImage(named: "texture1")!),
        TextureModel(textures: UIImage(named: "texture2")!),
        TextureModel(textures: UIImage(named: "texture3")!),
        TextureModel(textures: UIImage(named: "texture4")!),
        TextureModel(textures: UIImage(named: "texture5")!),
        TextureModel(textures: UIImage(named: "texture6")!),
        TextureModel(textures: UIImage(named: "texture7")!),
        TextureModel(textures: UIImage(named: "texture8")!)
    ]
    
    private var selectedIndexPath: IndexPath?
    private var selectedTexture: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        applyShadow()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.layout.all.equal(to: self)
    }
    
    private func applyShadow() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor(red: 0/255, green: 54/255,
                                    blue: 105/255, alpha: alpha).cgColor
        layer.shadowOffset = CGSize(width: 0,
                                    height: 1)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 16
        layer.masksToBounds = false
        clipsToBounds = false
        isHidden = true
    }
    
    func updateButtonColor(_ color: UIColor) {
            colorPickerButton.backgroundColor = color
        }
    
    @objc private func backButtonTapped() {
        delegate?.backButton()
    }
    
    @objc private func opacityChanged() {
        let opacityValue = CGFloat(opacitySlider.value)
        delegate?.brushSettingsView(self, didChangeOpacity: opacityValue)
    }
    
    @objc private func sizeChanged() {
        let sizeValue = CGFloat(sizeSlider.value)
        delegate?.brushSettingsView(self, didChangeSize: sizeValue)
    }
    
    @objc private func openColorPicker() {
        delegate?.DidSelectedColorPickerButton()
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedCell = gesture.view as? TextureCell,
              let indexPath = textureCollectionView.indexPath(for: tappedCell) else { return }
        
        let selectedTextureModel = texturesIm[indexPath.row]
            
        selectedTexture = selectedTextureModel.textures
        
        delegate?.showColorPickerFromBrushSettingsView(self)
    }
    
}

// MARK: - UICollectionViewDataSource и UICollectionViewDelegate

extension BrushSettingsView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texturesIm.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextureCell", for: indexPath) as! TextureCell
        
        cell.configure(item: texturesIm[indexPath.row])
    
        if indexPath == selectedIndexPath {
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 2.0
            cell.layer.cornerRadius = 8
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0.0
        }
        
        cell.gestureRecognizers?.forEach(cell.removeGestureRecognizer)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTapGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath) as? TextureCell
            previousCell?.layer.borderColor = UIColor.clear.cgColor
        }
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as? TextureCell
        selectedCell?.layer.borderColor = UIColor.blue.cgColor
        selectedCell?.layer.borderWidth = 2.0
        selectedCell?.layer.cornerRadius = 8

        selectedIndexPath = indexPath
        
        let selectedTexture = texturesIm[indexPath.row]
        delegate?.brushSettingsView(self, didSelectTexture: selectedTexture)
    }
}
