*** Settings ***
# paths to variable files needed for login (login info and locator paths)
# NOTE: shop_loginpwds.yaml is in gitignore and the test will not pass without it
# the password yaml file must contain the login info in this format:
#
# logins:
#     username: username
#     password: password

Variables  ../Resources/shop_loginpwds.yaml
Variables  ../Resources/shop_paths.yaml

# importing user defined keywords from a resource file
Resource    user_keywords.resource

# importing libraries
Library    SeleniumLibrary

*** Variables ***
# setting required variables
${browser}               Chrome

# variables for login - path information retrieved from shop_paths.yaml
# here the variable names are kept the same as in the user_keywords.resource file
# NOTE: if using '=' when setting variables (it is optional)
# there can be only one space between variable name and '=' or things will not work
${login_url} =           ${paths}[login_url]
${login_button} =        //button[@name='login']
${field_username} =      ${paths}[username_box_relxpath]
${field_password} =      ${paths}[password_box_relxpath]
${user_username} =       ${logins}[username]
${user_password} =       ${logins}[password]
${login_button} =        ${paths}[login_button_relxpath]
${login_checkforpass} =  //a[normalize-space()='Account details']

*** Test Cases ***
# creating test case 'Login As Existing User'
# using predefined keywords and variables
# variables have been set in 'Variables,
# keywords are set in resource file 'user_keywords.resource'
Login As Existing User
    Open Login Page        ${login_url}       ${browser}
    Enter Username         ${field_username}  ${user_username}
    Enter Password         ${field_password}  ${user_password}
    Click Login Button     ${login_button}    ${login_checkforpass}

    Close Browser