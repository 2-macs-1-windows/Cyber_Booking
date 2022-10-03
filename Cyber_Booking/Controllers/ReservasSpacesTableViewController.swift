//
//  ReservasHistorialTableViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

/*
 - DATA SOURCE
 - DELEGATE
*/

import UIKit

class ReservasHistorialTableViewController: UITableViewController {

    // DATA SOURCE
    // se inicializan las reservas
    //var reservasHw = ReserveHw.listaReserveHw()
    //var reservasSw = ReserveSw.listaReserveSw()
    var reservaControlador = ReservaSpacesController()
    var reservasSpaces = ReservasSpaces()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            do{
                let reservas = try await reservaControlador.fetchReservas()
                updateUI(with: reservas)
            }catch{
                displayError(ReservaError.itemNotFound, title: "No se pudo acceder a las reservas")
            }
            
            
        }

    }
    
    func updateUI(with reservas:ReservasSpaces){
        DispatchQueue.main.async {
            self.reservasSpaces = reservas
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
        
        return reservasSpaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath) as! ReservaSpaceTableViewCell

        // Configure the cell...
        let indice = indexPath.row
        let reserva = reservasSpaces[indice]
        cell.update(r: reserva)

        cell.showsReorderControl = true

        return cell
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
            tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = reservasSpaces.remove(at: fromIndexPath.row)
        reservasSpaces.insert(movedEmoji, at: to.row)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            reservasSpaces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
