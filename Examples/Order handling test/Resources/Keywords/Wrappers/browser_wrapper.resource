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

Close All Browsers
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

# Note: for Browser library the input for Fill Secret cannot have curly braces! (so $input or %input, etc.)
# If 'secret' variable is prefixed with %, library will resolve corresponding environment variable.
# Example $Password` will resolve to ${Password} Robot Framework variable, %ENV_PWD will resolve to %{ENV_PWD} environment variable.
# Using normal Robot Framework variables like ${password} will not work!
# Normal plain text will not work. If you want to use plain text, use Fill Text keyword instead.


# Fill Popup Field With Input And Press Enter
    # Handle Future Dialogs ???


Press Enter
    [Documentation]            Simulate pressing Return/Enter on keyboard
    [Arguments]                ${locator}
    Keyboard Key               press        ENTER



### Actions

Click Selected Element
    [Documentation]            Click element indicated by locator
    [Arguments]                ${locator}
    # this uses left mouse button as default
    Click                      ${locator}

Wait Until Visible
    [Documentation]            Wait until element specified by locator is visible
    [Arguments]                ${locator}
    Wait For Elements State    ${locator}    visible    timeout=10 s

Confirm No Such Element
    [Documentation]            Confirm element is not found        # in this case, element count is 0
    [Arguments]                ${locator}
    Get Element Count          ${locator}    =    0

Get Element Text
    [Documentation]            Get text content of given element
    [Arguments]                ${locator}
    # NOTE: remember the result  must be returned, so it's visible to the main test
    ${element_text} =    Get Text    ${locator}
    RETURN    ${element_text}

Count Element
    [Documentation]            Count how many of specified elements there are on the page
    [Arguments]                ${locator}
     ${element_count} =        Get Element Count          ${locator}
    RETURN                     ${element_count}

