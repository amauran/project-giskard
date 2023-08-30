*** Settings ***
Documentation    user created keywords for admin actions

# import test environment variables and locators
Variables       ../../Environment/variables.yaml
Variables       ../../Environment/locators.yaml

# import password file (this is in gitignore!!!)
Variables        ../../../Resources/shop_loginpwds.yaml

# import keyword wrapper (selenium or browser) indicated by the variables.yaml file
Resource        ../Wrappers/${wrapper}_wrapper.resource

*** Variables ***


*** Keywords ***