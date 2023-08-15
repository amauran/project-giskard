*** Settings ***
Documentation    user created keywords for regular user actions

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml
Variables       ../../Environment/product_names.yaml


# import password file (this is in gitignore!!!)
Variables        ../../Environment/shop_loginpwds.yaml

# import keyword wrapper (selenium or browser) indicated by the variables.yaml file
Resource         ../Wrappers/${wrapper}_wrapper.resource


*** Variables ***

# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}

*** Keywords ***

Login As Existing Customer
     # set local variable 'usertype' value to 'customer' for this part of testing
    Set Local Variable                 ${usertype}          customer

    Go To Given Page                   ${login_url}
    Fill Text Field With Input         ${username_field}    ${users}[${usertype}][username]
    Fill Password Field With Input     ${password_field}    ${users}[${usertype}][password]
    Click Selected Element             ${login_button}

    # check login succeeded (should be on My Accounts page and find element 'Account details')
    Check Location By Element          ${checkforpass}


Logout Customer From Shop
    # check the location is the 'My Account' page, and click the logout link
    ${current_page} =                 Get Current Location URL

    # IF current page is already logout page (My Account), click the logout link
    # NOTE: the variables need the triple quotes on both sides, or IF can't properly compare strings
    # (this is just a quirk of the system I suppose...)
    IF  """${current_page}""" == """${logout_url}"""
        Click Selected Element        ${logout_link}
        Wait Until Visible            ${login_button}
    # if not on 'My Account' page, go there and then logout
    ELSE
        Click Selected Element        ${my_account_path}
        Check Location By URL         ${logout_url}
        Wait Until Visible            ${logout_link}
        Click Selected Element        ${logout_link}
        Wait Until Visible            ${login_button}
    END

Add Products To Cart
    [Documentation]        add each product in the shop into the cart once via search box

    # go to home page (shop main page)
    Click Selected Element         css:.menu-item-home

    # check location is the home page (shop main page)
    Check Location By URL    ${main_url}

    # get length of product name list (from yaml file)
    ${length} =           Get Length    ${product_names}
    Log                   ${length}


    ### loop for adding products into cart one by one, by product name

    # a loop that runs from range 0 until the length of the product list (gotten from yaml file)
    FOR    ${product_index}    IN RANGE    0    ${length}
        # set current product to be the one indicated by the index number
        ${current_product} =    Set Variable   ${product_names}[${product_index}]

        # input search string (= current product name) into search box, and press enter
        Fill Text Field With Input            ${search_top_field_csspath}    ${current_product}
        Press Enter                           ${search_top_field_csspath}

        # Check location, should now be a single product page (with part of the url without specific product page)
        # Note: this only works if the search result is a single product, otherwise the address is different
        Check Location By Partial URL        https://happy-robot.nimbus.fi/product/

        # click 'add-to-cart' (there should be only one button available if previous part worked)
        Wait Until Visible                    ${add_to_cart}
        Click Selected Element                ${add_to_cart}

        # Log Many   ${product_index}, ${current_product}

    END


Check Shopping Cart Items
    [Documentation]                Check number of product types and their quantity in cart


Clear Shopping Cart
    [Documentation]                Clear shopping cart of all products
    # go to shopping cart
    Wait Until Visible             ${cart_link}
    Click Selected Element         ${cart_link}
    Check Location By URL          ${cart_url}

    # count number of remove buttons (= the number of product types in cart that can be removed)
    # (clicking the remove button removes that product regardless of quantity in cart)

    ${button_count} =               Count Element    ${cart_remove}
    Log                   ${button_count}

    # for as long as there are product types in the cart (a remove button exists), click remove button
    FOR    ${click_times}    IN RANGE    0    ${button_count}
        Wait Until Visible          ${cart_remove}
        Click Selected Element      ${cart_remove}
        # NOTE: this sleep is required so the page can 'find' the button again (this is a javascript issue)
        # (changed this from 1 second to 2 after some issues, may need to be adjusted at times)
        Sleep    2 sec

    END

    # confirm no more remove buttons exist (no more products to remove, cart should be empty)
    Confirm No Such Element         ${cart_remove}