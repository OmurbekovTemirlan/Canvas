//
//
//
//
//

import UIKit

class EditorController: UIViewController {
    
    // MARK: - Properties
    
    private var templateLayers: [CALayer] = []
    private var selectedTexture: UIImage?
    private var selectedColor: UIColor = .black
    private var textureOpacity: CGFloat = 1.0


    // MARK: - Views
    
    private lazy var canvasView: CanvasView = {
        let view = CanvasView()

        view.delegate = self
        
        return view
    }()
    
    private lazy var topView: DrawTopView = {
        let view = DrawTopView()
            
        view.delegate = self
        
        return view
    }()
    
    private lazy var menuView: DrawMenuView = {
        let view = DrawMenuView()
        
        view.delegate = self
        
        return view
    }()
    
    private lazy var settingStackView: UIStackView = {
        let view = UIStackView()
        
        view.addArrangedSubview(templatesView)
        
        return view
    }()
    
    private lazy var templatesView: DrawTemplatesView = {
        let view = DrawTemplatesView()
        
        view.delegate = self
        
        view.isHidden = true

        return view
    }()
    
    private lazy var brushSettingsView: BrushSettingsView = {
        let view = BrushSettingsView()
        
        view.delegate = self
        
        view.isHidden = true
        
        return view
    }()
    
    private lazy var layersView: LayersView = {
        let view = LayersView()
        view.delegate = self
        view.layerCellDelegate = self
        view.isHidden = true
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        view.addSubview(canvasView)
       
        view.addSubview(topView)
        topView.layout.all.except(.bottom).equal(to: view)
        
        view.addSubview(menuView)
        menuView.layout.top.equal(to: topView.layout.bottom, offset: 16)
        menuView.layout.right.equal(to: view, offset: -16)
        
        view.addSubview(settingStackView)
        settingStackView.layout.all.except(.top).equal(to: view)
        
        view.addSubview(brushSettingsView)
        brushSettingsView.layout.bottom.equal(to: canvasView.layout.bottom, offset: 0)
        brushSettingsView.layout.right.equal(to: view)
        brushSettingsView.layout.left.equal(to: view)
        brushSettingsView.layout.height.equal(to: 200)
        
        view.addSubview(layersView)
        layersView.layout.top.equal(to: menuView.layout.bottom, offset: 5)
        layersView.layout.left.equal(to: canvasView.layout.left, offset: 170)
        layersView.layout.right.equal(to: canvasView.layout.right, offset: -15)
        layersView.layout.bottom.equal(to: canvasView.layout.bottom, offset: -60)
        
        canvasView.layout.top.equal(to: topView.layout.bottom)
        canvasView.layout.all.except(.top).equal(to: view)
    }
    
    // MARK: - Methods
    
    func removeAllTemplateLayers() {
        templateLayers.forEach { $0.removeFromSuperlayer() }
        templateLayers.removeAll()
    }
    
    private func showColorPicser(picser: UIColorPickerViewController) {
        picser.delegate = self
        picser.modalPresentationStyle = .popover

        if let popoverController = picser.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = []
        }
        present(picser, animated: true, completion: nil)
    }
    
    func applyColorToTexture(_ texture: UIImage, color: UIColor) -> UIImage? {
        let rect = CGRect(origin: .zero, size: texture.size)

        UIGraphicsBeginImageContextWithOptions(texture.size, false, texture.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        texture.draw(in: rect)
        context.setBlendMode(.sourceAtop)
        color.setFill()
        context.fill(rect)
        
        let coloredTexture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredTexture
    }
    
    func applyOpacityToTexture(_ texture: UIImage, opacity: CGFloat) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(texture.size, false, texture.scale)
            guard let context = UIGraphicsGetCurrentContext(), let cgImage = texture.cgImage else {
                UIGraphicsEndImageContext()
                return nil
            }
        
            context.setAlpha(opacity)
            context.draw(cgImage, in: CGRect(origin: .zero, size: texture.size))
            
            let transparentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return transparentImage
        }
}

// MARK: - CanvasViewDelegate

extension EditorController: CanvasViewDelegate {
    func didDraw(_ view: CanvasView, canUndo: Bool, canRedo: Bool) {
        topView.update(canUndo: canUndo, canRedo: canRedo)
    }
    
    
    func didCreateSnapshot(_ view: CanvasView, snapshot: UIImage) {
        layersView.addLayerToCollectionView(snapshot)
    }
}

// MARK: - DrawTopViewDelegate

extension EditorController: DrawTopViewDelegate {
    
    func didTapBackButton() {
        dismiss(animated: true)
    }
    
    func didTapRevertButton() {
        canvasView.undoLastLine()
    }
    
    func didTapForwardButton() {
        canvasView.redoLastLine()
    }
    
    func didTapSaveButton() {

    }
}

// MARK: - LayersViewDelegate

