*** Settings ***

Library  SeleniumLibrary

# Importing resouce files
Variables  ../2_Login/resources/shop_loginpwds.yaml
Variables  ../2_Login/resources/shop_paths.yaml

*** Variables ***
${Browser}  Chrome
${URL}      ${paths}[login_url]   # test shop login page url


# Resource files are imported using the Resource setting in the Settings table.
# The path to the resource file is given in the cell after the setting name.

*** Test Cases ***

Shop Login With Existing Customer
    Open Browser                   ${URL}        ${Browser}
    Maximize Browser Window

    # make sure location is login page
    Location Should Be             ${paths}[login_url]

    # fill in username after clearing the field
    Input Text                     ${paths}[username_box_relxpath]  ${logins}[username]    True

    # fill in password after clearing the field (Input Password -> will produce no log of passowrd on normal log levels)
    Input Password                 ${paths}[password_box_relxpath]  ${logins}[password]    True

    # click loging button and see if we got in by checking if 'Account details' link exists
    Click Button                   xpath = ${paths}[login_button_relxpath]
    Page Should Contain Element    xpath = //a[normalize-space()='Account details']


    # Leaving browser open for next text part
    # Close Browser

Add Items to Shopping Cart

    # Check location is still 'My account'
    Location Should Be             ${paths}[login_url]
    # Click link to shop page (also the main page)
    Click Element                  ${paths}[shop_relxpath]
    # Check location is main/shop page
    Location Should Be             ${paths}[main_url]

    # Check there are products on the page  (in this case class="products" is on the page)
    Page Should Contain Element    css:.products

    # Add items to shopping cart ('Can of Oil' and 'Varied Nuts & Bolts')
    Click Element                  //a[@aria-label='Add “Can of Oil” to your basket']
    Click Element                  //a[@aria-label='Add “Varied Nuts & Bolts” to your basket']

    # Go to shopping cart and check the items are their (find their page links)
    Click Element                         ${paths}[basket_relxpath]
    Location Should Be                    ${paths}[basket_url]
    Wait Until Page Contains Element      css:.woocommerce-cart-form                    10 sec
    Wait Until Page Contains Element      //a[normalize-space()='Can of Oil']           10 sec
    Wait Until Page Contains Element      //a[normalize-space()='Varied Nuts & Bolts']  10 sec

    Close Browser


#*** Tasks ***
# One file cannot have both tests and tasks!

*** Keywords ***



*** Comments ***