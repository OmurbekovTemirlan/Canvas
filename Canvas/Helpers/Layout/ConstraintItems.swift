import UIKit

public typealias ConstraintPair = (first: NSLayoutConstraint, second: NSLayoutConstraint)

public protocol SimpleConstraintItem {
    
    var view: UIView? { get }
    var item: Constrainable { get }
}

extension SimpleConstraintItem {
    
    func fixAutoresizing(with other: SimpleConstraintItem? = nil) {
        guard let view else { return }
        
        if let rhs = other?.view,
           rhs.isDescendant(of: view) {
            rhs.translatesAutoresizingMaskIntoConstraints = false
        } else {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

public protocol ConstraintAttributable {
    
    var raw: NSLayoutConstraint.Attribute { get }
    var modifier: CGFloat { get }
}

public extension ConstraintAttributable {
    
    var modifier: CGFloat { 1 }
}

public protocol AttributedConstraintItem: SimpleConstraintItem {
    
    associatedtype Attribute: ConstraintAttributable
    
    var attribute: Attribute { get }
    
    func from(_ item: Constrainable) -> Self
}

public extension AttributedConstraintItem {

    @discardableResult
    func equal(
        to other: Constrainable,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        equal(
            to: from(other),
            offset: offset,
            multiplier: multiplier,
            priority: priority,
            removeExisting: removeExisting,
            activated: activated
        )
    }
    
    @discardableResult
    func equal(
        to other: UIView.Anchors,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        equal(
            to: from(other),
            offset: offset,
            multiplier: multiplier,
            priority: priority,
            removeExisting: removeExisting,
            activated: activated
        )
    }
    
    @discardableResult
    func equal(
        to other: Self,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        fixAutoresizing(with: other)
        
        if removeExisting {
            item.constraint(for: attribute.raw, appliedTo: other.item).forEach { $0.isActive = false }
        }
        
        let value = NSLayoutConstraint(
            item: item,
            attribute: attribute.raw,
            relatedBy: .equal,
            toItem: other.item,
            attribute: other.attribute.raw,
            multiplier: multiplier,
            constant: offset * attribute.modifier
        )
        
        value.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute))-\(String(describing: other.item.__view)))"
        value.priority = priority
        value.isActive = activated
        
        return value
    }
    
    @discardableResult
    func greater(
        than other: Constrainable,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        greater(
            than: from(other),
            offset: offset,
            multiplier: multiplier,
            priority: priority,
            removeExisting: removeExisting,
            activated: activated
        )
    }
    
    @discardableResult
    func greater(
        than other: UIView.Anchors,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        greater(
            than: from(other),
            offset: offset,
            multiplier: multiplier,
            priority: priority,
            removeExisting: removeExisting,
            activated: activated
        )
    }
    
    @discardableResult
    func greater(
        than other: Self,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        fixAutoresizing(with: other)
        
        if removeExisting {
            item.constraint(for: attribute.raw, appliedTo: other.item).forEach { $0.isActive = false }
        }
        
        let value = NSLayoutConstraint(
            item: item,
            attribute: attribute.raw,
            relatedBy: .greaterThanOrEqual,
            toItem: other.item,
            attribute: other.attribute.raw,
            multiplier: multiplier,
            constant: offset * attribute.modifier
        )
        
        value.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute.raw))-\(String(describing: other.item.__view)))"
        value.priority = priority
        value.isActive = activated
        
        return value
    }
    
    @discardableResult
    func less(
        than other: Constrainable,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        less(
            than: from(other),
            offset: offset,
            multiplier: multiplier,
            priority: priority,
            removeExisting: removeExisting,
            activated: activated
        )
    }
    
    @discardableResult
    func less(
        than other: UIView.Anchors,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        less(
            than: from(other),
            offset: offset,
            multiplier: multiplier,
            priority: priority,
            removeExisting: removeExisting,
            activated: activated
        )
    }
    
    @discardableResult
    func less(
        than other: Self,
        offset: CGFloat = 0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required,
        removeExisting: Bool = true,
        activated: Bool = true
    ) -> NSLayoutConstraint {
        fixAutoresizing(with: other)
        
        if removeExisting {
            item.constraint(for: attribute.raw, appliedTo: other.item).forEach { $0.isActive = false }
        }
        
        let value = NSLayoutConstraint(
            item: item,
            attribute: attribute.raw,
            relatedBy: .lessThanOrEqual,
            toItem: other.item,
            attribute: other.attribute.raw,
            multiplier: multiplier,
            constant: offset
        )
        
        value.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute.raw))-\(String(describing: other.item.__view)))"
        value.priority = priority
        value.isActive = activated
        
        return value
    }
}