extension EditorController: LayersViewDelegate {
    func didAddLayer() {
        guard !canvasView.currentLines.isEmpty else {return}
        
        canvasView.addLayer(canvasView.currentLines)
        canvasView.lines.append(contentsOf: canvasView.currentLines)
        
        let containerLayer = canvasView.createLayer(from: canvasView.currentLines)
        if let snapshot = canvasView.snapshot(of: containerLayer) {
            layersView.addLayerToCollectionView(snapshot)
        } else {
            print("Failed to create snapshot of current lines")
        }
        
        canvasView.currentLines.removeAll()
        canvasView.setNeedsDisplay()
    }
}

// MARK: - LayerCellDelegate

extension EditorController: LayerCellDelegate {
   
    func eyeButton(at index: Int) {
        guard index >= 0 && index < canvasView.layers.count else {
            print("Index out of range")
            return
        }
        
        canvasView.toggleVisibility(at: index)
        let isHidden = canvasView.layers[index].first?.isHidden ?? false
        layersView.updateLayerVisibility(at: index, isHidden: isHidden)
        canvasView.setNeedsDisplay()
    }

    func deleteButton(at index: Int) {
        canvasView.deleteLayer(at: index)
        layersView.deleteLayerFromCollectionView(at: index)
        canvasView.setNeedsDisplay()
    }
    
    func dublicateButtton() {
        guard let lastLayerLines = canvasView.layers.last else {
            print("No layer to duplicate")
            return
        }
        let duplicatedLines = lastLayerLines.map { line -> Line in
            var newLine = line
            newLine.points = line.points.map { $0 }
            return newLine
        }

        let duplicatedLayer = canvasView.createLayer(from: duplicatedLines)
        canvasView.layer.addSublayer(duplicatedLayer)

        if let snapshot = canvasView.snapshot(of: duplicatedLayer) {
            layersView.addLayerToCollectionView(snapshot)
        } else {
            print("Failed to create snapshot of duplicated layer")
        }

        canvasView.layers.append(duplicatedLines)
        canvasView.isLayerHidden.append(false)
        canvasView.setNeedsDisplay()
    }
}

// MARK: - BrushSettingsViewDelegate

extension EditorController: BrushSettingsViewDelegate {
    func showColorPickerFromBrushSettingsView(_ view: BrushSettingsView) {
        let picserColor = UIColorPickerViewController()
        showColorPicser(picser: picserColor)
    }
    
    func backButton() {
        brushSettingsView.isHidden = true
    }
    
    func DidSelectedColorPickerButton() {
        let colorPicker = UIColorPickerViewController()
        showColorPicser(picser: colorPicker)
        colorPicker.selectedColor = selectedColor
        canvasView.setLineColor(selectedColor)
    }
    
    func brushSettingsView(_ settingsView: BrushSettingsView, didSelectTexture texture: TextureModel) {
        selectedTexture = texture.textures
        canvasView.setBrushImage(selectedTexture)
    }
    
    func brushSettingsView(_ settingsView: BrushSettingsView, didChangeOpacity opacity: CGFloat) {
        if selectedTexture == nil {
            let transparentColor = selectedColor.withAlphaComponent(opacity)
            canvasView.setLineColor(transparentColor)
        }
        else if let texture = selectedTexture {
            let transparentTexture = applyOpacityToTexture(texture, opacity: opacity)
            canvasView.setBrushImage(transparentTexture)
        }
    }
    
    func brushSettingsView(_ settingsView: BrushSettingsView, didChangeSize size: CGFloat) {
        canvasView.setBrushSize(size)
    }
    
}

// MARK: - DrawMenuViewDelegate

extension EditorController: DrawMenuViewDelegate {
    
    func didTapShirtButton() {
        templatesView.isHidden = false
        brushSettingsView.isHidden = true
        layersView.isHidden = true
    }
    
    func didTapBrushButton() {
        templatesView.isHidden = true
        brushSettingsView.isHidden = false
        layersView.isHidden = true
    }
    
    func didTapTextureButton() {
        templatesView.isHidden = true
        brushSettingsView.isHidden = true
        layersView.isHidden = true
    }
    
    func didTapLayerButton() {
        templatesView.isHidden = true
        brushSettingsView.isHidden = true
        layersView.isHidden = false
    }
}

// MARK: - DrawTemplatesDelegate

extension EditorController: DrawTemplatesDelegate {
    
    func didSelectTemplate(_ view: DrawTemplatesView, template: Template) {
        canvasView.setImage(template.image)
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension EditorController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        brushSettingsView.updateButtonColor(selectedColor)
        
        if let texture = selectedTexture, let coloredTexture = applyColorToTexture(texture, color: selectedColor) {
            canvasView.setBrushImage(coloredTexture)
        }
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        
        if let texture = selectedTexture, let coloredTexture = applyColorToTexture(texture, color: selectedColor) {
            canvasView.setBrushImage(coloredTexture)
        } else {
            selectedTexture = nil
            canvasView.setBrushImage(nil)
            canvasView.setLineColor(selectedColor)
        }
    }

}
