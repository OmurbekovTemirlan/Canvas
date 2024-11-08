import UIKit

protocol DrawTemplatesDelegate {
    
    func didSelectTemplate(_ view: DrawTemplatesView, template: Template)
}

class DrawTemplatesView: UIView {
    
    // MARK: - Properties
    
    var delegate: DrawTemplatesDelegate?
    
    private var templates: [Template] = [] {
        didSet {
            itemsSet = Dictionary(grouping: templates) { $0.category }
        }
    }
    
    private var itemsSet: [Template.Category: [Template]] = [:]
    
    private let categories = StorageManager.shared.getCategories()
    
    private var selectedItemIndexPath: IndexPath? = IndexPath(row: 0, section: 0)
    private var selectedCategoryIndexPath: IndexPath? = IndexPath(row: 0, section: 0)
    
    // MARK: - Views
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [itemsCollectionView, categoryCollectionView])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 12
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(horizontal: .zero, vertical: 12)
        return view
    }()
    
    private lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(ItemCategoryCell.self, forCellWithReuseIdentifier: "ItemCategoryCell")
        return view
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        templates = StorageManager.shared.getTemplates()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        templates = StorageManager.shared.getTemplates()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        backgroundColor = AppColors.background.color
        containerView.layout.height.equal(to: 141)
        addSubview(containerView)
        containerView.layout.all.equal(to: self)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DrawTemplatesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemsCollectionView {
            return templates.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCategoryCell", for: indexPath) as? ItemCategoryCell
            let isSelected = indexPath == selectedItemIndexPath
            cell?.setupData(
                template: templates[indexPath.row],
                isSelected: isSelected
            )
            return cell ?? UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell
        let isSelected = indexPath == selectedCategoryIndexPath
        cell?.setupData(
            category: categories[indexPath.row],
            isSelected: isSelected
        )
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == itemsCollectionView {
            return .init(side: 52)
        }
              
        let category = categories[indexPath.row]
        if category != .empty {
            let textSize = category.name.size(forFont: UIFont.systemFont(ofSize: 12), maxWidth: 150)
            return .init(width: textSize.width + 20, height: 44) // 20 - отступы внутри ячейки
        }
    
        return .init(side: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemsCollectionView {
            selectedItemIndexPath = indexPath
            delegate?.didSelectTemplate(self, template: templates[indexPath.row])
            collectionView.reloadData()
        } else {
            selectedCategoryIndexPath = indexPath
            let selectedCategory = categories[indexPath.row]
            
            if selectedCategory == .empty {
                templates = StorageManager.shared.getTemplates()
            } else {
                templates = [.empty] + (itemsSet[selectedCategory] ?? [])
            }
            
            selectedItemIndexPath = IndexPath(row: 0, section: 0)
            
            itemsCollectionView.reloadData()
            categoryCollectionView.reloadData()
        }
    }
}
