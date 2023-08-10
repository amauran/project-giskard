*** Settings ***
Documentation        This test will try out things from both customer and shop manager sides

# 1) customer will place an order (for test purposes the payment method is set to cash on delivery)
# 2) shop manager will find the order, edit it (add coupon), mark the order as completed and save it.
# 3) customer will check new order to see coupon has been applied and the order is processed
# 4) shop manager will find the order again, and delete it.

# NOTE: This test implements user defined keywords
# 1) a wrapper for either Seleniumlibrary or Browser library
# 2) user or admin action keywords as needed

# importing variable files with test environment specific variables and locators
Variables       ../Resources/Environment/variables.yaml
Variables       ../Resources/Environment/locators.yaml
Variables       ../Resources/Environment/product_names.yaml

# import password file with customer and manager login info (this is in gitignore!!!)
Variables        ../Resources/Environment//shop_loginpwds.yaml

# import environment-indicated keyword wrapper (selenium or browser)
Resource    ../Resources/Keywords/Wrappers/${wrapper}_wrapper.resource

# import user created keywords for user actions, and manager actions
Resource        ../Resources/Keywords/Actions/user_actions.resource
Resource        ../Resources/Keywords/Actions/manager_actions.resource


*** Variables ***
# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}

*** Test Cases ***
# Login As Customer To Make Order
#     # set local variable 'usertype' value to 'customer' for this part of testing
#     Set Local Variable                 ${usertype}          customer

#     Open New Browser Window            ${browser}
#     Go To Given Page                   ${login_url}
#     Fill Text Field With Input         ${username_field}    ${users}[${usertype}][username]
#     Fill Password Field With Input     ${password_field}    ${users}[${usertype}][password]
#     Click Selected                     ${login_button}

#     # check login succeeded (should be on My Accounts page and find element 'Account details')
#     Check Location By Element          ${checkforpass}

# Add Items To Cart And Place Order
#     Add Products To Cart

#     # customer logs out at this point




Login As Manager To Edit Order
    # set local variable 'usertype' value to 'admin' for this part of testing
    Set Local Variable                 ${usertype}        manager
    Set Local Variable                 ${manager_name}    ${users}[${usertype}][display_name]

    # go to login page and fill username and password
    Open New Browser Window            ${browser}
    Go To Given Page                   ${manager_login_url}

    Fill Text Field With Input         ${manager_username_field}    ${users}[${usertype}][username]
    Fill Password Field With Input     ${manager_password_field}    ${users}[${usertype}][password]
    Click Selected                     ${manager_login_button}

    # check location for successful login
    # (in this case, find the manager's display name, and compare to name on file)
    Wait Until Visible                 ${manager_checkforpass}
    ${text_found} =                    Get Element Text             ${manager_checkforpass}
    Should Be Equal                    ${manager_name}              ${text_found}




# Find Order, Add Coupon, Process Order



    # admin logs out at this point


# Login As Customer To Check Order Status
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
#     # set local variable 'usertype' value to 'admin' for this part of testing
#     Set Local Variable                 ${usertype}          manager

#     # go to login page and fill username and password

#     Fill Text Field With Input         ${username_field}    ${users}[${usertype}][username]
#     Fill Password Field With Input     ${password_field}    ${users}[${usertype}][password]

#     # check location
#     # find order, view, delete

[Teardown]    Close Current Browser


*** Keywords ***


*** Comments ***

While using the same browser windonw, the customer has to log out before the admin can log in, and vice versa.
This is to ensure the current user is who it's supposed to be.