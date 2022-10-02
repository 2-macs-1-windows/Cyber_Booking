//
//  ReservacionesHardwareTableViewCell.swift
//  Cyber_Booking
//
//  Created by user224407 on 10/2/22.
//

import UIKit

class ReservacionesHardwareTableViewCell: UITableViewCell {

    @IBOutlet weak var iconoLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var fechaEndLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    func update(r:ReserveHw){
        iconoLabel.text = "📱"
        nombreLabel.text = String(r.id)
        fechaEndLabel.text = r.booking_end
        
        if r.active{
            statusLabel.text = "Activa"
            statusLabel.textColor = UIColor.green
        }
        else{
            statusLabel.text = "Inactiva"
            statusLabel.textColor = UIColor.red
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
