import UIKit
import Foundation

enum AppColors {
    
    case background
    case additionalBackground
    case mainText
    case blackText
    case textAndIcons
    case white15
    case white50
    case grid
    
    var color: UIColor {
        switch self {
        case .background:
            return UIColor(hex: "#303030")
        case .additionalBackground:
            return UIColor(hex: "#3F3F3F")
        case .mainText:
            return UIColor(hex: "#FFFFFF")
        case .blackText:
            return UIColor(hex: "#02031E")
        case .textAndIcons:
            return UIColor(hex: "#757575")
        case .white15:
            return .white.withAlphaComponent(0.15)
        case .white50:
            return .white.withAlphaComponent(0.5)
        case .grid:
            return UIColor(hex: "F4F4F4").withAlphaComponent(0.35)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct Template: Hashable {
    
    let id: String
    let name: String
    let image: UIImage
    let category: Category
    
    static let empty: Self = .init(id: "empty", name: "", image: .empty32Icon, category: .empty)
}

extension Template {
    
    enum Category: CaseIterable {
        
        case shoes
        case bodice
        case shoulders
        case neckline
        case empty
        
        var name: String {
            switch self {
            case .shoes: "Shoes"
            case .bodice: "Bodice"
            case .shoulders: "Shoulders"
            case .neckline: "Neckline"
            case .empty: ""
            }
        }
    }
}

class StorageManager {
    
    static let shared = StorageManager()

    private init() {}
    
    private var templates: [Template] {
        (0..<3).flatMap { _ in [
            Template(
                id: UUID().uuidString,
                name: "",
                image: .template1,
                category: .shoulders
            ),
            Template(
                id: UUID().uuidString,
                name: "",
                image: .template2,
                category: .shoes
            ),
            Template(
                id: UUID().uuidString,
                name: "",
                image: .template2,
                category: .neckline
            ),
        ] }
    }
    
    func getTemplates() -> [Template] {
        templates
    }
    
    func getCategories() -> [Template.Category] {
        [.empty] + templates
            .map { $0.category }
            .filter { $0 != .empty }
            .unique()
    }
}

extension Array where Element: Hashable {
    
    func unique() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}



enum GradientStyle {
    
    case sunset
    
    var colors: [CGColor] {
        switch self {
        case .sunset:
            return [
                UIColor(hex: "#E47A4D").cgColor,
                UIColor(hex: "#F642D9").cgColor,
            ]
        }
    }
    
    var startPoint: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
    
    var endPoint: CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }

    func gradientImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let colors = self.colors as CFArray
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        
        let startPoint = CGPoint(x: size.width * self.startPoint.x, y: size.height * self.startPoint.y)
        let endPoint = CGPoint(x: size.width * self.endPoint.x, y: size.height * self.endPoint.y)
        
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension String {

    func size(forFont font: UIFont, maxWidth: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let maxSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        
        let textSize = (self as NSString).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil).size
        
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
}

extension UIView {
    
    func removeGradient() {
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }
    
    func applyGradient(with style: GradientStyle, with corner: CGFloat? = nil, height: CGFloat? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = style.colors
        gradientLayer.startPoint = style.startPoint
        gradientLayer.endPoint = style.endPoint
        gradientLayer.frame = self.bounds
        
        if let corner {
            gradientLayer.cornerRadius = corner
        }
        
        if let height {
            gradientLayer.frame.size = .init(width: gradientLayer.frame.width, height: height)
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
