

*** Settings ***

Library  SeleniumLibrary


*** Variables ***
${Browser}  Chrome
${URL}  https://www.google.com/

*** Test Cases ***
TC_001 Browser Start and Close
    Open Browser  ${URL}  ${Browser}
    Close Browser