//
//  GenerateLiveWallpaperWithBarcode.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import Photos
import UIKit

class GenerateLiveWallpaperWithBarcode {
    
    let fileName: String
    let wallpaperImage: UIImage
    let barcode: Barcode
    
    init(fileName: String, wallpaperImage: UIImage, barcode: Barcode) {
        self.fileName = fileName
        self.wallpaperImage = wallpaperImage
        self.barcode = barcode
    }
    
    // func create(completion: @escaping (LPLivePhoto?) -> ()) {
    func create(completion: @escaping (PHLivePhoto?) -> ()) {
        
        guard let barcodeImage = generateBarcode()?.withRoundedCorners(radius: 20.0) else { completion(nil); return }
        
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { completion(nil); return }
        
        let imageFilePath = "\(documentsDirectory)/\(fileName).jpeg"
        let imageFilePathURL = URL(fileURLWithPath: imageFilePath)
        
        let videoFilePath = "\(documentsDirectory)/\(fileName).mov"
        let videoFilePathURL = URL(fileURLWithPath: videoFilePath)
        
        guard let videoFrames = interpolateFrames(wallpaperImage: wallpaperImage, barcodeImage: barcodeImage) else { completion(nil); return }
        VideoFromImages(images: videoFrames, framesPerSecond: 2).writeMovieToURL(url: videoFilePathURL) { (success: Bool) in
            
            guard success else { completion(nil); return }
            
            // Create image path
            guard let livePhotoImage = videoFrames.first else { completion(nil); return }
            let livePhotoImageData = livePhotoImage.jpegData(compressionQuality: 1.0)
            guard let _ = try? livePhotoImageData?.write(to: imageFilePathURL) else { completion(nil); return }
            
            LivePhoto.generate(from: imageFilePathURL, videoURL: videoFilePathURL, progress: { (percent) in
            }) { (livePhoto: PHLivePhoto?, resources: LivePhoto.LivePhotoResources?) in
                completion(livePhoto)
            }
        }
    }
    
    fileprivate func generateBarcode() -> UIImage? {
        guard let barcodeData = barcode.generateDataFromInputs() else { return nil }
        
        let barcodeImageRatio: CGFloat = 0.7
        let barcodeImageLength: CGFloat = wallpaperImage.size.width * barcodeImageRatio
        let barcodeImageSize = CGSize(width: barcodeImageLength, height: barcodeImageLength)
        let barcodeImage = barcode.generateQRImageWith(data: barcodeData, size: barcodeImageSize)
        
        return barcodeImage
    }
    
    fileprivate func interpolateFrames(wallpaperImage: UIImage, barcodeImage: UIImage) -> [UIImage]? {
        
        guard let frame2Background = wallpaperImage.darkenedAndBlurred(darkness: 0, blurRadius: 30) else { return nil }
        guard let frame2 = drawBarcodeOnImage(barcode: barcodeImage, image: frame2Background) else { return nil }
        
        return [wallpaperImage, frame2]
    }
    
    fileprivate func drawBarcodeOnImage(barcode: UIImage, image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let _ = UIGraphicsGetCurrentContext() else { return nil }
        
        let xOffset = (image.size.width / 2.0) - barcode.size.width / 2.0
        let yOffset = (image.size.height / 2.0) - barcode.size.height / 2.0
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        barcode.draw(in: CGRect(x: xOffset, y: yOffset, width: barcode.size.width, height: barcode.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

}
