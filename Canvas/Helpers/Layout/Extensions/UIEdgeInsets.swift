import UIKit

public extension UIEdgeInsets {
    
    init(side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
