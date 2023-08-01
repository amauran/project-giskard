# this is the wrapper for Browser library keywords

*** Settings ***

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
    # Note: dictionary is defined with '%' but referred to here with '$' like a variable
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
# Using normal Robot Framework variables like ${Password} will not work! Normal plain text will not work!
# For example, '$Password' will resolve to '${Password}'



### Actions

Click That Button
    [Documentation]            Click button indicated by locator
    [Arguments]                ${locator}
    # this uses left mouse button as default
    Click                      ${locator}

