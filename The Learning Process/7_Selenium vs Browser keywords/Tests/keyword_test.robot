*** Settings ***
# NOTE: This test implements user defined keywords
# 1) a wrapper for either Seleniumlibrary or Browser library
# 2) user or admin action keywords as needed

# importing variable files with test environment specific variables and locators
Variables       ../Environment/variables.yaml
Variables       ../Environment/locators.yaml

Variables       ../Environment/product_names.yaml

# import password file (this is in gitignore!!!)
Variables        ../../Resources/shop_loginpwds.yaml

# import environment indicated keyword wrapper (selenium or browser)
Resource    ../Keywords/Wrappers/${wrapper}_wrapper.resource

# import user created keywords for user actions
Resource        ../Keywords/Actions/user_actions.resource


*** Variables ***
# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}

# set 'URL' to be the page required, in this case, the shop login page
${URL}  https://happy-robot.nimbus.fi/my-account/

# set 'usertype' as 'customer' (the other option would be 'admin', but it is not used for this test)
${usertype}  customer

*** Test Cases ***
Login As Existing User                 # login as specified usertype (customer/admin)
    Open New Browser Window            ${browser}
    Go To Given Page                   ${URL}
    Fill Text Field With Input         ${username_field}    ${users}[${usertype}][username]
    Fill Password Field With Input     ${password_field}    ${users}[${usertype}][password]
    Click Selected                     ${login_button}
    Check Location By Element          ${checkforpass}      # check login succeeded


Add Products To Cart And Then Clear Shopping Cart
    Add Products To Cart
    Clear Shopping Cart


[Teardown]    Close Current Browser


*** Keywords ***


*** Comments ***