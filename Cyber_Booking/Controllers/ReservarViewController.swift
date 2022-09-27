//
//  ReservarViewController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 31/8/22.
//

/*
 TODO
 - Alerta después de apretar el botón
 */

import UIKit

class ReservarViewController: UIViewController {
    
    // --- TextField outlets ---
    @IBOutlet weak var salonTextField: UITextField!
    @IBOutlet weak var duracionTextField: UITextField!
    @IBOutlet weak var fechaHoraTextField: UITextField!
    
    // --- lista de opciones ---
    // FALTA CONECTAR CON DB
    let salones = ["S-1", "S-2", "S-3", "S-4"]
    let duraciones = ["1 hora", "2 horas", "3 horas", "4 horas"]
    
    // --- PickerViews de las opciones ---
    var salonPickerView = UIPickerView()
    var duracionPickerView = UIPickerView()
    let fechaHoraPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fecha y hora
        createDatepicker()
        
        // tomar las opciones del pickView en el textField visualmente
        salonTextField.inputView = salonPickerView
        duracionTextField.inputView = duracionPickerView
        
        // obtener las opciones internamente
        salonPickerView.delegate = self
        salonPickerView.dataSource = self
        
        duracionPickerView.delegate = self
        duracionPickerView.dataSource = self
        
        // --- Agregar tag a los pickerView ---
        salonPickerView.tag = 1
        duracionPickerView.tag = 2
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
        fechaHoraPicker.preferredDatePickerStyle = .wheels
        fechaHoraTextField.inputView = fechaHoraPicker
        fechaHoraTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        // formato de la fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        self.fechaHoraTextField.text = dateFormatter.string(from: fechaHoraPicker.date)
        self.view.endEditing(true)
    }
}

// extension UIPickerViewDelegate
extension ReservarViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Número de componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de renglones
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // va a regresar dependiendo del tag el número de row
        switch pickerView.tag {
        case 1:
            return salones.count
        case 2:
            return duraciones.count
        default:
            return 1
        }
    }
    
    // Obtener las opciones para el pickView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            return salones[row]
        case 2:
            return duraciones[row]
        default:
            return "Data not found"
        }
    }
    
    // Que hacer con la opción selecionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // va a regresar dependiendo del tag el dato de la lista
        switch pickerView.tag {
        case 1:
            salonTextField.text = salones[row]
            salonTextField.resignFirstResponder()
        case 2:
            duracionTextField.text = duraciones[row]
            duracionTextField.resignFirstResponder()
        default:
            return
        }
    }
}

