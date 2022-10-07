//
//  ReservasHardwareTableViewController.swift
//  Cyber_Booking
//
//  Created by user224407 on 10/2/22.
//

import UIKit

class ReservasHardwareTableViewController: UITableViewController {
    
    var reservaControlador = ReservaHwController()
    var reservas = ReservasHw()
    
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
    
    func updateUI(with reservas:ReservasHw){
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zeldaHw", for: indexPath) as! ReservacionesHardwareTableViewCell

        // Configure the cell...
        let indice = indexPath.row
        let reserva = reservas[indice]
        cell.update(r: reserva)
        
        cell.showsReorderControl = true

        return cell
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
            tableView.setEditing(!tableViewEditingMode, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    
    // Override to support editing the table view.
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
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = reservas.remove(at: fromIndexPath.row)
        reservas.insert(movedEmoji, at: to.row)

    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
