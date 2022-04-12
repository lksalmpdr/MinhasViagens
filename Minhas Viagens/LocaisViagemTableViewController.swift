//
//  LocaisViagemTableViewController.swift
//  Minhas Viagens
//
//  Created by Pedro Lucas de Almeida on 29/12/21.
//

import UIKit

class LocaisViagemTableViewController: UITableViewController {
    
    var locaisViagem: [Viagem] = []
    var gestaoArmazenamento = ArmazenamentoDados()
    var controleNavegacao = "adicionar"

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = "adicionar"
        atualiazarViagens()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locaisViagem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_reusable", for: indexPath)

        let viagem = locaisViagem[indexPath.row]
        
        cell.textLabel?.text = viagem.localNome

        return cell
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete{
            gestaoArmazenamento.removerViagem(index: indexPath.row)
        }
        atualiazarViagens()
    }
    
    func atualiazarViagens(){
        locaisViagem = gestaoArmazenamento.listarViagens() ?? []
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verLocal"{
            let vcDestino = segue.destination as! ViewController
            
            if self.controleNavegacao == "ver"
            {
                if let indiceRecuperado = sender
                {
                    let indice  = indiceRecuperado as! Int
                    vcDestino.viagem = locaisViagem[ indice ]
                    vcDestino.indiceSelecionado = indice
                }
            }else{
                vcDestino.viagem = Viagem(localNome: "", latitude: "", longitude: "")
                vcDestino.indiceSelecionado = -1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controleNavegacao = "ver"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }

}
