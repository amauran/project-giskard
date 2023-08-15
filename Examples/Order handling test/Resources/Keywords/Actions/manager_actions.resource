*** Settings ***
Documentation    user created keywords for admin actions

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml

# import password file (this is in gitignore!!!)
Variables        ../../Environment/shop_loginpwds.yaml

# import keyword wrapper (selenium or browser) indicated by the variables.yaml file
Resource        ../Wrappers/${wrapper}_wrapper.resource

*** Variables ***

# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}

*** Keywords ***

Login As Shop Manager
    # set local variable 'usertype' value to 'admin' for this part of testing
    Set Local Variable                 ${usertype}        manager
    Set Local Variable                 ${manager_name}    ${users}[${usertype}][display_name]

    # go to login page and fill username and password (browser opened in main test!)
    Go To Given Page                   ${manager_login_url}

    Fill Text Field With Input         ${manager_username_field}    ${users}[${usertype}][username]
    Fill Password Field With Input     ${manager_password_field}    ${users}[${usertype}][password]
    Click Selected Element             ${manager_login_button}

    # check location for successful login
    # (in this case, find the manager's display name, and compare to name on file)
    Wait Until Visible                 ${manager_checkforpass}
    ${text_found} =                    Get Element Text             ${manager_checkforpass}
    Should Be Equal                    ${manager_name}              ${text_found}


Logout Shop Manager

# Edit Order Status
# Mark Order As Processed