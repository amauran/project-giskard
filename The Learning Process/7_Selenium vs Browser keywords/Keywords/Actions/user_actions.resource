*** Settings ***
Documentation    user created keywords for regular user actions

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml
Variables       ../../Environment/product_names.yaml
Variables       ../../Environment/shop_paths.yaml

# import password file (this is in gitignore!!!)
Variables        ../../../Resources/shop_loginpwds.yaml

# import keyword wrapper (selenium or browser) indicated by the variables.yaml file
Resource        ../Wrappers/${wrapper}_wrapper.resource


*** Variables ***


*** Keywords ***

Add Products To Cart
    [Documentation]        add each product in the shop into the cart once

    # go to home page (shop main page)
    Click Element         css:.menu-item-home

    # check location is the home page (shop main page)
    Check Location By URL    ${paths}[main_url]

    # get length of product name list (from yaml file)
    ${length} =           Get Length    ${product_names}
    Log                   ${length}


    ### loop for adding products into cart one by one, by product name

    # a loop that runs from range 0 until the length of the product list (gotten from yaml file)
    FOR    ${product_index}    IN RANGE    0    ${length}
        # set current product to be the one indicated by the index number
        ${current_product} =  Set Variable    ${product_names}[${product_index}]

        # input search string (= current product name) into search box, and press enter
        Fill Text Field With Input            ${paths}[search_top_field_csspath]    ${current_product}
        Press Enter                           ${paths}[search_top_field_csspath]

        # Check location should now be a single product page (with part of the url without specific product page)
        # Note: this only works if the search result is a single product, otherwise the address is different
       Check Location By Partial URL        https://happy-robot.nimbus.fi/product/

        # click 'add-to-cart' (there should be only one button available if previous part worked)
        Wait Until Element Is Visible    css:button[name="add-to-cart"]
        Click Element                    css:button[name="add-to-cart"]

        Log Many   ${product_index}, ${current_product}

    END

Clear Shopping Cart
    # go to shopping cart
    Click Element         ${paths}[basket_relxpath]
    Location Should Be    ${paths}[basket_url]

    # count number of remove buttons (= the number of product types in cart that can be removed)
    # in this test case there is only 1 of each product types in the cart
    ${button_count} =     Get Element Count    css:a.remove
    Log                   ${button_count}


    # for as long as there are things in the cart (a remove button exists), click remove button
    FOR    ${click_times}    IN RANGE    0    ${button_count}
        Wait Until Visible     css:a.remove
        Click Element          css:a.remove
        # NOTE: this sleep is required so the page can 'find' the button again (this is a javascript issue)
        Sleep    1 sec
    END

    Confirm No Such Element    css:a.remove