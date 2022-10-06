//
//  ResvSwTableViewCell.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 2/10/22.
//

import UIKit

class ResvSwTableViewCell: UITableViewCell {

    
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var bookinS: UILabel!
    @IBOutlet weak var BookingE: UILabel!
    
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

    func update(r:ReserveSw){
        icon.text = "💾"
        service.text = r.service_id
        bookinS.text = r.booking_end

        if r.active == 1{
            BookingE.text = "Activa"
            BookingE.textColor = myGreen
        }
        else{
            BookingE.text = "Inactiva"
            BookingE.textColor = myRed
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
