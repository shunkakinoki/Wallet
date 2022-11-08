import Foundation
import SwiftUI

struct ShowQR: View {

    public var text = ""

    var body: some View {
        Image(uiImage: getQRCodeUIImage(text: text, color: .label.resolvedColor(with: .current))!)
            .resizable()
            .frame(width: 200, height: 200)
    }

    func getQRCodeUIImage(text: String, color: UIColor) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        
        let colorParameters = [
            "inputColor0": CIColor(color: color),
            "inputColor1": CIColor(color: .clear),
        ]
        let colored = scaledCIImage.applyingFilter("CIFalseColor", parameters: colorParameters)
        
        guard let pngData = UIImage(ciImage: colored).pngData() else { return nil }
        return UIImage(data: pngData)
    }
}
