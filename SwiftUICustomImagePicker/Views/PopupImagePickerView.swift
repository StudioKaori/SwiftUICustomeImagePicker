//
//  PopupImagePickerView.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-10.
// from 8:46
// https://www.youtube.com/watch?v=dQUgCyb-OMU&t=329s

import SwiftUI
import Photos

struct PopupImagePickerView: View {
  @StateObject var imagePickerVM = ImagePickerViewModel()
  // to check dark mode
  @Environment(\.self) var env
  
  // callbacks
  var onEnd: () -> ()
  var onSelect: ([PHAsset]) -> ()
  
  var body: some View {
    let deviceSize = UIScreen.main.bounds.size
    VStack(spacing: 0) {
      HStack {
        Text("Select Images")
          .font(.callout.bold())
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Button {
          onEnd()
        } label: {
          Image(systemName: "xmark.circle.fill")
            .font(.title3)
            .foregroundColor(.primary)
        }
      }
      .padding([.horizontal, .top])
      .padding(.bottom, 10)
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)) {
          ForEach($imagePickerVM.fetchedImages) { $imageAsset in
            GridContent(imageAsset: imageAsset)
              .onAppear {
                if imageAsset.thumbnail == nil {
                  // fetching thumbnail image
                  let manager = PHCachingImageManager.default()
                  manager.requestImage(for: imageAsset.asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                    imageAsset.thumbnail = image
                  }
                }
              }
          }
        }
        .padding()
      }
      .safeAreaInset(edge: .bottom) {
        // add button
        Button {
          let imageAssets = imagePickerVM.selectedImages.compactMap { imageAsset -> PHAsset? in
            return imageAsset.asset
          }
          onSelect(imageAssets)
        } label: {
          Text("Add\(imagePickerVM.selectedImages.isEmpty ? "" : "\(imagePickerVM.selectedImages.count)")")
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background {
              Capsule()
                .fill(.blue)
            }
        }
        .disabled(imagePickerVM.selectedImages.isEmpty)
        .opacity(imagePickerVM.selectedImages.isEmpty ? 0.6 : 1)
        .padding(.vertical)

      }
    }
    .frame(height: deviceSize.height / 1.8)
    .frame(maxWidth: (deviceSize.width - 40) > 350 ? 350 : (deviceSize.width - 40))
    .background {
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(env.colorScheme == .dark ? .black : .white)
    }
    // Since it's overlay view make it full screen size
    .frame(width: deviceSize.width, height: deviceSize.height, alignment: .center)
  }
  
  // gred image content
  @ViewBuilder
  func GridContent(imageAsset: ImageAsset) -> some View {
    GeometryReader { proxy in
      let size = proxy.size
      ZStack {
        if let thumbnail = imageAsset.thumbnail {
          Image(uiImage: thumbnail)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        } else {
          ProgressView()
            .frame(width: size.width, height: size.height, alignment: .center)
        }
        
        ZStack {
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.black.opacity(0.1))
          
          Circle()
            .fill(.white.opacity(0.25))
          
          Circle()
            .stroke(.white, lineWidth: 1)
          
          if let index = imagePickerVM.selectedImages.firstIndex(where: { asset in
            asset.id == imageAsset.id
          }) {
            Circle()
              .fill(.blue)
            
            Text("\(imagePickerVM.selectedImages[index].assetIndex + 1)")
              .font(.caption2.bold())
              .foregroundColor(.white)
          }
        }
        .frame(width: 20, height: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(5)
      }
      .clipped()
      .onTapGesture {
        // adding removing assets
        withAnimation(.easeInOut) {
          if let index = imagePickerVM.selectedImages.firstIndex(where: { asset in
            asset.id == imageAsset.id
          }) {
            // remove and update selected index
            imagePickerVM.selectedImages.remove(at: index)
            imagePickerVM.selectedImages.enumerated().forEach { item in
              imagePickerVM.selectedImages[item.offset].assetIndex = item.offset
            }
          } else {
            // add new
            var newAsset = imageAsset
            newAsset.assetIndex = imagePickerVM.selectedImages.count
            imagePickerVM.selectedImages.append(newAsset)
          }
        }
      }
    }
    .frame(height: 70)
  }
}

struct PopupImagePickerView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
