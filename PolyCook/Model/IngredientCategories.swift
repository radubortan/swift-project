//
//  IngredientCategory.swift
//  PolyCook
//
//  Created by Tupac Rocher on 24/02/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct IngredientCategory : Identifiable {
    var id : String? = UUID().uuidString
    var nomCatIng : String
}

class IngredientCategories : ObservableObject, Sequence {
    
    private let firestore  = Firestore.firestore()

    @Published var ingredientCategories = [IngredientCategory]()
    
    @Published var ingredientCategoryFilter = [FilterItem]()
    
    
    var count : Int {
       return self.ingredientCategories.count
    }
    
    var hasNoCheckedFilter : Bool {
        var isChecked = true
        for filterItem in ingredientCategoryFilter {
            if(filterItem.checked){
                isChecked = false
            }
        }
        return isChecked
    }
    
    func nomCatIsChecked(nomCat: String) -> Bool{
        var isChecked = false
        for filterItem in ingredientCategoryFilter {
            if(filterItem.checked && filterItem.title == nomCat){
                isChecked = true
            }
        }
        return isChecked
    }
    
    init(){
        loadIngredientCategories()
    }
    
    func loadIngredientCategories() {
        firestore.collection("categoriesIngredients")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.ingredientCategories = documents.map{
                    (doc) -> IngredientCategory in
                    return IngredientCategory(id: doc.documentID,
                                              nomCatIng: doc["nomCatIng"] as? String ?? "")
                }
                self.ingredientCategoryFilter = documents.map{
                    (doc) -> FilterItem in
                    return FilterItem(title: doc["nomCatIng"] as? String ?? "")
                }
                self.ingredientCategories.sort {
                    $0.nomCatIng < $1.nomCatIng
                }
                self.ingredientCategoryFilter.sort {
                    $0.title < $1.title
                }
            }
    }
    
    subscript(index: Int) -> IngredientCategory{
       return self.ingredientCategories[index]
    }
    
    func makeIterator() -> IngredientCategoriesIterator {
       return IngredientCategoriesIterator(ingredientCategories: self)
    }
}

struct IngredientCategoriesIterator : IteratorProtocol{

   private var list : IngredientCategories
   private(set) var current: IngredientCategory? = nil
   private var index : Int = 0
   
   init(ingredientCategories : IngredientCategories){
      self.list = ingredientCategories
      guard self.list.count > 0 else { return }
      self.current = self.list[index]
   }
   
   mutating func next() -> IngredientCategory? {
      guard let current = self.current else { return nil }
      self.index += 1
      defer {
         if self.index < self.list.count { self.current = self.list[index] }
         else { self.current = nil }
      }
      return current
   }
}
