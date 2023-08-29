*** Settings ***
# paths to variable files
Variables  ../Login/resources/shop_loginpwds.yaml
Variables  ../Login/resources/shop_paths.yaml

#importing libraries
Library    SeleniumLibrary
Library    String

*** Variables ***

${browser}  Chrome
${product_search_string}           nuts                       # string to search with

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

Product search, add to cart, find in cart

    ### Searching for the product

    # input search string into search box, and press enter
    Input Text                     ${paths}[search_top_field_csspath]    ${product_search_string}
    Press Keys                     ${paths}[search_top_field_csspath]    RETURN
    # Check location is a product page (with part of the url without specific product page)
    Location Should Contain        https://happy-robot.nimbus.fi/product/


    ### Creating variables from the product information for later use

    # create variable 'full_product_id'
    # give it the value of id of the product (the one we're on the page of)
    ${full_product_id}    Get Element Attribute    css:div[id^="product-"]    id
    # log id for test purposes
    Log  ${full_product_id}

    # from 'full_product_id' string read from right until you encounter '-' (needs String library!)
    # save this as variable 'product_id
    # (in this case it's the number that comes after 'product-', like product-36)
    ${product_id}    Fetch From Right    ${full_product_id}    -
    Log    ${product_id}


    ### Adding a specified amount of products that have the correct id to shopping cart

    # Location is still the single product page, now adding things to cart
    # creating variable 'order_count' for number of products to be added
    # (a valua can be taken as an input but we are not testing that yet - requires Dialogs library)
    ${order_count}  Set Variable  3

    # find product count field and enter 'order_count', then press 'add to cart button'
    Input Text      css:#${full_product_id} form.cart input[name="quantity"]    ${order_count}
    Click Button    css:#${full_product_id} form.cart button[type="submit"]
    Click Element   ${paths}[basket_relxpath]


    ### Checking the order is correct (item + amount)

    # check location is the shopping cart/basket page
    Location Should Be    ${paths}[basket_url]
    # creating a local variable for this path because it's so long...
    ${cart_order_count_xpath}    Set Variable    xpath://a[@data-product_id="${product_id}"]/../../td[@class="product-quantity"]/div/input[@title="Qty"]

    # check number of items in cart is 'order_count'
    Element Attribute Value Should Be    ${cart_order_count_xpath}    value    ${order_count}


Clear shopping cart and close browser
    # need to empty cart or items will show up on next test run!!! (they remain in server cache or something)
    # click all elements with this label
    Click Element    css:a[aria-label="Remove this item"]
    Close All Browsers
