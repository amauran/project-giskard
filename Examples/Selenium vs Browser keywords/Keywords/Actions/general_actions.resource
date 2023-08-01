*** Settings ***
Documentation    user created keywords for general actions

Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml
# Variables       ../Utils/browsernames.yaml

Resource        ../Platform/${wrapper}_wrapper.resource



*** Variables ***
# this variable is for choosing the correct browser
# the value will be the environment indicated browser name,
# that depends on the selected browser and web library wrapper
#${testing_browser} =      ${${wrapper}_names}[${browser}]



*** Keywords ***
Open Browser And Go To Login Page

    Open New Browser Window           ${usebrowser}
    Go To Given Page                  ${login_url}
    Check Location By URL             ${login_url}


Close Browser
    Close Current Browser