*** Settings ***
Documentation    user created keywords for shop customer actions

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml
Variables       ../../Environment/product_names.yaml

# import password file (this is in gitignore!!!)
Variables       ../../Environment/shop_loginpwds.yaml

# import keyword wrapper (selenium or browser) indicated by the variables.yaml file
Resource        ../Wrappers/${wrapper}_wrapper.resource


*** Variables ***

# set 'browser' variable to be the browser chosen in variables.yaml
${browser}  ${usebrowser}


*** Keywords ***

Login As Existing Customer
    [Documentation]                    Go to shop url and login as an existing customer

    # set local variable 'usertype' value to 'customer' for this part of testing
    Set Local Variable                 ${usertype}          customer

    # go to Happy Robot shop and login (using wrapper keywords)
    Go To Given Page                   ${customer_login_url}
    Fill Text Field With Input         ${customer_username_field}    ${users}[${usertype}][username]
    Fill Password Field With Input     ${customer_password_field}    ${users}[${usertype}][password]
    Click Selected Element             ${customer_login_button}

    # check login succeeded (should be on My Accounts page and find element 'Account details')
    Check Location By Element          ${customer_login_checkforpass}


Logout Customer From Shop
    [Documentation]                   check location and logout customer from shop

    # check if the current location is the 'My Account' page, and click the logout link
    ${current_page} =                 Get Current Location URL

    # IF current page is already logout page (My Account), click the logout link
    # NOTE: the variables need the triple quotes on both sides, or IF can't properly compare strings
    # (this is just a quirk of the system I suppose...)
    IF  """${current_page}""" == """${customer_logout_url}"""
        Click Selected Element        ${customer_logout_link}
        Wait Until Visible            ${customer_login_button}
    # if not on 'My Account' page, go there and then logout
    ELSE
        Wait Until Visible            ${customer_my-account_link}
        # once again, a sleep seems to be needed even though we just waited for the element...
        Sleep  2 sec
        Click Selected Element        ${customer_my-account_link}
        Check Location By URL         ${customer_logout_url}
        Wait Until Visible            ${customer_logout_link}
        Click Selected Element        ${customer_logout_link}
        Wait Until Visible            ${customer_login_button}
    END


Customer Adds Products To Cart
    [Documentation]                   add each product in the shop into the cart once via search box
    # NOTE: This requires that product_names.yaml is updated if new products are added to shop

    # go to home page (shop main page)
    Click Selected Element         ${shop_link}
    # check location is the home page (shop main page)
    Check Location By URL          ${main_url}
    # get length of product name list (from yaml file)
    ${length} =        Get Length    ${product_names}

    ### loop for adding products into cart one by one, by product name
    # the loop runs from range 0 until the length of the product list (gotten from yaml file)
    FOR    ${product_index}    IN RANGE    0    ${length}

        # set current product to be the one indicated by the index number
        ${current_product} =   Set Variable   ${product_names}[${product_index}]

        # input search string (= current product name) into search box, and press enter
        Fill Text Field With Input            ${customer_searchfield_top}    ${current_product}
        Press Enter                           ${customer_searchfield_top}

        # Check location, should now be a single product page (with part of the url without specific product page)
        # Note: this only works if the search result is a single product, otherwise the address is different
        Check Location By Partial URL         ${product-page_partial_url}

        # click 'add-to-cart' (there should be only one button available if previous part worked)
        Wait Until Visible                    ${cart_add_product}
        Click Selected Element                ${cart_add_product}

        # debugging, making sure things go right
        # Log Many   ${product_index}, ${current_product}
    END


Customer Goes To Shopping Cart
    [Documentation]                   # click shopping cart link
    Click Selected Element            ${cart_link}


Customer Checks Shopping Cart Items
    [Documentation]                Check number of product types and their quantity in cart
    # NOTE: for basic testing the quantity is 1 for each product,
    # and the shopping cart should be empty before running test series or this will fail

    # get length of product name list = the number of product types in shop (from yaml file)
    # NOTE: the yaml file must be updated if new products are added to shop
    ${length} =           Get Length    ${product_names}

    # set two local variables for creating locator for quantity of a product type in shopping cart
    # (the missing part will be added in the loop later using Catenate)
    Set Local Variable  ${quantity_loc_pt1}  //tbody/tr/td[@class="product-name"]/a[contains(@href,"
    Set Local Variable  ${quantity_loc_pt2}  ")]/parent::td/following-sibling::td[@class="product-quantity"]/div/input

    # check the number of product types in cart matches that in the shop (the yaml file)
    # (this could later be improved to count products in the actual shop instead of using the yaml file)
    ${product_types_in_cart} =      Count Element    ${cart_product_types}
    Should Be Equal                 ${length}        ${product_types_in_cart}

    # loop for checking the name and quantity of each product type in shopping cart
    FOR    ${product_index}    IN RANGE    0   ${length}

        # set current_product to product name url ending (/product-name)
        ${current_product} =    Set Variable   ${product_namesinurl}[${product_index}]
        ${product_name} =       Set Variable   ${product_names}[${product_index}]

        # catenate locator for current product item quantity in shipping cart
        ${quantity_locator} =   Catenate   SEPARATOR=  ${quantity_loc_pt1}  ${current_product}  ${quantity_loc_pt2}

        # find current product's quantity with previously made locator
        ${product_quantity} =   Get Attribute Value    ${quantity_locator}      value
        # check quantity is one (should be, unless something was left in the cart from previous test runs)
        Should Be True          ${product_quantity} == 1
    END


