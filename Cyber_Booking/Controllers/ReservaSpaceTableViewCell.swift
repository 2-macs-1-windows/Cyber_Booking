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
        labelLugar.text = String(r.serviceId)
        labelFecha.text = r.booking_start
        labelEstatus.text = String(r.active)
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
