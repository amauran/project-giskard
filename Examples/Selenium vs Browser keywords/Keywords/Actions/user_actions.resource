*** Settings ***
Documentation    user created keywords for regular user actions

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml

# import password file (this is in gitignore!!!)
Variables        ../../../Resources/shop_loginpwds.yaml

# import environment indicated keyword wrapper (selenium or browser)
Resource        ../Platform/${wrapper}_wrapper.resource

*** Variables ***


*** Keywords ***
Enter User Username
    Fill Text Field With Input        ${username_field}    ${logins}[username]

Enter User Password
    Fill Password Field With Input    ${password_field}    ${logins}[password]