public extension UIView.Anchors {
    
    struct XAxis: AttributedConstraintItem {
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem, attribute: attribute)
        }
        
        public enum Attribute: ConstraintAttributable {
            
            case left
            case right
            case center
            
            public var raw: NSLayoutConstraint.Attribute {
                switch self {
                case .left:
                    return .left
                case .right:
                    return .right
                case .center:
                    return .centerX
                }
            }
        }
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        public private(set) var attribute: Attribute
    }
    
    struct YAxis: AttributedConstraintItem {
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem, attribute: attribute)
        }
        
        public enum Attribute: ConstraintAttributable {
            
            case top
            case bottom
            case center
            
            public var raw: NSLayoutConstraint.Attribute {
                switch self {
                case .top:
                    return .top
                case .bottom:
                    return .bottom
                case .center:
                    return .centerY
                }
            }
        }
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        public private(set) var attribute: Attribute
    }
    
    struct Centers: SimpleConstraintItem {
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem)
        }
        
        @discardableResult
        public func equal(
            to other: Constrainable,
            offset: CGPoint = .zero,
            removeExisting: Bool = true
        ) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
            equal(
                to: from(other),
                offset: offset,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: UIView.Anchors,
            offset: CGPoint = .zero,
            removeExisting: Bool = true
        ) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
            equal(
                to: from(other),
                offset: offset,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Self,
            offset: CGPoint = .zero,
            removeExisting: Bool = true
        ) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
            fixAutoresizing(with: other)
            
            if removeExisting {
                item.constraint(for: .centerX, appliedTo: other.item).forEach { $0.isActive = false }
            }
            
            let x = NSLayoutConstraint(
                item: item,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: other.item,
                attribute: .centerX,
                multiplier: 1,
                constant: offset.x
            )
            
            x.identifier = "Layout: \(String(describing: item.__view))-.centerX-\(String(describing: other.item.__view)))"
            x.isActive = true
            
            if removeExisting {
                item.constraint(for: .centerY, appliedTo: other.item).forEach { $0.isActive = false }
            }
            
            let y = NSLayoutConstraint(
                item: item,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: other.item,
                attribute: .centerY,
                multiplier: 1,
                constant: offset.y
            )
            
            y.identifier = "Layout: \(String(describing: item.__view))-.centerY-\(String(describing: other.item.__view)))"
            y.isActive = true
            
            return (x, y)
        }
    }
}

public extension UIView.Anchors {
    
    struct Dimmention: AttributedConstraintItem {
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem, attribute: attribute)
        }
        
        public enum Attribute: ConstraintAttributable {
            
            case width
            case height
            
            public var raw: NSLayoutConstraint.Attribute {
                switch self {
                case .width:
                    return .width
                case .height:
                    return .height
                }
            }
        }
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        public private(set) var attribute: Attribute
        
        @discardableResult
        public func equal(
            to value: CGFloat,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> NSLayoutConstraint {
            fixAutoresizing()
            
            if removeExisting {
                item.constraint(for: attribute.raw, appliedTo: nil).forEach { $0.isActive = false }
            }
            
            let value = NSLayoutConstraint(
                item: item,
                attribute: attribute.raw,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: value
            )
            
            value.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute.raw))-self)"
            value.priority = priority
            value.isActive = true
            
            return value
        }
        
        @discardableResult
        public func greater(
            than value: CGFloat,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> NSLayoutConstraint {
            fixAutoresizing()
            
            if removeExisting {
                item.constraint(for: attribute.raw, appliedTo: nil).forEach { $0.isActive = false }
            }
            
            let value = NSLayoutConstraint(
                item: item,
                attribute: attribute.raw,
                relatedBy: .greaterThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: value
            )
            
            value.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute.raw))-self)"
            value.priority = priority
            value.isActive = true
            
            return value
        }
        
        @discardableResult
        public func less(
            than value: CGFloat,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> NSLayoutConstraint {
            fixAutoresizing()
            
            if removeExisting {
                item.constraint(for: attribute.raw, appliedTo: nil).forEach { $0.isActive = false }
            }
            
            let value = NSLayoutConstraint(
                item: item,
                attribute: attribute.raw,
                relatedBy: .lessThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: value
            )
            
            value.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute.raw))-self)"
            value.priority = priority
            value.isActive = true
            
            return value
        }
    }
}

