//
//  ContentView.swift
//  FirebaseTest
//
//  Created by Mikizin on 2023/05/22.
//

import SwiftUI

struct ContentView: View {
  var firebaseAccess = FirebaseAccess()
  @State var showingPicker = false
  @State var image: UIImage?
  var body: some View {
    VStack {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
      Button("Firebase RealTimeDatabase DataSetTest") {
        print("")

        firebaseAccess.setData()
      }

      Button("Firebase Storage SetImage") {
        showingPicker.toggle()
      }

      Button("Firebase Storage GetImage") {
        Image(uiImage: firebaseAccess.loadImage()!)
      }
    }
    .padding()
    .sheet(isPresented: $showingPicker) {
      ImagePickerView(image: $image, sourceType: .library)
//      firebaseAccess.setImage()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
