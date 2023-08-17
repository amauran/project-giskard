*** Settings ***
Documentation        This test will try out things from both customer and shop manager sides.

### WHAT WILL BE TESTED ###

# The test will run in a single browser window, so customer and manager will log out when switching sides

# 1) customer will place an order (for test purposes the payment method is set to cash on delivery)
# 2) shop manager will find the order, edit it (add coupon), mark the order as completed and save it.
# 3) customer will check new order to see coupon has been applied and the order is processed
# 4) shop manager will find the order again, and delete it.

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


### SETUP AND TEARDOWN

# As test setup, open a new browser page
# (do this here, not in external keyword files or inside test segments)

Test Setup      Open New Browser Window            ${browser}
# For test teardown, close all open browsers (should be only one, but still)
Test Teardown   Close All Open Browsers


*** Variables ***
# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}


*** Test Cases ***
Login As Customer To Make An Order
    # the customer logs in, adds procucts to cart and places the order
    Login As Existing Customer
    Add Products To Cart
    Go To Shopping Cart
    Check Shopping Cart Items
    Proceed To Checkout
    Say Thank You In Comment Box
    Complete Order

    # this is used here when testing partial segments, cart needs to be cleared then
    # Clear Shopping Cart

    # customer logs out at this point so manager can take over
    Logout Customer From Shop


# Login As Manager To Edit Order

#     Login As Shop Manager
#     Logout Shop Manager


# Find Order, Add Coupon, Process Order

    # admin logs out at this point


# Login As Customer To Check Order Status
# NOTE: a browser page should be left open from the previous section, no need to open a new one
#     # set local variable 'usertype' value to 'customer' for this part of testing
#     Set Local Variable                 ${usertype}          customer

#     Open New Browser Window            ${browser}
#     Go To Given Page                   ${login_url}
#     Fill Text Field With Input         ${username_field}    ${users}[${usertype}][username]
#     Fill Password Field With Input     ${password_field}    ${users}[${usertype}][password]
#     Click Selected                     ${login_button}
#     Check Location By Element          ${checkforpass}      # check login succeeded

#     # go to orders page, view order
    # Click Selected    ${orders_link}
    # Check Location By URL    ${orders_url}

#     # check coupon has been added
#     # check order has been marked as processed


#     # customer logs out at this point



# # Login As Manager To Delete Order
# NOTE: a browser page should be left open from the previous section, no need to open a new one
#     # set local variable 'usertype' value to 'admin' for this part of testing
#     Set Local Variable                 ${usertype}          manager

#     # go to login page and fill username and password

#     Fill Text Field With Input         ${username_field}    ${users}[${usertype}][username]
#     Fill Password Field With Input     ${password_field}    ${users}[${usertype}][password]

#     # check location
#     # find order, view, delete



*** Keywords ***


*** Comments ***

While using the same browser window, the customer has to log out before the admin can log in, and vice versa.
This is to ensure the current user is who it's supposed to be.