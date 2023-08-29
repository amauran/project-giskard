*** Settings ***
Documentation        This test will try out things from both customer and shop manager sides.

### WHAT WILL BE TESTED ###

# The test will run in a single browser window, so customer and manager will log out when switching sides

# 1) customer will place an order
# 2) shop manager will find the order, edit to add a discount coupo, mark the order as completed and save it.
# 3) customer will check new order to see a discount has been applied and the order is marked 'completed'
# 4) shop manager will find the order again, and delete it.

# NOTE: For test purposes the payment method is set to 'cash on delivery',
# as we could not use any real payment methods at this stage.
# (The order status must first be changed to 'pending payment' or it can't be edited)

# NOTE: This test implements a lot of user defined keywords from resource file
# 1) a wrapper for either Seleniumlibrary or Browser library (chosen in the variables.yaml)
# 2) user or admin action keywords as needed


### IMPORTS ###

# importing variable files with test environment specific variables and locators
Variables       ../Resources/Environment/variables.yaml
Variables       ../Resources/Environment/locators.yaml

# this file contains the names of the product types in shop, used for adding items to cart
Variables       ../Resources/Environment/product_names.yaml

# import environment-indicated keyword wrapper (selenium or browser)
Resource        ../Resources/Keywords/Wrappers/${wrapper}_wrapper.resource

# import user created keywords for customer actions, and manager actions
Resource        ../Resources/Keywords/Actions/customer_actions.resource
Resource        ../Resources/Keywords/Actions/manager_actions.resource


### SETUP AND TEARDOWN FOR THIS TEST SUITE

# As test suite setup, open a new browser window (will remain open through all of the tests)
# NOTE: do this here, not in the external keyword files or inside test segments (only need to do it once)
Suite Setup      Open New Browser Window            ${browser}

# For test suite teardown, close all open browsers (should be only one open by the end, but still)
Suite Teardown   Close All Open Browsers


*** Variables ***
# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}


*** Test Cases ***
Login As Customer To Make An Order
    ### the customer logs in, adds procucts to cart and places the order

    Login As Existing Customer
    # add one of each product type into the shopping cart (search for each one first)
    Customer Adds Products To Cart
    # go to cart and check number of product types and quantities match
    Customer Goes To Shopping Cart
    Customer Checks Shopping Cart Items
    # go to checkout, and leave a thank you message
    Customer Proceeds To Checkout
    Customer Says Thank You In Comment Box
    # complete the order and make sure it went through
    Customer Places Order
    Customer Checks The Order Was Succesful

    # save the number of the order just placed in a local variable
    ${number_of_order_made} =   Save New Order Number

    # create a test suite wide variable and transfer the number there
    # (so it can be used by other keywords elsewhere in the suite)
    Set Suite Variable   \${new_order_number}   ${number_of_order_made}

    # customer logs out at this point so manager can take over
    Logout Customer From Shop


Login As Manager To Edit Order
    ### the manager logs in and finds the previously made order by order number, and adds a discount coupon
    # NOTE: a browser page should be left open from the previous section, no need to open a new one

    Login As Shop Manager

    # NOTE: this step is needed for the menu locators to work!!!
    # (because they are based on menu text items that are only visible when the menu is expanded)
    Confirm Sidebar Menu Is Expanded

    Manager Goes To Order Handling Page
    # the next step uses the previously saved order number of the order the customer just made
    Manager Finds And Opens A Placed Order        ${new_order_number}
    # the order status needs to be changed for the order to be editable
    Manager Edits Order Status To Pending Payment
    # add predefined discount coupon code to the order
    Manager Adds A Discount Coupon To Order
    # after adding the coupon, scroll up to reveal order status again (was not visible)
    Scroll To Selected Element    ${manager_orderstatus}
    # then mark the order as processed and completed
    Manager Marks Order As Processed And Completed
    # manager logs out at this point
    Logout Shop Manager


Login As Customer To Check Order Status
### Customer logs in to view order, to see a discount has been added and the order has been completed
# NOTE: a browser page should be left open from the previous section, no need to open a new one

    Login As Existing Customer
    Customer Goes To Order Handling Page

    # find correct order by order number and view it (in this test case the newest order made)
    Customer Finds And Opens A Placed Order    ${new_order_number}

    # check coupon has been added and order has been marked as 'Completed'
    Customer Confirms Discount Added
    Customer Confirms Order Status Completed

    # customer logs out at this point
    Logout Customer From Shop


Login As Manager To Delete Order
### Manager logs in to find order again, and delete it now that it's completed
# NOTE: a browser page should be left open from the previous section, no need to open a new one

    Login As Shop Manager
    Manager Goes To Order Handling Page

    # find specified order, view it, then delete it and empty the bin
    Manager Finds And Opens A Placed Order    ${new_order_number}
    Manager Deletes A Placed Order
    Manager Empties Bin Of Deleted Orders

    # manager logs out, test will go to teardown
    Logout Shop Manager


*** Keywords ***


*** Comments ***

While using the same browser window, the customer has to log out before the admin can log in, and vice versa.
This is to ensure the current user is who it's supposed to be.

