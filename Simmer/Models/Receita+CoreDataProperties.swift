//
//  Receita+CoreDataProperties.swift
//  Simmer
//
//  Created by Gabriel Groppo on 13/08/26.
//
//

public import Foundation
public import CoreData


public typealias ReceitaCoreDataPropertiesSet = NSSet

extension Receita {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receita> {
        return NSFetchRequest<Receita>(entityName: "Receita")
    }

    @NSManaged public var id: UUID
    @NSManaged public var nome: String
    @NSManaged public var categoria: String
    @NSManaged public var favorito: Bool
    @NSManaged public var dataCriacao: Date?
    @NSManaged public var foto: Data
    @NSManaged public var porcoes: Int16
    @NSManaged public var duracao: Int64
    @NSManaged public var utensilios: String?
    @NSManaged public var modoPreparo: String?
    @NSManaged public var ingredientes: NSSet?
    @NSManaged public var comentarios: NSSet?

}

// MARK: Generated accessors for ingredientes
extension Receita {

    @objc(addIngredientesObject:)
    @NSManaged public func addToIngredientes(_ value: Ingrediente)

    @objc(removeIngredientesObject:)
    @NSManaged public func removeFromIngredientes(_ value: Ingrediente)

    @objc(addIngredientes:)
    @NSManaged public func addToIngredientes(_ values: NSSet)

    @objc(removeIngredientes:)
    @NSManaged public func removeFromIngredientes(_ values: NSSet)

}

// MARK: Generated accessors for comentarios
extension Receita {

    @objc(addComentariosObject:)
    @NSManaged public func addToComentarios(_ value: Comentario)

    @objc(removeComentariosObject:)
    @NSManaged public func removeFromComentarios(_ value: Comentario)

    @objc(addComentarios:)
    @NSManaged public func addToComentarios(_ values: NSSet)

    @objc(removeComentarios:)
    @NSManaged public func removeFromComentarios(_ values: NSSet)

}

extension Receita : Identifiable {

}
