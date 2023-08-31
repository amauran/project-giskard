# Testing different CSS selectors using the Happy Robot site

*** Settings ***

Library  SeleniumLibrary

*** Variables ***

${Browser}  Chrome
${URL}  https://happy-robot.nimbus.fi/   # test shop url home page

*** Test Cases ***

# skipping testing of universal selector *

Test find right page
# If this is commented out the following tests will not work as the browser is not open

    Open Browser                  ${URL}        ${Browser}

    # make sure location is front page
    Location Should Be            ${URL}

Test type selector

    # find elemement with type 'h1' with the text 'Shop' (page title)
    Element Should Contain        css:h1            Shop

Test class selector

    # find element with the class 'wp-block-search__button' (search button)
    Page Should Contain Element   css:.wp-block-search__button
    # check button has text 'Search'
    Element Should Contain        css:.wp-block-search__button        Search
    # find element with class 'wp-block-search__input' (search box)
    Page Should Contain Element   css:.wp-block-search__input


Test ID selector

    # find element with id 'woocommerce-product-search-field-0' (upper corner search box)
    Page Should Contain Element    css:#woocommerce-product-search-field-0
    # find menu element with id 'menu-item-14' that contains exact text 'My account'
    Element Text Should Be         css:#menu-item-14                 My account

Test attribute selectors

    # note: just using [attr] will search for all given attributes whatever their value

    ### [attr=value] attribute 'attr' with exact value 'value'
    # find element with attribute 'alt' with the value 'Happy Robot'
    Element Attribute Value Should Be    css:[alt="Happy Robot"]     class            custom-logo

    ### [attr~=value] attribute 'attr' with a value that is a whitespace separated list
    ### of words, out of which one is exactly 'value' (so a full word!)
    ### note: addin i/s at the end before bracket [attr operator i/s] makes
    ### any of the [attr] searches case insensitive/sensitive
    # find element with attribute 'title' that should contain word 'ecommerce' (case insensitive)
    # and check that element contains text 'WooCommerce'
    Element Should Contain               css:[title~="ecommerce" i]        WooCommerce
    # find same element and check the link it points to is the required one (so attribute is href, value is the url)
    Element Attribute Value Should Be    css:[title~="ecommerce" i]        href        https://woocommerce.com/






*** Keywords ***

*** Comments ***