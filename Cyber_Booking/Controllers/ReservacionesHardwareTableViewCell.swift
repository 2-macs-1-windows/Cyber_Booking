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
    
    func update(r:ReserveHw){
        iconoLabel.text = "📟"
        nombreLabel.text = r.serviceId
        fechaEndLabel.text = r.booking_end
        
        if r.active == 1{
            statusLabel.text = "Activa"
            statusLabel.textColor = myGreen
        }
        else{
            statusLabel.text = "Inactiva"
            statusLabel.textColor = myRed
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
