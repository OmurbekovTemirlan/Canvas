//
//  layer+Extension.swift
//  Canvas
//
//  Created by Apple on 28.10.2024.
//

import UIKit

extension CALayer {
    func toImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { rendererContext in
            render(in: rendererContext.cgContext)
        }
    }
}
