//
//  FitnessTests.swift
//  FitnessTests
//
//  Created by Gabriela Sanchez on 29/01/26.
//

import XCTest
@testable import Fitness

final class FitnessTests: XCTest {
    var vm: AppViewModel!
    
    override func setUp() {
            super.setUp()
            // Clear UserDefaults so each test starts with a clean slate
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
            vm = AppViewModel()
        }
        
        override func tearDown() {
            vm = nil
            super.tearDown()
        }

    /*
     Unit Test: Verifying Cancellation and Credit Refunds

         Objective: Test the array manipulation and refund logic when a user drops a class.

         Student Instructions:

             Instantiate the AppViewModel and set availableCredits to 5.

             Create a mock Session and book it using bookSpot(session:).

             Verify that bookedClasses contains exactly 1 item.

             Call the cancelBooking(session:) method using the exact same session object.

             Assert that the bookedClasses array is now empty.

             Assert that the availableCredits property has updated back to 5.
     */
}
