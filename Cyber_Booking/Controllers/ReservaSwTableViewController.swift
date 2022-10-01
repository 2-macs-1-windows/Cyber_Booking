//
//  ReservaSwTableViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 30/9/22.
//

import UIKit

class ReservaSwTableViewController: UITableViewController {

    var reservas = ReserveSw.listaReserveSw()
    var reserva:ReserveSw?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

  
    @IBAction func EditAction(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode,animated:true)
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = reservas.remove(at: fromIndexPath.row)
        reservas.insert(movedEmoji, at: to.row)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservSwCell", for: indexPath) as! ReserveSwTableViewCell

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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            reservas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
}
