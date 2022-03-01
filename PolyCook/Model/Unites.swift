//
//  Unites.swift
//  PolyCook
//
//  Created by Tupac Rocher on 26/02/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Unite : Identifiable {
    var id : String? = UUID().uuidString
    var nomUnite : String
}

class Unites : ObservableObject, Sequence {
    
    private let firestore  = Firestore.firestore()

    @Published var unites = [Unite]()
    
    var count : Int {
       return self.unites.count
    }
    
    init(){
        loadUnites()
    }
    
    func loadUnites() {
        firestore.collection("unites")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.unites = documents.map{
                    (doc) -> Unite in
                    return Unite(id: doc.documentID,
                                              nomUnite: doc["nomUnite"] as? String ?? "")
                }
                self.unites.sort {
                    $0.nomUnite < $1.nomUnite
                }
            }
    }
    
    subscript(index: Int) -> Unite{
       return self.unites[index]
    }
    
    func makeIterator() -> UnitesIterator {
       return UnitesIterator(Unites: self)
    }
}

struct UnitesIterator : IteratorProtocol{

   private var list : Unites
   private(set) var current: Unite? = nil
   private var index : Int = 0
   
   init(Unites : Unites){
      self.list = Unites
      guard self.list.count > 0 else { return }
      self.current = self.list[index]
   }
   
   mutating func next() -> Unite? {
      guard let current = self.current else { return nil }
      self.index += 1
      defer {
         if self.index < self.list.count { self.current = self.list[index] }
         else { self.current = nil }
      }
      return current
   }
}
