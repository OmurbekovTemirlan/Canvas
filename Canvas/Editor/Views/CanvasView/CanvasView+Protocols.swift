

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func didDraw(_ view: CanvasView, canUndo: Bool, canRedo: Bool)
    func didCreateSnapshot(_ view: CanvasView, snapshot: UIImage) // новый метод
}

