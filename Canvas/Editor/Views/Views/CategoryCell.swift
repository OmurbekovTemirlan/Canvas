




import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, nameLabel])
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        view.image = .empty24Icon
        view.clipsToBounds = true
        view.layout.size.equal(to: .init(side: 24))
        
        view.isHidden = true
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 12)
        view.textColor = AppColors.textAndIcons.color
        
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        backgroundColor = AppColors.additionalBackground.color
        layer.cornerRadius = 11
        
        addSubview(stackView)
        stackView.layout.all.equal(to: self, offset: .init(side: 10))
    }
    
    // MARK: - Setup Data
    
    func setupData(category: Template.Category, isSelected: Bool = false) {
        if category != .empty {
            nameLabel.text = category.name
            nameLabel.textColor = isSelected ? AppColors.mainText.color : AppColors.textAndIcons.color

            nameLabel.isHidden = false
            imageView.isHidden = true
        } else {
            nameLabel.text = nil
            imageView.tintColor = isSelected ? AppColors.mainText.color : AppColors.textAndIcons.color

            nameLabel.isHidden = true
            imageView.isHidden = false
        }
        
        imageView.tintColor = isSelected ? AppColors.mainText.color : AppColors.textAndIcons.color
        
        if isSelected {
            setupBorder()
        } else {
            removeGradient()
        }
    }
    
    private func setupBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 1
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        shapeLayer.path = path.cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = GradientStyle.sunset.colors
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
}
