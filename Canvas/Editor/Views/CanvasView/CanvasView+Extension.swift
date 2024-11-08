import UIKit

extension CanvasView {
    
    // Метод для получения изображения с нарисованными линиями и изображением (темплейтом)
    func exportDrawingAsImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        
        // Создаем изображение, рисуя все линии и изображение (без сетки)
        let image = renderer.image { context in
            // Получаем контекст для рисования
            let cgContext = context.cgContext
            
            // Рисуем изображение (если оно есть)
            if let templateImage = imageLayer {
                let imageSize = templateImage.size
                let imageOrigin = CGPoint(x: (self.bounds.size.width - imageSize.width) / 2, y: (self.bounds.size.height - imageSize.height) / 2)
                templateImage.draw(in: CGRect(origin: imageOrigin, size: imageSize))
            }
            
            // Рисуем все линии
            cgContext.setLineCap(.round)
            for line in lines {
                cgContext.setLineWidth(line.width)
                cgContext.setStrokeColor(line.color.cgColor) // Устанавливаем цвет линии
                
                for (i, point) in line.points.enumerated() {
                    if i == 0 {
                        cgContext.move(to: point)
                    } else {
                        cgContext.addLine(to: point)
                    }
                }
                cgContext.strokePath()
            }
        }
        
        return image
    }
}

