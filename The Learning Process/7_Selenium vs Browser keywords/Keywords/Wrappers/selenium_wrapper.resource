# this is the wrapper for SeleniumLibrary keywords

*** Settings ***

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

Close Current Browser
    [Documentation]            Close current active browser
    Close Browser

Close All Browsers
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

Press Enter
    [Documentation]            Simulate pressing Return/Enter on keyboard
    [Arguments]                ${locator}
    Press Keys                 ${locator}    RETURN

    # NOTE: the format is actually 'Press Keys    locator    key',
    # but if the locator is left empty, the key is sent to the currently active browser
    # (so hopefully to the currently active text field...)



### Actions

Click Selected
    [Documentation]            Click element indicated by locator
    [Arguments]                ${locator}
    Click Element              ${locator}


Wait Until Visible
    [Documentation]                    Wait until element specified by locator is visible
    [Arguments]                        ${locator}
    Wait Until Page Contains Element   ${locator}    10sec  # 10 second timeout

Confirm No Such Element
    [Documentation]                    Confirm element is not found
    [Arguments]                        ${locator}
    Page Should Not Contain Element    ${locator}