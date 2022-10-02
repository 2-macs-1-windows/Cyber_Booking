//
//  ReservaHardwareTableViewCellController.swift
//  Cyber_Booking
//
//  Created by user224407 on 9/30/22.
//

import UIKit

class ReservaHardwareTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var labelIcono: UILabel!
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelFechaEnd: UILabel!
    @IBOutlet weak var labelEstatus: UILabel!
    
    
    func update(r:ReserveHw){
        labelIcono.text = "📱"
        labelNombre.text = String(r.serviceId)
        labelFecha.text = r.booking_start
        labelFechaEnd.text = r.booking_end
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