public extension UIView.Anchors {
    
    struct Sizes: SimpleConstraintItem {
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        
        @discardableResult
        public func equal(
            to size: CGSize,
            removeExisting: Bool = true
        ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
            fixAutoresizing()
            
            if removeExisting {
                item.constraint(for: .width, appliedTo: nil).forEach { $0.isActive = false }
            }
            
            let width = NSLayoutConstraint(
                item: item,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: size.width
            )
            
            width.identifier = "Layout: \(String(describing: item.__view))-.width-self)"
            width.isActive = true
            
            if removeExisting {
                item.constraint(for: .height, appliedTo: nil).forEach { $0.isActive = false }
            }
            
            let height = NSLayoutConstraint(
                item: item,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: size.height
            )
            
            height.identifier = "Layout: \(String(describing: item.__view))-.height-self"
            height.isActive = true
            
            return (width, height)
        }
    }
}

public extension UIView.Anchors {
    
    struct Sides: SimpleConstraintItem {
        
        public struct ConstraintGroup {
            
            fileprivate(set) var top: NSLayoutConstraint?
            fileprivate(set) var left: NSLayoutConstraint?
            fileprivate(set) var bottom: NSLayoutConstraint?
            fileprivate(set) var right: NSLayoutConstraint?
        }
        
        public struct Elements: OptionSet {
            
            public let rawValue: Int
            
            public static let top = Self(rawValue: 1 << 0)
            public static let left = Self(rawValue: 1 << 1)
            public static let bottom = Self(rawValue: 1 << 2)
            public static let right = Self(rawValue: 1 << 3)
            
            public static let all: Self = [.top, .left, .bottom, .right]
            
            public init(rawValue pRawValue: Int) {
                rawValue = pRawValue
            }
        }
        
        public struct PriorityGroup {
            
            public static let required = Self()
            
            public var top: UILayoutPriority
            public var left: UILayoutPriority
            
            public var bottom: UILayoutPriority
            public var right: UILayoutPriority
            
            public init(
                top pTop: UILayoutPriority = .required,
                left pLeft: UILayoutPriority = .required,
                bottom pBottom: UILayoutPriority = .required,
                right pRight: UILayoutPriority = .required
            ) {
                top = pTop
                left = pLeft
                bottom = pBottom
                right = pRight
            }
        }
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        public private(set) var elements = Elements.all
        
