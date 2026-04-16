//
//  FitnessUITests.swift
//  FitnessUITests
//
//  Created by Gabriela Sanchez on 29/01/26.
//

import XCTest

final class FitnessUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")
        app.launch()
    }
    
    /*
     UI Tests (Testing XCUITest Navigation and State)

     1. UI Test: The Credit Purchase Flow

         Objective: Verify that interacting with the ShopView correctly updates the user's global state and reflects on other tabs.

         Student Instructions:

             Launch the app using XCUIApplication().

             Tap the "Shop" tab bar item.

             Locate and tap the button containing the text "Starter Pack" (which adds 5 credits).

             Tap the "Profile" tab bar item to navigate away from the shop.

             Locate the static text displaying the available credits. Assert that the text value is "15" (assuming the default starting value of 10 plus the new 5).
     */
     
     func testCreditPurchaseFlow() {
         // Students: Write your test code here
     }

     /*
     2. UI Test: Spot Selection and Detail Navigation

         Objective: Test the NavigationStack routing and ensure dynamic elements (like the studio map grid) enable properly.

         Student Instructions:

             Launch the app and ensure you are on the "Schedule" tab.

             Locate and tap the "Hot Pilates" class cell to trigger the navigation to ClassDetailView.

             Assert that the navigation bar title now reads "Hot Pilates".

             Locate the sticky bottom booking button. Assert that it exists but its isEnabled property is false (since no spot is selected).

             Tap a grid item representing an available spot (e.g., spot "1").

             Assert that the bottom booking button's isEnabled property is now true.
     */
     
     func testSpotSelectionAndDetailNavigation() {
         // Students: Write your test code here
     }
}
