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
    
    func update(r:ReserveSw){
        icon.text = "💾"
        service.text = String(r.serviceId)
        bookinS.text = r.booking_start
        BookingE.text = r.booking_end
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
