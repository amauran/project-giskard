# Project Giskard - The Portfolio

This contains the results of my learning process so far:

* The final order handling robot test for the Happy Robot shop (WordPress and WooCommerce)
  - the customer making an order
  - the manager editing order
  - the customer checking edited order
  - the manager deleting order


* The resources:
  - user defined keyword wrappers for Selenium and Browser libraries
  - user defined keywords for customer and shop manager
  - the locators and variables used, in yaml files (The password file is only a template, the real one is in gitignore.)


## To run the test

To choose which web testing library to use, edit the Resources/Environment/variables.yaml file, and set the wrapper to either 'selenium' for SeleniumLibrary or 'browser' for Browser library.

Note: Browser library will run the test headless unless told otherwise. Edit the 'Open New Browser Window' keyword in the browser_wrapper.resource file to change that. (The option is already there, it has just been commented out.)

Edit the same file to choose the browser (I have only tested things with Chrome.)

#### To run the test using default logging:
`robot Order_handling_test.robot`


#### To create test logs in the specified folders:
Selenium: `robot -d Logs/Selenium_library/ Order_handling_test.robot`\
Browser: `robot -d Logs/Browser_library/ Order_handling_test.robot`


### NOTE:

*The Happy Robot Shop* set up as the test environment is not usable by others, so these tests cannot be run as they are. If you wish to try them out, in addition to Robot Framework and the required libraries, your test environment must include a test shop made with *WordPress + WooCommerce*.

You also  must edit the product related yaml files to contain the test items in your shop, and create a login credentials yaml file with the proper format. For this, you need to create one customer and one manager level user for your test shop.

If the folder structure is kept the same, the resource paths and locators should work, apart from of course any url that includes the name of your shop.

To learn more about the requirements and the test setup used, check how we built the [work environment](https://github.com/amauran/project-giskard/wiki/Setting-up-the-work-environment) and the [test environment](https://github.com/amauran/project-giskard/wiki/Setting-up-the-target-environment).