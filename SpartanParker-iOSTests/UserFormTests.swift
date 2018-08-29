//
//  UserFormTests.swift
//  SpartanParker-iOSUITests
//
//  Created by DAVID HUANG on 8/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class UserFormTests: XCTestCase {
    
    var userForm: UserForm!
    var fields: [TextField]!
    
    override func setUp() {
        super.setUp()
        userForm = UserForm()
        fields = [
            TextField(placeHolder: "Test Field 1", key: "field1"),
            TextField(placeHolder: "Test Field 2", key: "field2"),
        ]
    }
    
    func test_insertField() {
        
        userForm.insertRow(textField: fields[0])
        XCTAssertTrue(userForm.inputFields.first == fields[0])
    }
    
    func test_insertMultipleFieldsInRow() {
        
        userForm.insertRow(textFields: [fields[0], fields[1]])
        XCTAssertTrue(userForm.inputFields.first == fields[0])
        XCTAssertTrue(userForm.inputFields.last  == fields[1])
    }
    
    func test_allInputs() {
        
        let emptyFields = userForm.allInputs()
        XCTAssertNil(emptyFields)
        
        userForm.insertRow(textField: fields[0])
        userForm.insertRow(textField: fields[1])
        
        let emptyInputs = userForm.allInputs()
        XCTAssertNotNil(emptyInputs)
        XCTAssertTrue(emptyInputs!["field1"] == "")
        XCTAssertTrue(emptyInputs!["field2"] == "")
        
        fields[0].inputField.text = "test input 1"
        fields[1].inputField.text = "test input 2"
        
        let inputs = userForm.allInputs()
        XCTAssertNotNil(inputs)
        XCTAssertTrue(inputs!["field1"] == "test input 1")
        XCTAssertTrue(inputs!["field2"] == "test input 2")
    }
    
    func test_invalidateView() {
        
        userForm.insertRow(textField: fields[0])
        XCTAssertTrue(userForm.inputFields.first == fields[0])
        userForm.invalidateView()
        XCTAssertTrue(userForm.inputFields.isEmpty)
        
        userForm.insertRow(textFields: [fields[0], fields[1]])
        XCTAssertTrue(userForm.inputFields.first == fields[0])
        XCTAssertTrue(userForm.inputFields.last  == fields[1])
        userForm.invalidateView()
        XCTAssertTrue(userForm.inputFields.isEmpty)
    }
    
    func test_userDidSelectContinue() {
        
        class SpyUserForm: UserFormDelegate {
            var continueSelected: Bool = false
            func userFormDidSelectContinue(_ userForm: UserForm) {
                continueSelected = true
            }
        }
        
        let spyUserForm = SpyUserForm()
        userForm.userFormDelegate = spyUserForm
        userForm.userDidSelectContinue()
        XCTAssertTrue(spyUserForm.continueSelected)
    }
}
