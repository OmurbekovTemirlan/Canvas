import UIKit

public extension UIView {
    
    struct SizingPriority {
        
        public var horizontal: UILayoutPriority
        public var vertical: UILayoutPriority
        
        public init(
            horizontal pHorizontal: UILayoutPriority = .defaultHigh,
            vertical pVertical: UILayoutPriority = .defaultHigh
        ) {
            horizontal = pHorizontal
            vertical = pVertical
        }
    }
    
    struct Sizings {
        
        public var resistance: SizingPriority
        public var compression: SizingPriority
        
        public init(resistance pResistance: SizingPriority, compression pCompression: SizingPriority) {
            resistance = pResistance
            compression = pCompression
        }
    }
    
    var sizings: Sizings {
        get { Sizings(resistance: compressionResistance, compression: hugging) }
        set {
            compressionResistance = newValue.resistance
            hugging = newValue.compression
        }
    }
    
    func setContentPriorityMaximum(axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(.required, for: axis)
        setContentHuggingPriority(.required, for: axis)
    }
    
    var compressionResistance: SizingPriority {
        get { SizingPriority(horizontal: contentCompressionResistancePriority(for: .horizontal), vertical: contentCompressionResistancePriority(for: .vertical)) }
        set {
            setContentCompressionResistancePriority(newValue.horizontal, for: .horizontal)
            setContentCompressionResistancePriority(newValue.vertical, for: .vertical)
        }
    }
    
    var hugging: SizingPriority {
        get { SizingPriority(horizontal: contentHuggingPriority(for: .horizontal), vertical: contentHuggingPriority(for: .vertical)) }
        set {
            setContentHuggingPriority(newValue.horizontal, for: .horizontal)
            setContentHuggingPriority(newValue.vertical, for: .vertical)
        }
    }
}
