//
//  Category.swift
//  ToDoApp
//
//  Created by Andrey on 15.04.2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
