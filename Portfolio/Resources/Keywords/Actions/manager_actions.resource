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


Confirm Sidebar Menu Is Expanded
    [Documentation]                    Make sure the sidebar menu is expanded to show text elements

    # create local variable to check if side menu is expanded or not ('true' should return 1, so 'false' is 0)
    # ${WPmenu_expanded} =               Get Attribute Value   //button[@id="collapse-button"]      ariaExpanded
    ${WPmenu_state} =  Count Element    ${manager_WPmenu_collapse_state}

    # degubbing to see value
    Log                                ${WPmenu_state}

    # check state of WordPress side menu (collapsed or expanded)
    # if not expanded yet, click button to expand it (menu locators will not work otherwise!!!)
    # NOTE: comparison needs the triple quotes (IF will not read them as equal strings otherwise)
    IF  """${WPmenu_state}""" == """0"""
        Click Selected Element             //button[@id="collapse-button"]
        # this should only appear when the menu is expanded (if not, the text will say "Expand Main Menu")
        Confirm Element Found                 //button[@id="collapse-button"][@aria-label="Collapse Main menu"]
    END


Manager Goes To Order Handling Page
    [Documentation]                    Use the sidebar menu to access WooCommerce Orders page
    # should work from any page on the wordpress, provided of course the manager is logged in

    # once the WP menu is expanded, the menu text items used as locators here should be found
    # with them we find the WooCommerce menu, wait until popup menu appears, and click "Orders" link
    Wait Until Visible                 ${manager_WC_hovermenu_link}
    Hover Over Element                 ${manager_WC_hovermenu_link}
    Wait Until Visible                 ${manager_WC_hovermenu_orders_link}
    Click Selected Element             ${manager_WC_hovermenu_orders_link}


Manager Finds And Opens A Placed Order
    [Documentation]                    Find an order and view it
    [Arguments]                        ${order_number}
    # (for this test case it will be the newest order made)

    # create variables for locating the correct order, and for checking we found the right order page
    ${order_locator} =  Catenate  SEPARATOR=  ${manager_all_orders}  [contains(@href,"post=  ${order_number}  ")]
    ${order_page_check} =   Catenate  SEPARATOR=  //div[@id="order_data"]/h2[contains(text(),"  ${order_number}  ")]

    # debugging to see what comes out
    Log    ${order_locator}
    Log    ${order_page_check}

    # open the order that came through by clicking the link, and check we landed on the right order page
    Click Selected Element             ${order_locator}
    Wait Until Visible                 ${order_page_check}


Manager Edits Order Status To Pending Payment
    [Documentation]                    Change order status to 'Pending payment' for editing
    # NOTE: if this is not done, a coupon cannot be added, and this only works on a single order page

    # open order status dropdown menu
    Click Selected Element             ${manager_orderstatus_dropdownmenu_link}

    # check menu is open (by finding if 'aria-expanded' is 'true', which returns 1, 'false' is 0)
    ${menu_state} =  Count Element     ${manager_orderstatus_dropdownmenu_state}
    Should Be True    """${menu_state}""" == """1"""

    # click the option 'Pending payment' and then update order to save changes (the page should reload)
    Click Selected Element             ${manager_orderstatus_pending_link}
    Click Selected Element             ${manager_order_update_button}


Manager Adds A Discount Coupon To Order
    [Documentation]                    Add a discount coupon to order just made
    # NOTE: coupon code must exist already in the shop! (set the code as value to the local variable)

    # click 'Apply coupon', input coupon code into popup, press enter (page autoloads afterwards to apply it)
    Set Local Variable                          ${coupon code}        0000011110111000

    # NOTE: selenium and browser library approach handling alerts differently,
    # so the keyword used here has to include the element that is clicked before the alert appears
    # (other methods would have worked if the popup would have had any usable selectors, which it doesn't)
    Handle OnClick Popup With Input And Accept  ${manager_add_coupon_button}  ${coupon code}
    # added sleep because the page reloads after applying the coupon, so it wasn't found immediately
    Sleep  5 sec

    # check coupon is added by finding the coupon code field and matching the code
    Confirm Element Found                 ${manager_check coupon}
    ${code_found} =  Get Element Text     ${manager_check coupon}
    Should Be True                     """${code_found}""" == """${coupon code}"""


Manager Marks Order As Processed And Completed
    [Documentation]                   Open order status menu and change order to 'Completed'

    # open order status dropdown menu
    Click Selected Element             ${manager_orderstatus_dropdownmenu_link}

    # check menu is open (by finding if 'aria-expanded' is 'true', which returns 1, 'false' is 0)
    ${menu_state} =  Count Element     ${manager_orderstatus_dropdownmenu_state}
    Should Be True    """${menu_state}""" == """1"""

    # click the option 'Completed' and then update order to save changes (the page should reload)
    Click Selected Element             ${manager_orderstatus_completed_link}
    Click Selected Element             ${manager_order_update_button}


Manager Deletes A Placed Order
    [Documentation]                    delete a single order from arrived orders
    # NOTE: you need to have an order number for this to work, and be on the Orders page
    # (for this test we will delete the newest order)
    Click Selected Element             ${manager_order_movetobin}


Manager Empties Bin Of Deleted Orders
    [Documentation]                    go to the Bin and delete all orders there
    # NOTE: you have to be on the  Orders page for this to work (or any of the sub pages (All/Bin/Completed))

    # go to Bin
    Click Selected Element             ${manager_order_bin_link}
    Check Location By URL              ${manager_order_bin_url}
    # click 'Empty Bin' -- THIS IS A PERMANENT DELETE AND THERE IS NO CONFIRMATION ASKED!!!
    Click Selected Element             ${manager_empty_bin}
    # make sure bin is empty
    Confirm No Such Element            ${manager_order_exist_check}
