import UIKit

protocol DrawMenuViewDelegate: AnyObject {
    
    func didTapShirtButton()
    func didTapBrushButton()
    func didTapTextureButton()
    func didTapLayerButton()
}

class DrawMenuView: UIView {
    
    // MARK: - Properties
    
    var delegate: DrawMenuViewDelegate?
    
    private var state: State? {
        didSet {
            changeState()
        }
    }
    
    private let disableColor: UIColor = AppColors.additionalBackground.color.withAlphaComponent(0.22)
    
    // MARK: - Views
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [shirtButton, brushButton, textureButton, layerButton])
        
        view.spacing = 5
        view.distribution = .fillEqually
        
        view.layout.height.equal(to: 44)

        return view
    }()
    
    private lazy var shirtButton: UIButton = {
        let view = UIButton(type: .custom)

        view.setImage(.tshirtWhiteIcon, for: .normal)
        
        view.backgroundColor = disableColor
        view.layer.cornerRadius = 11
        view.layout.size.equal(to: .init(side: 44))
        
        view.addTarget(self, action: #selector(shirtsAction), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var brushButton: UIButton = {
        let view = UIButton(type: .custom)

        view.setImage(.brushWhiteIcon, for: .normal)
        
        view.backgroundColor = disableColor
        view.layer.cornerRadius = 11
        view.layout.size.equal(to: .init(side: 44))
        
        view.addTarget(self, action: #selector(brushAction), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var textureButton: UIButton = {
        let view = UIButton(type: .custom)

        view.setImage(.textureWhiteIcon, for: .normal)
        
        view.backgroundColor = disableColor
        view.layer.cornerRadius = 11
        view.layout.size.equal(to: .init(side: 44))
        
        view.addTarget(self, action: #selector(textureAction), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var layerButton: UIButton = {
        let view = UIButton(type: .custom)

        view.setImage(.layerWhiteIcon, for: .normal)
        
        view.backgroundColor = disableColor
        view.layer.cornerRadius = 11
        view.layout.size.equal(to: .init(side: 44))
        
        view.addTarget(self, action: #selector(layerAction), for: .touchUpInside)
        
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
        addSubview(containerView)
        containerView.layout.all.equal(to: self)
        
        state = .shirts
    }
    
    private func changeState() {
        let buttons = [shirtButton, brushButton, textureButton, layerButton]
        
        buttons.forEach({ $0.removeGradient() })
        
        switch state {
        case .shirts:
            shirtButton.applyGradient(with: .sunset, with: 11)
        case .brush:
            brushButton.applyGradient(with: .sunset, with: 11)
        case .texture:
            textureButton.applyGradient(with: .sunset, with: 11)
        case .layer:
            layerButton.applyGradient(with: .sunset, with: 11)
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @objc private func shirtsAction() {
        state = .shirts
        delegate?.didTapShirtButton()
    }
    
    @objc private func brushAction() {
        state = .brush
        delegate?.didTapBrushButton()
    }
    
    @objc private func textureAction() {
        state = .texture
        delegate?.didTapTextureButton()
    }
    
    @objc private func layerAction() {
        state = .layer
        delegate?.didTapLayerButton()
    }
}

extension DrawMenuView {
    
    enum State {
        
        case shirts
        case brush
        case texture
        case layer
    }
}
