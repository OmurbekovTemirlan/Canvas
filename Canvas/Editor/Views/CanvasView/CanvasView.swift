import UIKit

struct Line: Equatable {
    var points: [CGPoint]
    var width: CGFloat
    var color: UIColor
    var texture: UIImage?
    var isHidden: Bool = false

    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.points == rhs.points &&
        lhs.width == rhs.width &&
        lhs.color == rhs.color &&
        lhs.texture == rhs.texture &&
        lhs.isHidden == rhs.isHidden
    }
}


class CanvasView: UIView {
    
    weak var delegate: CanvasViewDelegate?
    
       var layers: [[Line]] = []
       var isLayerHidden: [Bool] = []
       var lines: [Line] = []
       var currentLines: [Line] = []
       private var undoneLines: [Line] = []
       var currentLine: Line?
       private var brushWidth: CGFloat = 5.0
       var lineColor: UIColor = .blue
       private let gridSize: CGFloat = 25.0
       var imageLayer: UIImage?
       var brushImage: UIImage?
       private var brushPreviewLayer: CALayer?
       private var brushPreviewPosition: CGPoint?
    
    private var isPressureSensitive: Bool {
        return traitCollection.forceTouchCapability == .available
    }
    
    var canUndo: Bool {
        return !lines.isEmpty
    }
    
    var canRedo: Bool {
        return !undoneLines.isEmpty
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        setNeedsLayout()
    }
    
}

extension CanvasView {
    
    override func draw(_ rect: CGRect) {
           guard let context = UIGraphicsGetCurrentContext() else {return}

           drawGrid(in: rect, context: context)
           
           if let image = imageLayer {
               drawImage(in: rect, image: image)
           }

        for (_, layer) in layers.enumerated() {
            for (_, line) in layer.enumerated() where !line.isHidden {
                   drawLine(line, in: context)
               }
           }
           
        for (_, line) in currentLines.enumerated() where !line.isHidden {
               drawLine(line, in: context)
           }

           if let currentLine = currentLine, !currentLine.isHidden {
               drawLine(currentLine, in: context)
           }
       }

    private func drawLine(_ line: Line, in context: CGContext) {
        context.saveGState()
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(line.width)
        
        if let texture = line.texture {
            let patternColor = UIColor(patternImage: texture)
            context.setStrokeColor(patternColor.cgColor)
        } else {
            context.setStrokeColor(line.color.cgColor)
        }
        
        guard let firstPoint = line.points.first else { return }
        context.move(to: firstPoint)
        for point in line.points.dropFirst() {
            context.addLine(to: point)
        }
        
        context.strokePath()
        context.restoreGState()
        setNeedsLayout()
    }
    
    private func drawGrid(in rect: CGRect, context: CGContext) {
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        
        for x in stride(from: 0, to: rect.width, by: gridSize) {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        for y in stride(from: 0, to: rect.height, by: gridSize) {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }
        context.strokePath()
    }
    
    private func drawImage(in rect: CGRect, image: UIImage) {
        let imageSize = image.size
        let imageOrigin = CGPoint(x: (rect.width - imageSize.width) / 2, y: (rect.height - imageSize.height) / 2)
        image.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        setNeedsLayout()
    }
    
    private func drawBrushImage(at point: CGPoint, in context: CGContext, with texture: UIImage, width: CGFloat) {
        let brushSize = CGSize(width: width, height: width)
        let imageRect = CGRect(origin: CGPoint(x: point.x - brushSize.width / 2, y: point.y - brushSize.height / 2), size: brushSize)
        texture.draw(in: imageRect)
        setNeedsLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        let width = isPressureSensitive ? touch.force / touch.maximumPossibleForce * 10 + 1 : brushWidth
        
        currentLine = Line(points: [point], width: width, color: lineColor, texture: brushImage)
        moveBrushPreview(to: point)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        currentLine?.points.append(point)
        moveBrushPreview(to: point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentLine = currentLine else { return }
        
        currentLines.append(currentLine)
        self.currentLine = nil
        setNeedsDisplay()
    }
    
}

extension CanvasView {
    private func updateBrushPreviewLayer() {
        if brushPreviewLayer == nil {
            brushPreviewLayer = CALayer()
            brushPreviewLayer?.masksToBounds = true
            layer.addSublayer(brushPreviewLayer!)
            
            let centerX = bounds.width / 2
            let centerY = bounds.height / 2
            brushPreviewPosition = CGPoint(x: centerX, y: centerY)
            brushPreviewLayer?.position = brushPreviewPosition ?? CGPoint(x: centerX, y: centerY)
        }
    
        if let texture = brushImage {
            brushPreviewLayer?.backgroundColor = UIColor.clear.cgColor
            brushPreviewLayer?.contents = texture.cgImage
        } else {
            brushPreviewLayer?.contents = nil
            brushPreviewLayer?.backgroundColor = lineColor.cgColor
        }
        brushPreviewLayer?.frame = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: brushWidth, height: brushWidth)
        )
        brushPreviewLayer?.cornerRadius = brushWidth / 2
        
        if let position = brushPreviewPosition {
            brushPreviewLayer?.position = position
        }
        setNeedsLayout()
    }
    