Customer Goes To Order Handling Page
    [Documentation]                   # click link to orders page in shop
    Click Selected Element            ${customer_orders_link}


Customer Clears Their Shopping Cart
    [Documentation]                Clear shopping cart of all products
    # NOTE: must first be on shopping cart page of course

    # wait until link to cart is visible, click it and confirm we got to the right location
    Wait Until Visible             ${cart_link}
    Click Selected Element         ${cart_link}
    Check Location By URL          ${cart_url}

    # count number of remove buttons (= the number of product types in cart that can be removed)
    # (clicking the remove button removes that product regardless of quantity in cart)
    ${button_count} =               Count Element    ${cart_remove_product}

    # for as long as there are product types in the cart (a remove button exists), click remove button
    FOR    ${click_times}    IN RANGE    0    ${button_count}

        Wait Until Visible          ${cart_remove_product}
        Click Selected Element      ${cart_remove_product}
        # NOTE: this sleep is required so the page can 'find' the button again (this is a javascript issue)
        # (changed this from 1 second to 2 after some issues, may need to be adjusted at times)
        Sleep    2 sec
    END

    # confirm no more remove buttons exist (no more products to remove, cart should be empty)
    Confirm No Such Element         ${cart_remove_product}


Customer Proceeds To Checkout
    [Documentation]                 Click 'Proceed to checkout' button
    # there needs to be an open order, and you need to be viewing the order for the button to exist
    Click Selected Element          ${customer_checkout_button}


Customer Says Thank You In Comment Box
    [Documentation]                 leave a thank you message in the comment box
    # (only works if an order is open and you are on the checkout page)

    # create local variable for the thank you message used later (no quotemarks needed for message in this)
    Set Local Variable              ${thank_you_message}    First time customer, thank you for creating this shop! ^_^
    # enter thank you message to the comment box
    Fill Text Field With Input      ${customer_checkout_commentbox}     ${thank_you_message}
    # focus elsewhere to get out of text box
    Set Focus To Selected Element   ${customer_privacy_policy}


Customer Places Order
    [Documentation]                 click the 'Place order' button
    # (only works if an order is open and you are on the checkout page)
    Click Selected Element          ${customer_place_order_button}


Customer Checks The Order Was Succesful
    [Documentation]                 wait until the message for succesful order is found
    # this will hopefully happen before timeout, as a new page is loaded for the completed order
    # NOTE: timeout (10 sec) for the keyword is set in the wrapper file, not here
    Wait Until Visible              ${customer_order_received}


Save New Order Number
    [Documentation]                 save the order number for the completed order
    # NOTE: this is used in case there are more than one order to choose from
    ${new_order_number} =           Get Element Text    ${customer_order_received_number}
    RETURN                          ${new_order_number}


Customer Finds And Opens A Placed Order
    [Documentation]                 find a previously placed order on the Orders page
    [Arguments]                     ${new_order_number}
    # NOTE: you will need an order number for this, and you need to be on the Orders page
    # in this test series, the order found will always be the newest one

    # create locator for the order, using suite variable 'new_order_number'
    ${order_link} =  Catenate  SEPARATOR=  //td[@data-title="Order"]/a[contains(@href,"/  ${new_order_number}  /")]

    # got to single order page and check it's the right one
    Click Selected Element          ${order_link}
    Check Location By Partial Url   ${customer_order_view_partial_url}
    ${current_url} =                Get Current Location Url
    Should Contain                  ${current_url}    ${new_order_number}


Customer Confirms Discount Added
    [Documentation]                 confirm a discount on an order
    # confirms that a discount has been added, not the type or amount
    # NOTE: you need to be viewing a single order for this to work
    Confirm Element Found           ${customer_order_discount_check}


Customer Confirms Order Status Completed
    [Documentation]                 confirm order status is 'Completed'
    # NOTE: you need to be viewing a single order for this to work
    Confirm Element Found           ${customer_order_completed_check}







