//
//  Note+CoreDataProperties.swift
//  UsersApp
//
//  Created by Dar Dar on 26.12.2023.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?

}

extension Note : Identifiable {

}
