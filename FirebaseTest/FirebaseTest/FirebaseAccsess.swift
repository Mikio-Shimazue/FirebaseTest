//
//  FirebaseAccsess.swift
//  FirebaseTest
//
//  Created by Mikizin on 2023/05/22.
//

import Foundation
import FirebaseDatabase

class FirebaseAccess {
  
  var ref: DatabaseReference! = Database.database().reference()
  
  func setData() {
    ref.child("users").setValue(["username": "ame"])
  }
}
