//
//  ImageManager.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbum {
    var name: String
    var assets: PHFetchResult<PHAsset>
    var assetCollection: PHAssetCollection
    
    init(name: String, assets: PHFetchResult<PHAsset>, assetCollection: PHAssetCollection) {
        self.name = name
        self.assets = assets
        self.assetCollection = assetCollection
    }
    
    func grabThumbnail(imageSize: CGSize, completion: @escaping (UIImage?) -> ()) {
        guard let firstAsset = assets.firstObject else { completion(nil); return }
        ImageManager.shared.grabPhoto(from: firstAsset, imageSize: imageSize) { (image: UIImage?) in
            completion(image)
        }
    }
}

class ImageManager {
    
    static let shared = ImageManager()
    
    func grabAllPhotosAlbum() -> [PhotoAlbum] {
        var results = [PhotoAlbum]()
        
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: PHFetchOptions())
        smartAlbum.enumerateObjects{ (assetCollection: PHAssetCollection, _, _) in
            let assets = self.fetchAssets(for: assetCollection)
            if assets.count > 0 {
                let photoAlbum = PhotoAlbum(name: "All Photos", assets: assets, assetCollection: assetCollection)
                results.append(photoAlbum)
            }
        }
        
        return results
    }
    
    func grabUserCreatedAlbums(nonEmpty: Bool) -> [PhotoAlbum] {
        var results = [PhotoAlbum]()
        
        let albumAssetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: PHFetchOptions())
        albumAssetCollections.enumerateObjects { (assetCollection: PHAssetCollection, _, _) in
            if let name = assetCollection.localizedTitle {
                let assets = self.fetchAssets(for: assetCollection)
                if assets.count > 0 || !nonEmpty {
                    let photoAlbum = PhotoAlbum(name: name, assets: assets, assetCollection: assetCollection)
                    results.append(photoAlbum)
                }
            }
        }
        
        return results
    }
    
    func grabPhoto(from asset: PHAsset, imageSize: CGSize?, completion: @escaping (UIImage?) -> ()) {
        let imageSize = imageSize ?? PHImageManagerMaximumSize
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: requestOptions) { (image: UIImage?, _) in
            completion(image)
        }
    }
    
    func saveLivePhoto(to album: PhotoAlbum?, imageURL: URL, videoURL: URL, completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            
            if let album = album {
                let assetCollection = album.assetCollection
                let assetPlaceholder: NSArray = [request.placeholderForCreatedAsset!]
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                albumChangeRequest?.addAssets(assetPlaceholder)
            }
            
            request.addResource(with: .photo, fileURL: imageURL, options: nil)
            request.addResource(with: .pairedVideo, fileURL: videoURL, options: nil)
            
        }) { (success: Bool, error: Error?) in
            if let error = error { print(error) }
            completion(success)
        }
    }
    
    fileprivate func fetchAssets(for assetCollection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let fetchedAssets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
        return fetchedAssets
    }
}
