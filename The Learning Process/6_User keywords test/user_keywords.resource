*** Settings ***
Documentation    a keyword file for running the shopping cart test

# importing libraries (note: Robot Frameworks's BuiltIn library is always automatically imported)
Library          SeleniumLibrary

*** Variables ***


*** Keywords ***
# creating user keywords to be used in test cases
# using SeleniumLibrary keywords
# [Documentation] is for documenting what the keyword does
# [Arguments] is for assigning the arguments/variables the keyword needs

# keyword for opening the login page in a browser
Open Login Page
    [Documentation]                open login page
    [Arguments]                    ${login_url}  ${browser}
    # Note: 'Open Browser' wants login url to come before the browser!!!
    Open Browser                   ${login_url}  ${browser}
    Maximize Browser Window
    # this is used to clear out any cookies that might be left over from previous test runs on the site
    Delete All Cookies

    # make sure location is login page
    Location Should Be             ${login_url}

# keyword for entering username in the username filed
Enter Username
    [Documentation]                clear username field and enter username there
    [Arguments]                    ${field_username}  ${user_username}
    Input Text                     ${field_username}  ${user_username}    True

# keyword for entering password in the password field
Enter Password
    [Documentation]                clear password field and enter password there
    [Arguments]                    ${field_password}  ${user_password}
    # (Input Password -> will produce no log of passowrd on normal log levels)
    Input Password                 ${field_password}  ${user_password}    True

# keyword for clicking the login button at given location, with a check to see if it worked
Click Login Button
    [Documentation]                click login button
    [Arguments]                    ${login_button}  ${login_checkforpass}
    # click loging button and see if we got in by checking if 'Account details' link exists
    Click Button                   ${login_button}
    Page Should Contain Element    ${login_checkforpass}






