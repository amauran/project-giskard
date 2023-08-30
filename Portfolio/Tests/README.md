## WHAT IS TESTED

1) customer will place an order
2) shop manager will find the order, edit to add a discount coupon, mark the order as completed and save it.
3) customer will check new order to see a discount has been applied and the order is marked 'completed'
4) shop manager will find the order again, and delete it.

#### NOTES:

* The test will run in a single browser window, so customer and manager will log out when switching sides.
* For test purposes the payment method is set to 'cash on delivery', as we could not use any real payment methods at this stage. That is why the order status must first be changed to 'pending payment' or it can't be edited.
* This test implements a lot of user defined keywords from resource files:
    1) a wrapper file for either Seleniumlibrary or Browser library (chosen in the variables.yaml)
    2) user or manager keywords as needed to complete actions