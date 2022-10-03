//
//  ReservaSpaceTableViewCell.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

import UIKit

class ReservaSpaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelIcono: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelEstatus: UILabel!
    
    let myGreen = UIColor(
        red:37/255,
        green:182/255,
        blue:37/255,
        alpha:1.0)
    
    let myRed = UIColor(
        red:209/255,
        green:44/255,
        blue:44/255,
        alpha:1.0)
    
    func update(r:ReserveSpace){
        labelIcono.text = "🚪"
        labelLugar.text = String(r.nameService)
        labelFecha.text = r.booking_start
        // labelEstatus.text = String(r.active)
        
        if r.active == 1{
            labelEstatus.text = "Activa"
            labelEstatus.textColor = myGreen
        }
        else {
            labelEstatus.text = "Inactiva"
            labelEstatus.textColor = myRed
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
