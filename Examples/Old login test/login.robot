# just a login test

*** Settings ***
Library  SeleniumLibrary

# Importing resouce files
Variables  /home/anne/Git/project-giskard/tests/Login/resources/anne_passwords.yaml
Variables  /home/anne/Git/project-giskard/tests/Login/resources/locator_paths.yaml

*** Variables ***
${Browser}  Chrome
#${URL}  https://www.google.com/
${URL}  https://www.dreamwidth.org/login

# Resource files are imported using the Resource setting in the Settings table.
# The path to the resource file is given in the cell after the setting name.


*** Test Cases ***
# TC_001 Browser Start and Close
#     Open Browser  ${URL}  ${Browser}
#     Close Browser

# TC_002 Go to Dreamwidth login page
#     Open Browser  ${URL}  ${Browser}
#     Maximize Browser Window
#     Title Should Be    Log in
#     Close Browser

# TC_003 Go to DW login page and press login button without filling the fields
#     Open Browser  ${URL}  ${Browser}
#     Maximize Browser Window
#     Title Should Be    Log in
#     Click Element      CSS = input[value='Log in'][name='action:login']
#     Page Should Contain Element    xpath://strong[normalize-space()='There was an error processing your request:']
#     Close Browser


# Created separate resource yaml file for path variables

TC_004 Read yaml files and get values for Variables
# these are read from the file imported in Settings with Variables
# the data is in a dictionary called 'logins' from which it's retrived with keys
    Log To Console   ${logins}[username]
    Log To Console   ${logins}[password]

    Log    Username is ${logins}[username]
    Log    Password is ${logins}[password]

    Log    username box path is ${paths}[username_box_relxpath]
    Log    password box path is ${paths}[password_box_relxpath]



TC_005 Go to DW login page and login with fields filled with username and password
    Open Browser  ${URL}  ${Browser}
    Maximize Browser Window
    Title Should Be                Log in    # check we're on the login page

    # filling the username
    Set Focus To Element           ${paths}[username_box_relxpath]  # set focus on username box
    Input Text                     ${paths}[username_box_relxpath]  ${logins}[username]    clear = True


    # filling the password
    Set Focus To Element           ${paths}[password_box_relxpath]  # set focus on password box
    Input Password                 ${paths}[password_box_relxpath]  ${logins}[username]    clear = True


    # click loging button and see if we got in
    Click Element                      CSS = ${paths}[login_button_relcsspath]
    Page Should Not Contain Element    xpath:${paths}[login_error_relxpath]
    Page Should Contain Element        xpath:${paths}[logout_button_relxpath]
    Close Browser


#*** Tasks ***
# One file cannot have both tests and tasks!

*** Keywords ***



*** Comments ***