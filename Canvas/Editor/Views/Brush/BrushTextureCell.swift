//
//  BrushTextureCell.swift
//  Canvas
//
//  Created by Apple on 23.10.2024.
//

import UIKit

struct TextureModel {
    var textures: UIImage
}

class TextureCell: UICollectionViewCell {

    private lazy var textureImages: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        clipsToBounds = true
        
        addSubview(textureImages)
        textureImages.layout.all.equal(to: self)
    }
    
    func configure(item: TextureModel) {
        textureImages.image = item.textures
    }
}
