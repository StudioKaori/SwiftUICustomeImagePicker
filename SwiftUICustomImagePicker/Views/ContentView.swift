//
//  ContentView.swift
//  SwiftUICustomImagePicker
//
//  Created by Kaori Persson on 2023-06-10.
//https://www.youtube.com/watch?v=dQUgCyb-OMU&t=329s

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
