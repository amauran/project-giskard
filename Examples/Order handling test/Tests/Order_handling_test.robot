*** Settings ***
Documentation        This test will try out things from both customer and shop manager sides.

### WHAT WILL BE TESTED ###

# The test will run in a single browser window, so customer and manager will log out when switching sides

# 1) customer will place an order
# 2) shop manager will find the order, edit it (add coupon), mark the order as completed and save it.
# 3) customer will check new order to see a discount has been applied and the order is marked 'completed'
# 4) shop manager will find the order again, and delete it.

# NOTE: For test purposes the payment method is set to 'cash on delivery',
# as we did not want to use any real payment methods at this stage.
# The order status must first be changed to 'pending payment' or it can't be edited)

# NOTE: This test implements user defined keywords
# 1) a wrapper for either Seleniumlibrary or Browser library
# 2) user or admin action keywords as needed


### IMPORTS ###

# importing variable files with test environment specific variables and locators
Variables       ../Resources/Environment/variables.yaml
Variables       ../Resources/Environment/locators.yaml
Variables       ../Resources/Environment/product_names.yaml

# import environment-indicated keyword wrapper (selenium or browser)
Resource        ../Resources/Keywords/Wrappers/${wrapper}_wrapper.resource

# import user created keywords for customer actions, and manager actions
Resource        ../Resources/Keywords/Actions/customer_actions.resource
Resource        ../Resources/Keywords/Actions/manager_actions.resource


### SETUP AND TEARDOWN FOR THIS TEST SUITE

# As test suite setup, open a new browser window (will remain open through all tests)
# (do this here, not in external keyword files or inside test segments)
Suite Setup      Open New Browser Window            ${browser}

# For test suite teardown, close all open browsers (should be only one open by the end, but still)
Suite Teardown   Close All Open Browsers


*** Variables ***
# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}


*** Test Cases ***
Login As Customer To Make An Order
    # the customer logs in, adds procucts to cart and places the order
    Login As Existing Customer
    # add one of each product type into the shopping
    Add Products To Cart
    # go to cart and check number of product types and quantities match
    Go To Shopping Cart
    Check Shopping Cart Items
    # go to checkout, and leave a thank you message
    Proceed To Checkout
    Say Thank You In Comment Box
    # complete the order and make sure it went through
    Complete Order
    Check Order Was Succesful

    # save the number of the order just placed in a local variable
    ${number_of_order_made} =   Save New Order Number

    # create a test suite wide variable and transfer the number there
    # (so it can be used by other keywords elsewhere in the suite, including external keyword files)
    Set Suite Variable   \${new_order_number}   ${number_of_order_made}

    # debugging to see if that worked
    Log    ${new_order_number}

#     # this is used here when testing partial segments, cart needs to be cleared then
#     # Clear Shopping Cart

    # customer logs out at this point so manager can take over
    Logout Customer From Shop


Login As Manager To Edit Order
    # the manager logs in and finds the previously made order by order number, and adds a discount coupon
    # NOTE: a browser page should be left open from the previous section, no need to open a new one

    Login As Shop Manager

    # NOTE: this step is needed for the menu locators to work!!!
    # (they are based on menu text that is only visible when menu is expanded)
    Confirm Sidebar Menu Is Expanded

    Go To Orders Page
    # the next step uses the previously saved order number of the order the customer just made
    Find Order And View It        ${new_order_number}
    # the order status needs to be changed for the order to be editable
    Edit Order Status To Pending Payment
    # add predefined discount coupon code to the order
    Add Discount Coupon To Order
    # after adding the coupon, scroll up to reveal order status again (was not visible)
    Scroll To Selected Element    ${manager_orderstatus}
    # then mark the order as processed and completed
    Mark Order As Processed And Completed

    Logout Shop Manager



Login As Customer To Check Order Status
# NOTE: a browser page should be left open from the previous section, no need to open a new one
    Login As Existing Customer

    # go to orders page, view order
    Click Selected Element        ${orders_link}
    Check Location By URL         ${orders_url}

    # find correct order by order number (in this test case the newest order made)
    Find And Open Placed Order    ${new_order_number}

    # check coupon has been added and order has been marked as processed
    Confirm Discount
    Confirm Order Completed

    # customer logs out at this point
    Logout Customer From Shop

Login As Manager To Delete Order
# NOTE: a browser page should be left open from the previous section, no need to open a new one

    # login and go to order handling page
    Login As Shop Manager
    Go To Orders Page

    # find specified order, view it, then delete
    Find Order And View It    ${new_order_number}
    Delete Single Order
    Empty Bin Of Deleted Orders

    Logout Shop Manager



*** Keywords ***


*** Comments ***

While using the same browser window, the customer has to log out before the admin can log in, and vice versa.
This is to ensure the current user is who it's supposed to be.