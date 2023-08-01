*** Settings ***

# importing variable file with test environment specific variables
Variables       ../Environment/variables.yaml
Variables       ../Environment/locators.yaml

# importing variable file with names Selenium/Browser use for different browsers
# Variables       ../Keywords/Utils/browsernames.yaml

Resource    ../Keywords/Actions/general_actions.resource
Resource    ../Keywords/Actions/user_actions.resource


*** Variables ***
${browser}  ${usebrowser}
${URL}  https://happy-robot.nimbus.fi/my-account/

*** Test Cases ***
Login As Existing User
    Open Browser And Go To Login Page
    Enter User Username
    Enter User Password
    Click That Button          ${login_button}
    Check Location By Element  ${checkforpass}
    general_actions.Close Browser

*** Keywords ***


*** Comments ***