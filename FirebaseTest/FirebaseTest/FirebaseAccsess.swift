//
//  FirebaseAccsess.swift
//  FirebaseTest
//
//  Created by Mikizin on 2023/05/22.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase   //  RealtimeDatabaesにアクセスする場合import
import UIKit

//import FirebaseStorage    //  Storageデータアクセスする場合import


class FirebaseAccess {
  
  var ref: DatabaseReference! = Database.database().reference()
  let storage = Storage.storage()
  var downloadURL: URL?

  func setData() {
    ref.child("users").setValue(["username": "ame"])
  }
  
  func setImage() {
    let path =  "gs://schedule-bool.appspot.com/test/testUp.png"
    let imageRef = storage.reference().child(path)
    
    //  ローカルファイルURL
    guard let url = URL(string: "/Users/shimazun/development/shimawork/FirebaseTest/FirebaseTest/22739856.png") else { return }
    //  ローカルファイルをアップロード
    let uploadTask = imageRef.putFile(from: url)
    
    //  アップロード成功observer
    uploadTask.observe(.success){ _ in
      imageRef.downloadURL{ url, error in
        if let url = url {
          self.downloadURL = url
        }
      }
    }
    
    //  アップロード失敗オブザーバー
    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as? NSError {
        print(error)
        switch StorageErrorCode(rawValue: error.code)! {
        case .objectNotFound:
          print("")
          break
        case .unauthorized:
          print("")
          break
        case .cancelled:
          print("")
          break
        case .unknown:
          print("")
          break
        default:
          print("")
          break
        }
      }
    }
    // observerはsuccess or failure 発生後に全て削除される
    // https://firebase.google.com/docs/storage/ios/upload-files?hl=ja#:~:text=.removeAllObservers()-,%E3%83%A1%E3%83%A2%E3%83%AA,-%E3%83%AA%E3%83%BC%E3%82%AF%E3%82%92%E9%98%B2%E3%81%90
  }
  
  func loadImage() -> UIImage? {
    do {
      let data = try Data(contentsOf: downloadURL!)
      return UIImage(data: data)!
    } catch let error {
      print("Error \(error.localizedDescription)")
    }
    return nil
  }
}
