import UIKit

public extension UIView {
    
    var layout: Anchors { Anchors(owner: .view(self)) }
}

public extension UIView {
    
    struct Anchors {
        
        var insets: UIEdgeInsets {
            switch owner {
            case .view:
                return .zero
            case .layoutGuide(let guide):
                return guide.owningView?.safeAreaInsets ?? .zero
            }
        }
        
        enum Owner {
            
            case view(UIView)
            case layoutGuide(UILayoutGuide)
        }
        
        private(set) var owner: Owner
        
        public var safe: Self {
            switch owner {
            case .view(let view):
                return Self(owner: .layoutGuide(view.safeAreaLayoutGuide))
            case .layoutGuide:
                return self
            }
        }
        
        public var keyboard: Self {
            switch owner {
            case .view(let view):
                return Self(owner: .layoutGuide(view.keyboardLayoutGuide))
            case .layoutGuide:
                return self
            }
        }
        
        public var center: Centers {
            switch owner {
            case .view(let view):
                return Centers(view: view, item: view)
            case .layoutGuide(let guide):
                return Centers(view: guide.owningView, item: guide)
            }
        }
        
        public var all: Sides {
            switch owner {
            case .view(let view):
                return Sides(view: view, item: view)
            case .layoutGuide(let guide):
                return Sides(view: guide.owningView, item: guide)
            }
        }
        
        public var size: Sizes {
            switch owner {
            case .view(let view):
                return Sizes(view: view, item: view)
            case .layoutGuide(let guide):
                return Sizes(view: guide.owningView, item: guide)
            }
        }
        
        public var top: YAxis {
            switch owner {
            case .view(let view):
                return YAxis(view: view, item: view, attribute: .top)
            case .layoutGuide(let guide):
                return YAxis(view: guide.owningView, item: guide, attribute: .top)
            }
        }
        
        public var bottom: YAxis {
            switch owner {
            case .view(let view):
                return YAxis(view: view, item: view, attribute: .bottom)
            case .layoutGuide(let guide):
                return YAxis(view: guide.owningView, item: guide, attribute: .bottom)
            }
        }
        
        public var centerY: YAxis {
            switch owner {
            case .view(let view):
                return YAxis(view: view, item: view, attribute: .center)
            case .layoutGuide(let guide):
                return YAxis(view: guide.owningView, item: guide, attribute: .center)
            }
        }
        
        public var left: XAxis {
            switch owner {
            case .view(let view):
                return XAxis(view: view, item: view, attribute: .left)
            case .layoutGuide(let guide):
                return XAxis(view: guide.owningView, item: guide, attribute: .left)
            }
        }
        
        public var right: XAxis {
            switch owner {
            case .view(let view):
                return XAxis(view: view, item: view, attribute: .right)
            case .layoutGuide(let guide):
                return XAxis(view: guide.owningView, item: guide, attribute: .right)
            }
        }
        
        public var centerX: XAxis {
            switch owner {
            case .view(let view):
                return XAxis(view: view, item: view, attribute: .center)
            case .layoutGuide(let guide):
                return XAxis(view: guide.owningView, item: guide, attribute: .center)
            }
        }
        
        public var width: Dimmention {
            switch owner {
            case .view(let view):
                return Dimmention(view: view, item: view, attribute: .width)
            case .layoutGuide(let guide):
                return Dimmention(view: guide.owningView, item: guide, attribute: .width)
            }
        }
        
        public var height: Dimmention {
            switch owner {
            case .view(let view):
                return Dimmention(view: view, item: view, attribute: .height)
            case .layoutGuide(let guide):
                return Dimmention(view: guide.owningView, item: guide, attribute: .height)
            }
        }
        
        public var horizontal: XLines {
            switch owner {
            case .view(let view):
                return XLines(view: view, item: view)
            case .layoutGuide(let guide):
                return XLines(view: guide.owningView, item: guide)
            }
        }
        
        public var vertical: YLines {
            switch owner {
            case .view(let view):
                return YLines(view: view, item: view)
            case .layoutGuide(let guide):
                return YLines(view: guide.owningView, item: guide)
            }
        }
    }
}
