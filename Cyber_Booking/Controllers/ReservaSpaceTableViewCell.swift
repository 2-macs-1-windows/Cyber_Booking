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

    func update(r:ReserveSpace){
        labelIcono.text = "🚪"
        labelLugar.text = String(r.nameService)
        labelFecha.text = r.booking_start
        // labelEstatus.text = String(r.active)
        
        if r.active{
            labelEstatus.text = "Activa"
            labelEstatus.textColor = UIColor.green
        }
        else {
            labelEstatus.text = "Inactiva"
            labelEstatus.textColor = UIColor.red
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