        public init(
            view pView: UIView?,
            item pItem: Constrainable,
            elements pElements: Elements = .all
        ) {
            view = pView
            item = pItem
            elements = pElements
        }
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem, elements: elements)
        }
        
        public func except(_ elementsToExclude: Elements) -> Self {
            var new = self
            new.elements.subtract(elementsToExclude)
            return new
        }
        
        @discardableResult
        public func equal(
            to other: Constrainable,
            offset: UIEdgeInsets = .zero,
            priority: PriorityGroup = .required,
            removeExisting: Bool = true
        ) -> ConstraintGroup {
            equal(
                to: from(other),
                offset: offset,
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: UIView.Anchors,
            offset: UIEdgeInsets = .zero,
            priority: PriorityGroup = .required,
            removeExisting: Bool = true
        ) -> ConstraintGroup {
            equal(
                to: from(other),
                offset: offset,
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Self,
            offset: UIEdgeInsets = .zero,
            priority: PriorityGroup = .required,
            removeExisting: Bool = true
        ) -> ConstraintGroup {
            fixAutoresizing(with: other)
            
            var result = ConstraintGroup()
            
            let pElements: [Elements] = [.top, .left, .bottom, .right]
            let attributes = [
                (NSLayoutConstraint.Attribute.top, offset.top, priority.top),
                (NSLayoutConstraint.Attribute.left, offset.left, priority.left),
                (NSLayoutConstraint.Attribute.bottom, -offset.bottom, priority.bottom),
                (NSLayoutConstraint.Attribute.right, -offset.right, priority.right),
            ]
            let array = zip(pElements, attributes)
            
            for (element, (attribute, offset, priority)) in array where elements.contains(element) {
                if removeExisting {
                    item.constraint(for: attribute, appliedTo: other.item).forEach { $0.isActive = false }
                }
                
                let constraint = NSLayoutConstraint(
                    item: item,
                    attribute: attribute,
                    relatedBy: .equal,
                    toItem: other.item,
                    attribute: attribute,
                    multiplier: 1,
                    constant: offset
                )
                
                constraint.identifier = "Layout: \(String(describing: item.__view))-\(String(describing: attribute))-\(String(describing: other.item.__view)))"
                constraint.priority = priority
                constraint.isActive = true
                
                switch element {
                case .top:
                    result.top = constraint
                case .left:
                    result.left = constraint
                case .bottom:
                    result.bottom = constraint
                case .right:
                    result.right = constraint
                default:
                    continue
                }
            }
            
            return result
        }
    }
    
    struct YLines: SimpleConstraintItem {
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem)
        }
        
        @discardableResult
        public func equal(
            to other: Constrainable,
            offset: CGFloat = 0,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: other,
                offset: (offset, offset),
                priority: priority
            )
        }
        
        @discardableResult
        public func equal(
            to other: Constrainable,
            offset: (first: CGFloat, second: CGFloat),
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: from(other),
                offset: offset,
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: UIView.Anchors,
            offset: CGFloat = 0,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: other,
                offset: (offset, offset),
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: UIView.Anchors,
            offset: (first: CGFloat, second: CGFloat),
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: from(other),
                offset: offset,
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Self,
            offset: CGFloat = 0,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: other,
                offset: (offset, offset),
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Self,
            offset: (first: CGFloat, second: CGFloat),
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            fixAutoresizing(with: other)
            
            if removeExisting {
                item.constraint(for: .top, appliedTo: other.item).forEach { $0.isActive = false }
            }
            
            let first = NSLayoutConstraint(
                item: item,
                attribute: .top,
                relatedBy: .equal,
                toItem: other.item,
                attribute: .top,
                multiplier: 1,
                constant: offset.first
            )
            
            first.identifier = "Layout: \(String(describing: item.__view))-.top-\(String(describing: other.item.__view)))"
            first.priority = priority
            first.isActive = true
            
            if removeExisting {
                item.constraint(for: .bottom, appliedTo: other.item).forEach { $0.isActive = false }
            }
            
            let second = NSLayoutConstraint(
                item: item,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: other.item,
                attribute: .bottom,
                multiplier: 1,
                constant: -offset.second
            )
            
            second.identifier = "Layout: \(String(describing: item.__view))-.bottom-\(String(describing: other.item.__view)))"
            second.priority = priority
            second.isActive = true
            
            return (first, second)
        }
    }
    
    struct XLines: SimpleConstraintItem {
        
        public private(set) var view: UIView?
        public private(set) var item: Constrainable
        
        public func from(_ item: Constrainable) -> Self {
            Self(view: item.__view, item: item.__constraintItem)
        }
        
        @discardableResult
        public func equal(
            to other: Constrainable,
            offset: CGFloat = 0,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: other,
                offset: (offset, offset),
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Constrainable,
            offset: (first: CGFloat, second: CGFloat),
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: from(other),
                offset: offset,
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: UIView.Anchors,
            offset: CGFloat = 0,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: other,
                offset: (offset, offset),
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: UIView.Anchors,
            offset: (first: CGFloat, second: CGFloat),
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: from(other),
                offset: offset,
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Self,
            offset: CGFloat = 0,
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            equal(
                to: other,
                offset: (offset, offset),
                priority: priority,
                removeExisting: removeExisting
            )
        }
        
        @discardableResult
        public func equal(
            to other: Self,
            offset: (first: CGFloat, second: CGFloat),
            priority: UILayoutPriority = .required,
            removeExisting: Bool = true
        ) -> ConstraintPair {
            fixAutoresizing(with: other)
            
            if removeExisting {
                item.constraint(for: .left, appliedTo: other.item).forEach { $0.isActive = false }
            }
            
            let first = NSLayoutConstraint(
                item: item,
                attribute: .left,
                relatedBy: .equal,
                toItem: other.item,
                attribute: .left,
                multiplier: 1,
                constant: offset.first
            )
            
            first.identifier = "Layout: \(String(describing: item.__view))-.left-\(String(describing: other.item.__view)))"
            first.priority = priority
            first.isActive = true
            
            if removeExisting {
                item.constraint(for: .right, appliedTo: other.item).forEach { $0.isActive = false }
            }
            
            let second = NSLayoutConstraint(
                item: item,
                attribute: .right,
                relatedBy: .equal,
                toItem: other.item,
                attribute: .right,
                multiplier: 1,
                constant: -offset.second
            )
            
            second.identifier = "Layout: \(String(describing: item.__view))-.right-\(String(describing: other.item.__view)))"
            second.priority = priority
            second.isActive = true
            
            return (first, second)
        }
    }
}
