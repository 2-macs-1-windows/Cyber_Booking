//
//  ReservarSoftwareViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 25/09/22.
//

// TODO arreglar los pickers

import UIKit

class ReservarSoftwareViewController: UIViewController {

    // --- TextField outlets ---
    @IBOutlet weak var softwareTextField: UITextField!
    // @IBOutlet weak var duracionTextField: UITextField!
    @IBOutlet weak var fechaInicioTextField: UITextField!
    @IBOutlet weak var fechaFinTextField: UITextField!
    
    // --- lista de opciones ---
    // FALTA CONECTAR CON DB
    let software = ["Adobe photo", "Packet Tracer", "Andorid Studio"]
    
    // --- PickerViews de las opciones ---
    var softwarePickerView = UIPickerView()
    
    let fechaInicioPicker = UIDatePicker()
    let fechaFinPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fecha y hora
        createDatepicker()
        
        // tomar las opciones del pickView en el textField visualmente
        softwareTextField.inputView = softwarePickerView
        
        // obtener las opciones internamente
        softwarePickerView.delegate = self
        softwarePickerView.dataSource = self
        
        
        // --- Agregar tag a los pickerView ---
        fechaInicioPicker.tag = 1
        fechaFinPicker.tag = 2
    }

    // --- Fecha y hora ---
    func createToolbar() -> UIToolbar {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createDatepicker() {
        
        // USAR LOS SWITCH TAL VEZ
        fechaInicioPicker.preferredDatePickerStyle = .wheels
        fechaInicioTextField.inputView = fechaInicioPicker
        fechaInicioTextField.inputAccessoryView = createToolbar()
        
        fechaFinPicker.preferredDatePickerStyle = .wheels
        fechaFinTextField.inputView = fechaFinPicker
        fechaFinTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        // formato de la fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // USAR LOS SWITCH
        
        self.fechaInicioTextField.text = dateFormatter.string(from: fechaInicioPicker.date)
        self.view.endEditing(true)
        
        self.fechaFinTextField.text = dateFormatter.string(from: fechaFinPicker.date)
        self.view.endEditing(true)
    }

}

// extension UIPickerViewDelegate
extension ReservarSoftwareViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Número de componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de renglones
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return software.count
        
        // va a regresar dependiendo del tag el número de row
        /*
        switch pickerView.tag {
        case 1:
            return software.count
        default:
            return 1
        }
         */
    }
    
    // Obtener las opciones para el pickView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return software[row]
        /*
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            return software[row]
        default:
            return "Data not found"
        }
         */
    }
    
    // Que hacer con la opción selecionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        softwareTextField.text = software[row]
        softwareTextField.resignFirstResponder()
        
        /*
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            softwareTextField.text = software[row]
            softwareTextField.resignFirstResponder()
        default:
            return
        }
         */
    }
}
