*** Settings ***
# paths to variable files
# note that the shop_loginpwds.yaml file is in gitignore and will not be pushed to github
Variables  ../2_Login/resources/shop_loginpwds.yaml
Variables  ../2_Login/resources/shop_paths.yaml
Variables  product_names.yaml

#importing libraries
Library    SeleniumLibrary


*** Variables ***

${browser}  Chrome

*** Test Cases ***

Shop Login With Existing Customer

    Open Browser                   ${paths}[login_url]        ${browser}
    Maximize Browser Window
    Delete All Cookies

    # make sure location is login page
    Location Should Be             ${paths}[login_url]

    # fill in username after clearing the field
    Input Text                     ${paths}[username_box_relxpath]  ${logins}[username]    True

    # fill in password after clearing the field
    # (Input Password -> will produce no log of passowrd on normal log levels)
    Input Password                 ${paths}[password_box_relxpath]  ${logins}[password]    True

    # click loging button and see if we got in by checking if 'Account details' link exists
    Click Button                   xpath = ${paths}[login_button_relxpath]
    Page Should Contain Element    xpath = //a[normalize-space()='Account details']

Add Products To Cart
    # go to home page (shop main page)
    Click Element         css:.menu-item-home

    # check location is the home page (shop main page)
    Location Should Be    ${paths}[main_url]

    # get length of product name list (from yaml file)
    ${length} =           Get Length    ${product_names}
    Log                   ${length}

    ### loop for adding products into cart one by one, by product name

    # a loop that runs from range 0 until the length of the product list (gotten from yaml file)
    FOR    ${product_index}    IN RANGE    0    ${length}
        # set current product to be the one indicated by the index number
        ${current_product} =  Set Variable    ${product_names}[${product_index}]

        # input search string (= current product name) into search box, and press enter
        Input Text            ${paths}[search_top_field_csspath]    ${current_product}
        Press Keys            ${paths}[search_top_field_csspath]    RETURN

        # Check location should now be a single product page (with part of the url without specific product page)
        # Note: this only works if the search result is a single product, otherwise the address is different
        Location Should Contain        https://happy-robot.nimbus.fi/product/

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

    FOR    ${click_times}    IN RANGE    0    ${button_count}
        Wait Until Page Contains Element    css:a.remove
        Click Element    css:a.remove
        # NOTE: this sleep is required so the page can 'find' the button again (this is a javascript issue)
        Sleep    2 sec
    END

    Page Should Not Contain Element    css:a.remove

    Close All Browsers
