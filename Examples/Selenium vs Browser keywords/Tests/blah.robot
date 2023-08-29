*** Settings ***

Library  SeleniumLibrary

# importing variable file with test environment specific variables
Variables       ../Environment/variables.yaml


*** Variables ***

${Browser} =    ${usebrowser}
${URL}  https://www.google.com

*** Test Cases ***
Open And Close Chrome
    Open Browser    ${URL}    ${Browser}
    Close Browser