//
//  Mail_trackerTests.swift
//  Mail trackerTests
//
//  Created by Antonia Schmidt-Lademann on 06/11/2016.
//  Copyright © 2016 Antonia Schmidt-Lademann. All rights reserved.
//

import XCTest
@testable import Mail_tracker

class Mail_trackerTests: XCTestCase {
    //MARK: MailTracker Tests
    
    //Tests to confirm that the Item initialiser returns when no name or a non 0 or 1 sent value is provided
    func testItemInitialisation(){
        //Success case
        let potentialItem = Item(name: "newest item", photo: nil, sent: 0)
        XCTAssertNotNil(potentialItem)
        
        //Failure cases
        let noName = Item(name: "", photo: nil, sent: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badSentValue = Item(name: "Marito", photo: nil, sent: 2)
        XCTAssertNil(badSentValue, "Sent has to be either 0 or 1")
    
    }
}
