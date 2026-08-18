//
//  CoreDataReceitaRepository.swift
//  Simmer
//
//  Created by Gabriel Groppo on 15/08/26.
//
//
import CoreData

final class CoreDataReceitaRepository: ReceitaRepository {
    func atualizarReceita(_ receita: ReceitaModel, nome: String, categoria: Categoria, foto: Data, porcoes: Int16?, duracao: Int64, utensilios: String?, modoPreparo: String, ingredientes: [NovoIngrediente]) throws {
        
    }
    
    
    
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func criarReceita(_ dados: NovaReceita) throws -> ReceitaModel {
        
        let receita = Receita(context: context)
        
        receita.id = UUID()
        receita.nome = dados.nome
        receita.categoria = dados.categoria.rawValue
        receita.foto = dados.foto
        receita.porcoes = dados.porcoes ?? 1
        receita.duracao = dados.duracao
        receita.utensilios = dados.utensilios
        receita.modoPreparo = dados.modoPreparo
        receita.favorito = false
        receita.dataCriacao = Date()
        
        for dadosIngrediente in dados.ingredientes {
            
            let ingrediente = Ingrediente(context: context)
            
            ingrediente.id = UUID()
            ingrediente.nome = dadosIngrediente.nome
            ingrediente.quantidade = dadosIngrediente.quantidade
            ingrediente.unidade = dadosIngrediente.unidade.rawValue
            
            receita.addToIngredientes(ingrediente)
        }
        
        try context.save()
        
        return converterReceita(receita)
    }
    
    
    
    func buscarReceitas() throws -> [ReceitaModel] {
        
        let request: NSFetchRequest<Receita> = Receita.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Receita.dataCriacao,
                ascending: false
            )
        ]
        
        let receitas = try context.fetch(request)
        
        return receitas.map { converterReceita($0) }
    }
    
    
    
    func buscarReceitas(texto: String) throws -> [ReceitaModel] {
        
        let request: NSFetchRequest<Receita> = Receita.fetchRequest()
        
        if !texto.isEmpty {
            request.predicate = NSPredicate(
                format: "nome CONTAINS[cd] %@",
                texto
            )
        }
        
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Receita.dataCriacao,
                ascending: false
            )
        ]
        
        let receitas = try context.fetch(request)
        
        return receitas.map { converterReceita($0) }
    }
    
    
    func buscarReceita(id: UUID) throws -> ReceitaModel? {
        
        let request: NSFetchRequest<Receita> = Receita.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        request.fetchLimit = 1
        
        guard let receita = try context.fetch(request).first else {
            return nil
        }
        
        return converterReceita(receita)
    }
    

    
    func atualizarReceita(
        _ receita: ReceitaModel,
        nome: String,
        categoria: Categoria,
        porcoes: Int16?,
        duracao: Int64,
        utensilios: String?,
        modoPreparo: String
    ) throws {
        
        let request: NSFetchRequest<Receita> = Receita.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "id == %@",
            receita.id as CVarArg
        )
        
        request.fetchLimit = 1
        
        guard let receitaCoreData = try context.fetch(request).first else {
            return
        }
        
        receitaCoreData.nome = nome
        receitaCoreData.categoria = categoria.rawValue
        receitaCoreData.porcoes = porcoes ?? 1
        receitaCoreData.duracao = duracao
        receitaCoreData.utensilios = utensilios
        receitaCoreData.modoPreparo = modoPreparo
        
        try context.save()
    }
    

    func atualizarFavorito(
        _ receita: ReceitaModel,
        favorito: Bool
    ) throws {
        
        let request: NSFetchRequest<Receita> = Receita.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "id == %@",
            receita.id as CVarArg
        )
        
        request.fetchLimit = 1
        
        guard let receitaCoreData = try context.fetch(request).first else {
            return
        }
        
        receitaCoreData.favorito = favorito
        
        try context.save()
    }
    
    func deletarReceita(_ receita: ReceitaModel) throws {
        
        let request: NSFetchRequest<Receita> = Receita.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "id == %@",
            receita.id as CVarArg
        )
        
        request.fetchLimit = 1
        
        if let receitaCoreData = try context.fetch(request).first {
            context.delete(receitaCoreData)
            try context.save()
        }
    }
    
    
    private func converterReceita(_ receita: Receita) -> ReceitaModel {
        
        guard let categoria = Categoria(
            rawValue: receita.categoria
        ) else {
            fatalError(
                "Categoria inválida: \(receita.categoria)"
            )
        }
        
        let ingredientes = (receita.ingredientes as? Set<Ingrediente> ?? [])
            .compactMap { ingrediente -> IngredienteModel? in
                
                guard let unidade = UnidadeMedida(
                    rawValue: ingrediente.unidade
                ) else {
                    return nil
                }
                
                return IngredienteModel(
                    id: ingrediente.id,
                    nome: ingrediente.nome,
                    quantidade: ingrediente.quantidade,
                    unidade: unidade
                )
            }
        
        let comentarios = (receita.comentarios as? Set<Comentario> ?? [])
            .map { comentario in
                
                ComentarioModel(
                    id: comentario.id,
                    descricao: comentario.descricao,
                    data: comentario.data
                )
            }
        
        return ReceitaModel(
            id: receita.id,
            nome: receita.nome,
            categoria: categoria,
            favorito: receita.favorito,
            dataCriacao: receita.dataCriacao,
            foto: receita.foto,
            porcoes: receita.porcoes,
            duracao: receita.duracao,
            utensilios: receita.utensilios,
            modoPreparo: receita.modoPreparo ?? " ",
            ingredientes: ingredientes,
            comentarios: comentarios
        )
    }
}
