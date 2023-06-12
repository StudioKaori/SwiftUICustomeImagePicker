//
//  ContentView.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-10.
// From 15:12
//https://www.youtube.com/watch?v=dQUgCyb-OMU&t=329s

import SwiftUI
import Photos

struct ContentView: View {
  @State var showPicker: Bool = false
  @State var pickedImages: [UIImage] = []
  
  var body: some View {
    NavigationView {
      TabView {
        ForEach(pickedImages, id: \.self) { image in
          GeometryReader { proxy in
            let size = proxy.size
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: size.width, height: size.height)
              .cornerRadius(15)
          }
          .padding()
        }
      }
      .frame(height: 450)
      // swiftui bug
      // if you don't have any views inside tabview
      // it;s crashing with .always, but not in indexDisplayMode: .never never
      .tabViewStyle(.page(indexDisplayMode: pickedImages.isEmpty ? .never : .always))
      .navigationTitle("Popup image picker")
      .toolbar {
        Button {
          showPicker.toggle()
        } label: {
          Image(systemName: "plus")
        }
      }
    }
    .popupImagePicker(show: $showPicker) { assets in
      // do my operation with the selected images
      // .init means exact size of the image
      let manager = PHCachingImageManager.default()
      let options = PHImageRequestOptions()
      options.isSynchronous = true
      DispatchQueue.global(qos: .userInteractive).async {
        assets.forEach { asset in
          manager.requestImage(for: asset, targetSize: .init(), contentMode: .default, options: options) { image, _ in
            guard let image = image else { return }
            DispatchQueue.main.async {
              self.pickedImages.append(image)
            }
          }
        }
      }
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