    private func moveBrushPreview(to point: CGPoint) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        brushPreviewPosition = point
        brushPreviewLayer?.position = point
        CATransaction.commit()
        setNeedsLayout()
    }
}

extension CanvasView {
    func undoLastLine() {
        guard canUndo else { return }
        let lastLine = lines.removeLast()
        undoneLines.append(lastLine)
        setNeedsDisplay()
        
        delegate?.didDraw(self, canUndo: canUndo, canRedo: canRedo)
    }
    func redoLastLine() {
        guard canRedo else { return }
        let lastUndoneLine = undoneLines.removeLast()
        lines.append(lastUndoneLine)
        setNeedsDisplay()
        
        delegate?.didDraw(self, canUndo: canUndo, canRedo: canRedo)
    }
}

extension CanvasView {
    
    func setBrushImage(_ image: UIImage?) {
        brushImage = image
        updateBrushPreviewLayer()
        setNeedsDisplay()
    }
    
    func setImage(_ image: UIImage?) {
        imageLayer = image
        updateBrushPreviewLayer()
        setNeedsDisplay()
    }
    
    func setLineColor(_ color: UIColor) {
        
        lineColor = color
        updateBrushPreviewLayer()
        setNeedsDisplay()
    }
    
    func setBrushOpacity(_ opacity: CGFloat) {
        lineColor = lineColor.withAlphaComponent(opacity)
        updateBrushPreviewLayer()
        setNeedsDisplay()
    }
    
    func setBrushSize(_ size: CGFloat) {
        brushWidth = size
        updateBrushPreviewLayer()
        setNeedsDisplay()
    }
    
    func createPatternColor(from image: UIImage) -> UIColor {
        return UIColor(patternImage: image)
    }
    
    func deleteLayer(at index: Int) {
        guard index >= 0 && index < layers.count else { return }
        
        let linesToDelete = layers[index]
        lines.removeAll { line in
            linesToDelete.contains { $0 == line }
        }
        layers.remove(at: index)
        isLayerHidden.remove(at: index)
        
        layer.sublayers?.forEach { sublayer in
            sublayer.removeFromSuperlayer()
        }
        redrawCanvas()
        setNeedsDisplay()
    }
    
    private func redrawCanvas() {
        for (index, layerLines) in layers.enumerated() {
            if !isLayerHidden[index] {
                let layer = createLayer(from: layerLines)
                self.layer.addSublayer(layer)
            }
        }
    }
    
    func createLayer(from lines: [Line]) -> CALayer {
        let containerLayer = CALayer()
        containerLayer.frame = self.bounds
        
        for line in lines {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = self.bounds
            shapeLayer.lineWidth = line.width
            shapeLayer.lineCap = .round
            shapeLayer.lineJoin = .round
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            let path = UIBezierPath()
            guard let firstPoint = line.points.first else { continue }
            path.move(to: firstPoint)
            for point in line.points.dropFirst() {
                path.addLine(to: point)
            }
            shapeLayer.path = path.cgPath
            
            if let texture = line.texture {
                shapeLayer.strokeColor = UIColor(patternImage: texture).cgColor
            } else {
                shapeLayer.strokeColor = line.color.cgColor
            }
            containerLayer.addSublayer(shapeLayer)
        }
        return containerLayer
    }

    func addLayer(_ newLayer: [Line]) {
        layers.append(newLayer)
        isLayerHidden.append(false)
        setNeedsDisplay()
    }

    func toggleVisibility(at layerIndex: Int) {
        guard layerIndex >= 0 && layerIndex < layers.count else { return }
        
        for i in 0..<layers[layerIndex].count {
            layers[layerIndex][i].isHidden.toggle()
        }
        setNeedsDisplay()
    }
}

extension CanvasView {
    func snapshot(of layer: CALayer) -> UIImage? {
        guard layer.bounds.size.width > 0, layer.bounds.size.height > 0 else {
            print("Layer has zero size. Snapshot creation aborted.")
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: layer.bounds.size)
        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }
}
