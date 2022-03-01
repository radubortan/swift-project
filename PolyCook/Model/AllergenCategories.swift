//
//  IngredientCategoryAllergens.swift
//  PolyCook
//
//  Created by Tupac Rocher on 25/02/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AllergenCategory : Identifiable {
    var id : String? = UUID().uuidString
    var nomCatAllerg : String
}

class AllergenCategories : ObservableObject, Sequence {
    
    private let firestore  = Firestore.firestore()

    @Published var allergenCategories = [AllergenCategory]()
    
    @Published var allergenCategoryFilter = [FilterItem]()

    
    var count : Int {
       return self.allergenCategories.count
    }
    
    init(){
        loadAllergenCategories()
    }
    
    func loadAllergenCategories() {
        firestore.collection("allergenes")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.allergenCategories = documents.map{
                    (doc) -> AllergenCategory in
                    return AllergenCategory(id: doc.documentID,
                                              nomCatAllerg: doc["nomCatAllerg"] as? String ?? "")
                }
                self.allergenCategories.sort {
                    $0.nomCatAllerg > $1.nomCatAllerg
                }
                self.allergenCategoryFilter = documents.map{
                    (doc) -> FilterItem in
                    return FilterItem(title: doc["nomCatAllerg"] as? String ?? "")
                }
                self.allergenCategoryFilter.sort {
                    $0.title < $1.title
                }
            }
    }
    
    subscript(index: Int) -> AllergenCategory{
       return self.allergenCategories[index]
    }
    
    func makeIterator() -> AllergenCategoriesIterator {
       return AllergenCategoriesIterator(allergenCategories: self)
    }
}

struct AllergenCategoriesIterator : IteratorProtocol{

   private var list : AllergenCategories
   private(set) var current: AllergenCategory? = nil
   private var index : Int = 0
   
   init(allergenCategories : AllergenCategories){
      self.list = allergenCategories
      guard self.list.count > 0 else { return }
      self.current = self.list[index]
   }
   
   mutating func next() -> AllergenCategory? {
      guard let current = self.current else { return nil }
      self.index += 1
      defer {
         if self.index < self.list.count { self.current = self.list[index] }
         else { self.current = nil }
      }
      return current
   }
}
