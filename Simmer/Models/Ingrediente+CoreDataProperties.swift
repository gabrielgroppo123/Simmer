//
//  Ingrediente+CoreDataProperties.swift
//  Simmer
//
//  Created by Gabriel Groppo on 13/08/26.
//
//

public import Foundation
public import CoreData


public typealias IngredienteCoreDataPropertiesSet = NSSet

extension Ingrediente {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingrediente> {
        return NSFetchRequest<Ingrediente>(entityName: "Ingrediente")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var quantidade: Double
    @NSManaged public var unidade: String?
    @NSManaged public var receita: Receita?

}

extension Ingrediente : Identifiable {

}
