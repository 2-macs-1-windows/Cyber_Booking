//
//  RservacionesSwTableViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 2/10/22.
//

import UIKit

class RservacionesSwTableViewController: UITableViewController {
    
    var reservaControlador = ReservaSwController()
    var reservas = ReservasSw()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            do{
                let reservas = try await reservaControlador.fetchReservas()
                updateUI(with: reservas)
                
                if reservas.isEmpty{
                    let alert = UIAlertController(title: "Sin reservas", message: "Aún no ha realizado ninguna reservación", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler:  nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }catch{
                displayError(ReservaError.itemNotFound, title: "No se pudo acceder a las reservas")
            }
            
            
        }
        
    }
    
    func updateUI(with reservas:ReservasSw){
        DispatchQueue.main.async {
            self.reservas = reservas
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reservas.count
    }

    @IBAction func editButtonRSw(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode,animated:true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedRow = reservas.remove(at: fromIndexPath.row)
        reservas.insert(movedRow, at: to.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResSwCell", for: indexPath) as! ResvSwTableViewCell

        // Configure the cell...
        let indice = indexPath.row
        
        let reserva = reservas[indice]
        cell.update(r: reserva)
        /*
        var content = cell.defaultContentConfiguration()
        content.text = reservas[indice].nombre
        content.secondaryText = reservas[indice].descripcion
        cell.contentConfiguration = content */
        cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            Task{
                do{
                    let registroEliminar = reservas[indexPath.row].id
                    try await self.reservaControlador.deleteReserva(registroID: registroEliminar)
                    // self.updateUI()
                }catch{
                    displayError(ReservaError.itemNotFound, title: "No se puede eliminar")
                }
            }
            
            reservas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
        
    }
    
    

}
