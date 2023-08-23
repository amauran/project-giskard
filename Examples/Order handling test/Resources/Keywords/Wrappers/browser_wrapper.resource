*** Settings ***
Documentation   This is the wrapper for Browser library keywords

# importing libraries (Note: must have Browser here)
Library         Browser

*** Variables ***
# dictionary of Browser library supported browsers
# (not all of them, these are just for example)
# creating a dictionary variable to switch generic browser name
# to one that Browser library uses
&{generic_browser_name_to_local_name} =
...    chrome=chromium  # Google Chrome, Microsoft Edge (since 2020), Opera
...    firefox=firefox  # Mozilla Firefox
...    safari=webkit    # Apple Safari, Mail, AppStore on MacOS and iOS


*** Keywords ***
### Navigation

Open New Browser Window
    [Documentation]            Open a new browser window
    [Arguments]                ${browser}
    # Note: dictionary is defined with '&' but referred to here with '$' like a variable
    # Note: define 'browser=' or default browser is used
    Open Browser               browser=${generic_browser_name_to_local_name}[${browser}]


Go To Given Page
    [Documentation]            Go to a given page in an already opened browser
    [Arguments]                ${url}
    Go To                      ${url}


Check Location By Element
    [Documentation]            Check current location by findind an element on the page
    [Arguments]                ${element_locator}
    # this waits until the element is visible, or runs into timeout (other states can be used too)
    Wait For Elements State    ${element_locator}    visible    timeout=10 s


Check Location By URL
    [Documentation]            Check current location by url
    [Arguments]                ${url}
    Wait For Navigation        ${url}        timeout=10 s


Check Location By Partial URL
    [Documentation]            Check that current url matches a partial url
    [Arguments]                ${partial_url}
    Get Url                    *=            ${partial_url}


Get Current Location URL
    [Documentation]            # Get the url of the currently active page
    ${current_url} =           Get Url
    RETURN                     ${current_url}


Close Current Browser
    [Documentation]            Close current active browser
    Close Browser              CURRENT       # 'CURRENT' is optional if only one browser is open


Close All Open Browsers
    [Documentation]            Close all open browsers
    Close Browser              ALL



### Input

Fill Text Field With Input
    [Documentation]            Fill field indicated by locator with given input
    [Arguments]                ${locator}    ${input}
    Fill Text                  ${locator}    ${input}


Fill Password Field With Input
    [Documentation]            Fill password field indicated by locator with given input
    [Arguments]                ${locator}    ${input}
    Fill Secret                ${locator}    ${input}

# NOTE: for Browser library the input for Fill Secret cannot have curly braces! (so $input or %input, etc.)
# If 'secret' variable is prefixed with %, library will resolve corresponding environment variable.
# Example $Password` will resolve to ${Password} Robot Framework variable, %ENV_PWD will resolve to %{ENV_PWD} environment variable.
# Using normal Robot Framework variables like ${password} will not work!
# Normal plain text will not work. If you want to use plain text, use Fill Text keyword instead.


Fill Popup Field With Input And Accept
    [Documentation]            Enter input into a popup text field and press ENTER
    [Arguments]                ${input}
    Keyboard Input             insertText    ${input}
    Keyboard Key               press         ENTER


# NOTE: This differs from the way things are done in the Selenium wrapper, as Browser library
# handles alerts by setting a 'Wait For Alert' command BEFORE the actual event
# --> so if you click a button and a popup appears, you have to already be expecting the alert.
# --> hence 'Keyboard Input' followed by 'Keyboard Key' (and hoping the focus is in the alert...)


Press Enter
    [Documentation]            Simulate pressing Return/Enter on keyboard
    [Arguments]                ${locator}
    Keyboard Key               press         ENTER



### Actions

Click Selected Element
    [Documentation]            Click element indicated by locator
    [Arguments]                ${locator}
    # this uses left mouse button as default
    Click                      ${locator}


Hover Over Element
    [Documentation]            Simulate hovering over element with mouse cursor
    [Arguments]                ${locator}
    Hover                      ${locator}


Wait Until Visible
    # NOTE: visible means logically visible, not visually (but anything with display:none will not be found)
    [Documentation]            Wait until element specified by locator is visible
    [Arguments]                ${locator}
    Wait For Elements State    ${locator}    visible    timeout=10 s


Confirm No Such Element
    [Documentation]            Confirm element is not found        # in this case, element count is 0
    [Arguments]                ${locator}
    Get Element Count          ${locator}    =    0


Confirm Element Found
    [Documentation]            Confirm element is found on page    # element count is either 1 or more
    [Arguments]                ${locator}
    Get Element Count          ${locator}    >=    1


Get Element Text
    [Documentation]            Get text content of given element
    [Arguments]                ${locator}
    # NOTE: remember the result  must be returned, so it's visible to the main test
    ${element_text} =          Get Text    ${locator}
    RETURN    ${element_text}


Get Attribute Value
    [Documentation]            Get the value inside specified attribute
    [Arguments]                ${locator}   ${attribute_name}
    ${attribute_value} =       Get Attribute  ${locator}  ${attribute_name}


Count Element
    [Documentation]            Count how many of specified elements there are on the page
    [Arguments]                ${locator}
     ${element_count} =        Get Element Count          ${locator}
    RETURN                     ${element_count}


Set Focus To Selected Element
    [Documentation]            Set focus to specified element
    [Arguments]                ${locator}
    Focus                      ${locator}


Scroll To Selected Element
    [Documentation]            Scroll the specified element to view
    [Arguments]                ${locator}
    Scroll To Element          ${locator}
