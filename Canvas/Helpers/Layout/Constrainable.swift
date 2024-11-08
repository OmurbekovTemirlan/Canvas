import UIKit

public protocol Constrainable {
    
    var layout: UIView.Anchors { get }
    var __view: UIView? { get } // swiftlint:disable:this identifier_name
    var __constraintItem: Constrainable { get } // swiftlint:disable:this identifier_name
    
    func constraint(for firstAttribute: NSLayoutConstraint.Attribute, appliedTo secondItem: Constrainable?) -> [NSLayoutConstraint]
}

public extension Constrainable {
    
    func constraint(for firstAttribute: NSLayoutConstraint.Attribute, appliedTo secondItem: Constrainable?) -> [NSLayoutConstraint] {
        __view?.findConstraints(for: firstAttribute, appliedTo: secondItem) ?? []
    }
}

public extension UIView {
    
    func findConstraints(for firstAttribute: NSLayoutConstraint.Attribute, appliedTo secondItem: Constrainable?) -> [NSLayoutConstraint] {
        UIView.allConstraints(for: self).filter {
            UIView.matchConstraint(
                $0,
                firstItem: self,
                firstAttribute: firstAttribute,
                secondItem: secondItem?.__view
            )
        }
    }
    
    private static func allConstraints(for viewToCheck: UIView) -> [NSLayoutConstraint] {
        var superviews = [viewToCheck]
        var view = viewToCheck
        while let superview = view.superview {
            superviews.append(superview)
            view = superview
        }
        
        return superviews
            .flatMap { $0.constraints }
            .filter { constraint in
                let views = UIView.constraintViews(constraint)
                return views.first === viewToCheck || views.second === viewToCheck
            }
    }
    
    private static func constraintViews(_ constraint: NSLayoutConstraint) -> (first: UIView?, second: UIView?) {
        var firstView: UIView?
        switch constraint.firstItem {
        case let view as UIView:
            firstView = view
        case let guide as UILayoutGuide:
            firstView = guide.owningView
        default:
            break
        }
        
        var secondView: UIView?
        switch constraint.secondItem {
        case let view as UIView:
            secondView = view
        case let guide as UILayoutGuide:
            secondView = guide.owningView
        default:
            break
        }
        
        return (firstView, secondView)
    }
    
    private static func matchConstraint(
        _ constraint: NSLayoutConstraint,
        firstItem: UIView,
        firstAttribute: NSLayoutConstraint.Attribute,
        secondItem: UIView?
    ) -> Bool {
        let (firstView, secondView) = UIView.constraintViews(constraint)
        
        return firstView === firstItem && firstAttribute == constraint.firstAttribute && secondView === secondItem ||
            secondView === firstItem && firstAttribute == constraint.secondAttribute && firstView == secondItem
    }
}

// swiftlint:disable identifier_name

extension UIView: Constrainable {
    
    public var __view: UIView? { self }
    
    public var __constraintItem: Constrainable { self }
}

extension UILayoutGuide: Constrainable {
    
    public var layout: UIView.Anchors { UIView.Anchors(owner: .layoutGuide(self)) }
    
    public var __view: UIView? { owningView }
    
    public var __constraintItem: Constrainable { self }
}

extension UIView.Anchors: Constrainable {
    
    public var layout: UIView.Anchors { self }
    
    public var __view: UIView? {
        switch owner {
        case .view(let view):
            return view.__view
        case .layoutGuide(let guide):
            return guide.__view
        }
    }
    
    public var __constraintItem: Constrainable {
        switch owner {
        case .view(let view):
            return view
        case .layoutGuide(let guide):
            return guide
        }
    }
}

// swiftlint:enable identifier_name
