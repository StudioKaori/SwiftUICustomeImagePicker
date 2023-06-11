//
//  Extensions.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-11.
//

import SwiftUI
import Photos

extension View {
  @ViewBuilder
  func popupImagePicker(show: Binding<Bool>, transition: AnyTransition = .move(edge: .bottom), onSelect: @escaping ([PHAsset]) -> ()) -> some View {
    self
      .overlay {
        ZStack {
          // BG Blur
          Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .opacity(show.wrappedValue ? 1: 0)
            .onTapGesture {
              show.wrappedValue = false
            }
          
          if show.wrappedValue {
            PopupImagePickerView(onEnd: {
              show.wrappedValue = false
            }, onSelect: { assets in
              onSelect(assets)
            })
            .transition(transition)
          }
        }
        .animation(.easeInOut, value: show.wrappedValue)
      }
  }
}
