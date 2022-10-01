//
//  ReserveSwTableViewCell.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 1/10/22.
//

import UIKit

class ReserveSwTableViewCell: UITableViewCell {

    @IBOutlet weak var Icon: UILabel!
    @IBOutlet weak var Service: UILabel!
    @IBOutlet weak var Book_S: UILabel!
    @IBOutlet weak var Book_E: UILabel!
    
    func update(r:ReserveSw){
        //Icon.text = r.icono
        Service.text = String(r.serviceId)
        Book_S.text = r.booking_start
        Book_E.text = r.booking_end
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
