import Foundation
import SwiftUI

struct ShowQR: View {

    public var text = ""

    var body: some View {
        Image(uiImage: UIImage(data: getQRCodeDate(text: text)!)!)
            .resizable()
            .frame(width: 200, height: 200)
    }

    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
}
