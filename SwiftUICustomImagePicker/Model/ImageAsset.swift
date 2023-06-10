//
//  ImageAsset.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-10.
//

import SwiftUI
import PhotosUI

struct ImageAsset: Identifiable {
  var id: String
  var asset: PHAsset
  var thumbnail: UIImage?
  // Selected image index
  var assetIndex: Int = -1
}
