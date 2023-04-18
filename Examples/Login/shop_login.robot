*** Settings ***

Library  SeleniumLibrary

# Importing resouce files
Variables  /home/anne/Git/project-giskard/Examples/Login/resources/shop_loginpwds.yaml
Variables  /home/anne/Git/project-giskard/Examples/Login/resources/shop_paths.yaml

*** Variables ***
${Browser}  Chrome
${URL}  https://happy-robot.nimbus.fi/my-account/   # test shop login page url


# Resource files are imported using the Resource setting in the Settings table.
# The path to the resource file is given in the cell after the setting name.

*** Test Cases ***

Shop Login With Existing Customer
    Open Browser                   ${URL}        ${Browser}
    Maximize Browser Window

    # make sure location is login page
    Location Should Be             ${paths}[login_url]

    # make sure focus is set in the username box
    Set Focus To Element           ${paths}[username_box_relxpath]
    # fill in username after clearing the field
    Input Text                     ${paths}[username_box_relxpath]  ${logins}[username]    True

    # set focus in password box
    Set Focus To Element           ${paths}[password_box_relxpath]  # set focus on password box
    # fill in password after clearing the field (Input Password -> will produce no log of passowrd on normal log levels)
    Input Password                 ${paths}[password_box_relxpath]  ${logins}[password]    True

    # click loging button and see if we got in by checking if 'Account details' link exists
    Click Button                   xpath = ${paths}[login_button_relxpath]
    Page Should Contain Element    xpath = //a[normalize-space()='Account details']
    Close Browser


#*** Tasks ***
# One file cannot have both tests and tasks!

*** Keywords ***



*** Comments ***