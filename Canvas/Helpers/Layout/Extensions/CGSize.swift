import CoreGraphics

public extension CGSize {
    
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
    
    var nonnegative: CGSize {
        var size = self
        
        size.width = max(size.width, 0)
        size.height = max(size.height, 0)
        
        return size
    }
}
