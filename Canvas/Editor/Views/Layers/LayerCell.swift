//
//  LayerCell.swift
//  Canvas
//
//  Created by Apple on 28.10.2024.
//

import UIKit

protocol LayerCellDelegate: AnyObject {
    func eyeButton(at index: Int)
    func deleteButton(at index: Int)
    func dublicateButtton()
}

class LayerCell: UICollectionViewCell {
    static let identifier = "LayerCell"
    
    weak var delegate: LayerCellDelegate?
    
    var index: Int?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var vStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .fill
        view.alignment = .top
        
        view.addArrangedSubview(eyeButton)
        view.addArrangedSubview(dublicateButton)
        view.addArrangedSubview(deleteButton)
        return view
    }()
    
    lazy var eyeButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        view.tintColor = .white
        view.layout.height.equal(to: 30)
        view.layout.width.equal(to: 30)
        return view
    }()
    
    private lazy var dublicateButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "copy"), for: .normal)
        view.tintColor = .white
        view.layout.height.equal(to: 30)
        view.layout.width.equal(to: 30)
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "trush"), for: .normal)
        view.tintColor = .white
        view.addTarget(self, action: #selector(deleteButtonTap), for: .touchUpInside)
        view.layout.height.equal(to: 30)
        view.layout.width.equal(to: 30)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addTargets()
    }
    
    private func addTargets() {
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        dublicateButton.addTarget(self, action: #selector(dublicateButtonTap), for: .touchUpInside)
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        backgroundColor = .gray
        
        addSubview(imageView)
        imageView.layout.top.equal(to: self, offset: 8)
        imageView.layout.left.equal(to: self, offset: 3)
        imageView.layout.right.equal(to: self, offset: -40)
        imageView.layout.bottom.equal(to: self, offset: -5)
        
        addSubview(vStackView)
        vStackView.layout.top.equal(to: self, offset: 57)
        vStackView.layout.left.equal(to: imageView.layout.right, offset: 5)
        vStackView.layout.right.equal(to: self, offset: -5)
        vStackView.layout.height.equal(to: 110)
    }
    
    @objc
    private func eyeButtonTapped() {
        guard let index = index else { return }
        delegate?.eyeButton(at: index)
    }
    
    @objc
    private func dublicateButtonTap() {
        delegate?.dublicateButtton()
    }
    
    @objc
    private func deleteButtonTap() {
        if let index = index {
            delegate?.deleteButton(at: index)
        } else {
            print("Index not set")
        }
    }
    
    func configureEyeButton(isHidden: Bool) {
        let eyeIconName = isHidden ? "eye.slash.fill" : "eye.fill"
        eyeButton.setImage(UIImage(systemName: eyeIconName), for: .normal)
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
}
