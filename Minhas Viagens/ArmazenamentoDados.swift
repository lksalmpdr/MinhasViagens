//
//  ArmazenamentoDados.swift
//  Minhas Viagens
//
//  Created by Pedro Lucas de Almeida on 22/03/22.
//

import UIKit

struct Viagem: Codable{
    let localNome:String
    let latitude:String
    let longitude:String

}

class ArmazenamentoDados
{
    
    let chaveSalvamento: String = "minhasViagensSalvas"
    
    var viagens: [Viagem] = []
    
    func getDefaults() -> UserDefaults
    {
        return UserDefaults.standard
    }
    
    func salvarViagem(_ localNome:String, _ latitude:String, _ longitude:String)
    {
        viagens = listarViagens() ?? []
        let viagem = Viagem(localNome: localNome, latitude: latitude, longitude: longitude)
        viagens.append(viagem)
        
        let viagensEncoded = try? PropertyListEncoder().encode(viagens)
        
        getDefaults().set(viagensEncoded, forKey: chaveSalvamento)
        getDefaults().synchronize()
    }
    
    func listarViagens() -> [Viagem]?
    {
        if let data = getDefaults().value(forKey: chaveSalvamento) as? Data {
            let viagens:[Viagem]? = try? PropertyListDecoder().decode(Array<Viagem>?.self, from: data)
            return viagens
        }else{
            return []
        }
    }
    
    func removerViagem(index:Int)
    {
        var viagens = listarViagens()
        viagens?.remove(at: index)
        
        let viagensEncoded = try? PropertyListEncoder().encode(viagens)
        
        getDefaults().set(viagensEncoded, forKey: chaveSalvamento)
        getDefaults().synchronize()
        
    }
}
