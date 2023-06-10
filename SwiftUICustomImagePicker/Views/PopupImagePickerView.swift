//
//  PopupImagePickerView.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-10.
//

import SwiftUI

struct PopupImagePickerView: View {
  @StateObject var imagePickerVM = ImagePickerViewModel()
  @Environment(\.self) var env
  
  var body: some View {
    let deviceSize = UIScreen.main.bounds.size
    VStack(spacing: 0) {
      HStack {
        Text("Select Images")
          .font(.callout.bold())
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Button {
          
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
            //
            GridContent(imageAsset: imageAsset)
          }
        }
        .padding()
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
    }
    .frame(height: 70)
  }
}

struct PopupImagePickerView_Previews: PreviewProvider {
  static var previews: some View {
    PopupImagePickerView()
  }
}
