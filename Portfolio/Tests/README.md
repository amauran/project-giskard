## WHAT IS TESTED

The test uses the Happy Robot test shop created with WordPress and the WooCommerce plugin. The test run has four segments:

1) the customer will add items to shopping cart and place an order.
2) the shop manager will find the order, edit to add a discount coupon, then marks the order as completed and saves it.
3) the customer will then check the order to see a discount has been applied and the order is marked as 'completed'
4) the shop manager will find the order again, and delete it.

#### NOTES:

* The test will run in a single browser window, so customer and manager will log out when switching sides.
* For test purposes the payment method is set to 'cash on delivery', as we could not use any real payment methods at this stage. That is why the order status must first be changed to 'pending payment' or it can't be edited.
* This test implements a lot of user defined keywords from resource files:
    1) a wrapper file for either Seleniumlibrary or Browser library (chosen in the variables.yaml)
    2) user or manager keywords as needed to complete actions