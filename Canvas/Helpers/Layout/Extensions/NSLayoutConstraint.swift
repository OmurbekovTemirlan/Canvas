import UIKit

public extension NSLayoutConstraint {
    
    @discardableResult
    func prioritize(_ value: UILayoutPriority) -> NSLayoutConstraint {
        priority = value
        return self
    }
    
    @discardableResult
    func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }
    
    @discardableResult
    func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}
