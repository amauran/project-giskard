*** Settings ***
Documentation    user created keywords for shop manager actions
# NOTE: manager does not have admin rights! (can handle orders and customers though)

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml

# import password file (this is in gitignore!!!)
Variables       ../../Environment/shop_loginpwds.yaml

# import keyword wrapper (selenium or browser) indicated by the variables.yaml file
Resource        ../Wrappers/${wrapper}_wrapper.resource


*** Variables ***

# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}


*** Keywords ***

Login As Shop Manager
    [Documentation]                    Go to shop management side and log manager in

    # set local variable 'usertype' value to 'manager' for this part of testing
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
    [Documentation]                    Logout manager
    # should work from any page on the wordpress, provided of course the manager is logged in

    Wait Until Visible                 ${manager_hovermenu_link}
    Hover Over Element                 ${manager_hovermenu_link}
    Wait Until Visible                 ${manager_hovermenu_visible}
    Click Selected Element             ${manager_hovermenu_logout_link}

Go To Orders Page
    [Documentation]                    Use the sidebar menu to access WooCommerce Orders page
    # should work from any page on the wordpress, provided of course the manager is logged in

    # pitää tarkistaa onko wp menu expanded vai ei, jos ei pitää klikata nappia että aukeaa
    # sitten vasta kaikki tämä


    Wait Until Visible                 ${manager_WC_hovermenu_link}
    Hover Over Element                 ${manager_WC_hovermenu_link}
    Wait Until Visible                 ${manager_WC_hovermenu_orders_link}
    Click Selected Element             ${manager_WC_hovermenu_orders_link}



# Edit Order Status
# Mark Order As Processed