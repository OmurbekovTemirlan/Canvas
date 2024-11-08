import UIKit

protocol DrawTopViewDelegate: AnyObject {
    
    func didTapBackButton()
    func didTapRevertButton()
    func didTapForwardButton()
    func didTapSaveButton()
}

class DrawTopView: UIView {
    
    // MARK: - Properties
    
    var delegate: DrawTopViewDelegate?
    
    private let disableColor: UIColor = AppColors.textAndIcons.color.withAlphaComponent(0.3)
    private let enableColor: UIColor = AppColors.textAndIcons.color
    
    // MARK: - Views
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = AppColors.background.color
        view.layout.height.equal(to: 110)
        
        view.addSubview(backButton)
        backButton.layout.left.equal(to: view, offset: 16)
        backButton.layout.bottom.equal(to: view, offset: -19)
        
        view.addSubview(actionsStackView)
        actionsStackView.layout.centerX.equal(to: view, offset: -20)
        actionsStackView.layout.bottom.equal(to: view, offset: -19)
        
        view.addSubview(saveButton)
        saveButton.layout.right.equal(to: view, offset: -16)
        saveButton.layout.bottom.equal(to: view, offset: -19)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton(type: .custom)
        
        view.setImage(.backIcon, for: .normal)
        
        view.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var actionsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [revertButton, forwardButton])
        
        view.distribution = .fillEqually
        view.spacing = 6
        
        return view
    }()
    
    private lazy var revertButton: UIButton = {
        let view = UIButton(type: .custom)
        
        let tintedImage = UIImage.revertIcon.withRenderingMode(.alwaysTemplate)
        view.setImage(tintedImage, for: .normal)
        view.tintColor = disableColor
        
        view.backgroundColor = AppColors.additionalBackground.color
        view.layer.cornerRadius = 11
        view.layout.size.equal(to: .init(side: 44))
        
        view.addTarget(self, action: #selector(revertAction), for: .touchUpInside)
        
        view.isEnabled = false
        
        return view
    }()
    
    private lazy var forwardButton: UIButton = {
        let view = UIButton(type: .custom)
        
        let tintedImage = UIImage.forwardIcon.withRenderingMode(.alwaysTemplate)
        view.setImage(tintedImage, for: .normal)
        view.tintColor = disableColor
        
        view.backgroundColor = AppColors.additionalBackground.color
        view.layer.cornerRadius = 11
        view.layout.size.equal(to: .init(side: 44))
        
        view.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
        
        view.isEnabled = false
        
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("Done", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 12)
        
        view.layout.size.equal(to: .init(width: 73, height: 44))
        view.layer.cornerRadius = 16
        
        view.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
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
    }
    
    func update(canUndo: Bool, canRedo: Bool) {
        revertButton.isEnabled = canUndo
        forwardButton.isEnabled = canRedo
        
        revertButton.tintColor = canUndo ? enableColor : disableColor
        forwardButton.tintColor = canRedo ? enableColor : disableColor
    }
    
    // MARK: - Actions
    
    @objc private func backAction() {
        delegate?.didTapBackButton()
    }
    
    @objc private func revertAction() {
        delegate?.didTapRevertButton()
    }
    
    @objc private func forwardAction() {
        delegate?.didTapForwardButton()
    }
    
    @objc private func saveAction() {
        delegate?.didTapSaveButton()
    }
}
