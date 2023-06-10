//
//  ImagePickerViewModel.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-10.
//

import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
  @Published var fetchedImages: [ImageAsset] = []
  @Published var selectedImages: [ImageAsset] = []
  
  init() {
    fetchImages()
  }
  
  func fetchImages() {
    let options = PHFetchOptions()
    options.includeHiddenAssets = false
    options.includeAssetSourceTypes = [.typeUserLibrary]
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, _, _ in
      let imageAsset: ImageAsset = .init(asset: asset)
      self.fetchedImages.append(imageAsset)
    }
  }
}
