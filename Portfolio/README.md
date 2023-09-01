# Project Giskard - The Portfolio

## A Robot Framework test with user defined keywords that are executable both with SeleniumLibrary and Browser library

### The portfolio contains:

* A robot test for the *Happy Robot Shop* (WordPress and WooCommerce) that includes:
  - the customer making an order
  - the manager editing order
  - the customer checking edited order
  - the manager deleting order


* User defined keyword wrappers for Selenium and Browser libraries:
  - each have the same user defined keywords, built based on the SeleniumLibrary and Browser library keywords
  - interchangeable, only one variable needs to be changed to switch from one to another

* User defined keywords for customer and shop manager actions
  - created using the wrapper keywords, so they work with either SeleniumLibrary or Browser library

* The .yaml variables files used
  - *locators.yaml*
      - contains variables used to locate things via selectors
      - this helps reduce clutter in the keywords and the actual test code
  - *product-names.yaml*
      - the products in the shop, both searchable names and url endings
  - *variables.yaml*
      - contains environment settings for the wrapper and browser used
  - *passwords_template.yaml*
      - a template file for passwords needed to login as a customer, a manager, or an admin


## To choose which web testing library to use

You only need to change one variable!

Edit the *Resources/Environment/variables.yaml* file, and set the wrapper to either **'selenium'** for SeleniumLibrary or **'browser'** for Browser library.

## To run the test

#### To run the test using default logging:
```bash
robot Order_handling_test.robot
```


#### To create test logs in the specified folders:
Selenium:
```bash
robot -d Logs/Selenium_library/ Order_handling_test.robot
```

Browser:
```bash
robot -d Logs/Browser_library/ Order_handling_test.robot
```


Browser library will run the test **headless** unless told otherwise, so edit the '*Open New Browser Window*' keyword in the *browser_wrapper.resource* file to change that. (The option is already there, it has just been commented out.)

Edit the *Resources/Environment/variables.yaml* file to choose the browser (I have only tested things with Chrome.)

## Notes on requirements to run test

*The Happy Robot Shop* set up as the test environment is not usable by others, so these tests cannot be run as they are. If you wish to try them out, in addition to Robot Framework and the required libraries, your test environment must include a test shop made with *WordPress + WooCommerce*.

You also  must edit the product related yaml files to contain the test items in your shop, and create a login credentials yaml file with the proper format. For this, you need to create one customer and one manager level user for your test shop.

If the folder structure is kept the same, the resource paths and locators should work, apart from of course any url that includes the name of your shop.

To learn more about the requirements and the test setup used, check how we built the [work environment](https://github.com/amauran/project-giskard/wiki/Setting-up-the-work-environment) and the [test environment](https://github.com/amauran/project-giskard/wiki/Setting-up-the-target-environment).