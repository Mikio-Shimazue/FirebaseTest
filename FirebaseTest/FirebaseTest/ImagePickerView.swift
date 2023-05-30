//
//  ImagePickerView.swift
//  FirebaseTest
//
//  Created by Mikizin on 2023/05/30.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIImagePickerController
  @Environment(\.presentationMode) var presentationMode
  @Binding var image: UIImage?
  
  enum SourceType {
    case camera
    case library
  }
  
  var sourceType: SourceType
  var allowsEditing: Bool = false
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePickerView
    
    init(_ parent: ImagePickerView) {
      self.parent = parent
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      getUIImage(didFinishPickingMediaWithInfo: info)
    }
    
    /// カメラロールで選択した画像をUIIMageに設定する
    /// - Parameter info: <#info description#>
    func getUIImage(didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      var uiImage: UIImage?
      if let image = info[.editedImage] as? UIImage {
        uiImage = image
      } else if let image = info[.originalImage] as? UIImage {
        uiImage = image
      }
      
      if let image = uiImage {
        //  JPEGファイル作成
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "sample.jpg"
        let fileURL = path.appendingPathComponent(fileName)
        image.saveJpegFile(fileURL)
        
        //  JPEGファイルをFirebaseStrageへアップ
        let firebaseAccess = FirebaseAccess()
        
        firebaseAccess.setImage(url: fileURL)
        
        parent.image = image
      }
      parent.presentationMode.wrappedValue.dismiss()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let viewController = UIImagePickerController()
    viewController.delegate = context.coordinator
    switch sourceType {
    case .camera:
      viewController.sourceType = UIImagePickerController.SourceType.camera
    case .library:
      viewController.sourceType = UIImagePickerController.SourceType.photoLibrary
    }
    viewController.allowsEditing = allowsEditing
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    
  }
}

extension UIImage {
  internal func saveJpegFile(_ fileURL: URL) -> Bool {
    let jpgImageData = self.jpegData(compressionQuality: 1.0)
    do {
      try jpgImageData!.write(to: fileURL)
    } catch {
      return false
    }
    return true
  }
}
