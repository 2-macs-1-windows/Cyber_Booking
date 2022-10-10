//
//  Cyber_BookingTests.swift
//  Cyber_BookingTests
//
//  Created by Victoria Estefania Vazquez Morales on 9/10/22.
//

import XCTest
@testable import Cyber_Booking // importar tu app

final class Cyber_BookingTests: XCTestCase {
    
    var sut:loginViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //Instanciar el viewController donde se hace la prueba
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                sut = storyboard.instantiateViewController(withIdentifier: "login") as? loginViewController
                
                sut.loadViewIfNeeded()
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogin() {
        // Se prueba que el usuario pueda iniciar sesión
        
        // given
        sut.correoTextField.text! = "admin@admin.com"
        sut.passTextField.text! = "adminAdmin#1"
        
        //when
        sut.makeLogin(sut.loginButton)
        
        print(sut.correoTextField.text ?? "")
        print(sut.passTextField.text ?? "")
        
        //then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        
            XCTAssertTrue(self.sut.appDelegate.user_id != -1, " User_id = \(self.sut.appDelegate.user_id)")
        }
        
    }
    
}
