*** Settings ***
Documentation   This is the wrapper for SeleniumLibrary keywords


# importing libraries (Note: must have SeleniumLibrary here)
Library         SeleniumLibrary


*** Variables ***
# dictionary of SeleniumLibrary supported browsers
# (not all of them, these are just for example)
# creating a dictionary variable to switch generic browser name
# to one that SeleniumLibrary uses
&{generic_browser_name_to_local_name} =
...    chrome=chrome        # googlechrome, chrome, gc
...    firefox=firefox      # firefox, ff
...    safari=safari


*** Keywords ***
### Navigation

Open New Browser Window
    [Documentation]            Open a new browser window
    [Arguments]                ${browser}
    # Note: dictionary is defined with '&' but referred to here with '$' like a variable
    # Note: SeleniumLibrary Open Browser requires 'browser=' to be defined, or default browser is firefox
    Open Browser               browser=${generic_browser_name_to_local_name}[${browser}]


Go To Given Page
    [Documentation]            Go to a given page in an already opened browser
    [Arguments]                ${url}
    Go To                      ${url}


Check Location By Element
    [Documentation]                     Check current location by findind an element on the page
    [Arguments]                         ${locator}
    Wait Until Page Contains Element    ${locator}    10sec  # 10 second timeout


Check Location By URL
    [Documentation]            Check current location by url
    [Arguments]                ${url}
    Location Should Be         ${url}


Check Location By Partial URL
    [Documentation]            Check that current url matches a partial url
    [Arguments]                ${partial_url}
    Location Should Contain    ${partial_url}


Get Current Location URL
    [Documentation]            # Get the url of the currently active page
    ${current_url} =           Get Location
    RETURN                     ${current_url}


Close Current Browser
    [Documentation]            Close current active browser
    Close Browser


Close All Open Browsers
    [Documentation]            Close all open browsers
    Close All Browsers



### Input

Fill Text Field With Input
    [Documentation]            Fill field indicated by locator with given input
    [Arguments]                ${locator}    ${input}
    Input Text                 ${locator}    ${input}    True


Fill Password Field With Input
    [Documentation]            Fill password field indicated by locator with given input
    [Arguments]                ${locator}    ${input}
    Input Password             ${locator}    ${input}    True


# Made a new keyword for handling the popup alert, as the other did not seem to work in Browser library...
Handle OnClick Popup With Input And Accept
    [Documentation]            Handle a popup/alert appearing after click, that requires input and accepting
    [Arguments]                ${locator}  ${input}
    Click Element              ${locator}
    Input Text Into Alert      ${input}      ACCEPT  # action defined here, 'ACCEPT' is default so it's optional

## The old version (which worked fine for selenium)
# Fill Popup Field With Input And Accept
#     [Documentation]            Enter input into a popup text field and accept/press OK
#     [Arguments]                ${input}
#     Input Text Into Alert      ${input}      ACCEPT  # action defined here, 'ACCEPT' is default so it's optional


Press Enter
    [Documentation]            Simulate pressing Return/Enter on keyboard
    [Arguments]                ${locator}
    Press Keys                 ${locator}    RETURN

    # NOTE: the format is actually 'Press Keys    locator    key',
    # but if the locator is left empty, the key is sent to the currently active browser
    # (so hopefully to the currently active text field...)



### Actions

Click Selected Element
    [Documentation]            Click element indicated by locator
    [Arguments]                ${locator}
    Click Element              ${locator}


Hover Over Element
    [Documentation]            Simulate hovering over element with mouse cursor
    [Arguments]                ${locator}
    Mouse Over                 ${locator}


Wait Until Visible
    # NOTE: visible means logically visible, not visually (but anything with display:none will not be found)
    [Documentation]                    Wait until element specified by locator is visible
    [Arguments]                        ${locator}
    Wait Until Page Contains Element   ${locator}    10 sec  # 10 second timeout


Confirm No Such Element
    [Documentation]                    Confirm element is not found
    [Arguments]                        ${locator}
    Page Should Not Contain Element    ${locator}


Confirm Element Found
    [Documentation]                    Confirm element is found on page
    [Arguments]                        ${locator}
    Page Should Contain Element        ${locator}


Get Element Text
    [Documentation]            Get text content of given element
    [Arguments]                ${locator}
    # NOTE: remember the result  must be returned, so it's visible to the main test
    ${element_text} =          Get Text    ${locator}
    RETURN                     ${element_text}


### this works in selenium, browser library can't seem to find the properties (like innerText etc.)
Get Attribute Value
    [Documentation]            Get the value of the named and specified attribute
    [Arguments]                ${locator}   ${attribute_name}
    ${attribute_value} =       Get Element Attribute  ${locator}  ${attribute_name}
    RETURN                     ${attribute_value}


Count Element
    [Documentation]            Count how many of specified elements there are on the page
    [Arguments]                ${locator}
    ${element_count} =         Get Element Count          ${locator}
    RETURN                     ${element_count}


Set Focus To Selected Element
    [Documentation]            Set focus to specified element
    [Arguments]                ${locator}
    Set Focus To Element       ${locator}


Scroll To Selected Element
    [Documentation]            Scroll the specified element to view
    [Arguments]                ${locator}
    Scroll Element Into View   ${locator}
