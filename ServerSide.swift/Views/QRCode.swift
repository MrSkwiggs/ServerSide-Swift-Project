//
//  QRCode.swift
//  ServerSide.swift
//
//  Created by Dorian on 24/11/2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCode: View {
    
    let ip: String
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        Image(uiImage: generateQRCode())
            .resizable()
            .interpolation(.none)
            .scaledToFit()
        
    }
    
    private func generateQRCode() -> UIImage {
        filter.message = Data(ip.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct QRCode_Previews: PreviewProvider {
    static var previews: some View {
        QRCode(ip: "Hello")
            .previewLayout(.sizeThatFits)
    }
}
