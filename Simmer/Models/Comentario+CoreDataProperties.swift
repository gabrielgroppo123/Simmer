//
//  Comentario+CoreDataProperties.swift
//  Simmer
//
//  Created by Gabriel Groppo on 13/08/26.
//
//

public import Foundation
public import CoreData


public typealias ComentarioCoreDataPropertiesSet = NSSet

extension Comentario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comentario> {
        return NSFetchRequest<Comentario>(entityName: "Comentario")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var descricao: String?
    @NSManaged public var data: Date?
    @NSManaged public var receita: Receita?

}

extension Comentario : Identifiable {

}
