import UIKit

class ItemCategoryCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layout.size.equal(to: .init(side: 24))
        
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
        
        addSubview(imageView)
        imageView.layout.all.equal(to: self, offset: .init(side: 10))
    }
    
    // MARK: - Setup Data
    
    func setupData(template: Template, isSelected: Bool = false) {
        imageView.image = template.image
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
