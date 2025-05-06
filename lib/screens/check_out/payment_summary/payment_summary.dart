import 'package:flutter/material.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/models/delivery_address_model.dart';
import 'package:food_app/providers/review_cart_provider.dart';
import 'package:food_app/screens/check_out/delivery_details/single_delivery_item.dart';
import 'package:food_app/screens/check_out/payment_summary/my_google_pay.dart';
import 'package:food_app/screens/check_out/payment_summary/order_item.dart';
import 'package:provider/provider.dart';
import 'package:food_app/providers/check_out_provider.dart';
import 'package:food_app/screens/check_out/order_confirmation/order_confirmation_screen.dart';

class PaymentSummary extends StatefulWidget {
  final DeliveryAddressModel deliverAddressList;
  PaymentSummary({required this.deliverAddressList});

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

enum AddressTypes {
  Home,
  OnlinePayment,
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var myType = AddressTypes.Home;
  bool showCheckoutSummary = false; // Add this state variable

  @override
  Widget build(BuildContext context) {
    ReviewCartProvider reviewCartProvider = Provider.of(context);
    reviewCartProvider.getReviewCartData();

    double discount = 30;
    double discountValue;
    double shippingChanrge = 3.7;
    double total;
    double totalPrice = reviewCartProvider.getTotalPrice();
    if (totalPrice > 300) {
      discountValue = (totalPrice * discount) / 100;
      total = totalPrice - discountValue;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Summary",
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkout summary container that appears when button is clicked
            if (showCheckoutSummary)
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Checkout Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 150, // Fixed height for the list
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reviewCartProvider.getReviewCartDataList.length,
                        itemBuilder: (context, index) {
                          var item = reviewCartProvider.getReviewCartDataList[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(item.cartImage),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) => AssetImage('assets/background.png'), // Added error handling
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            title: Text(
                              item.cartName,
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              "${item.cartUnit} - \$${item.cartPrice}",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              "x${item.cartQuantity}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "\$${totalPrice > 300 ? (totalPrice - (totalPrice * discount) / 100) + 5 : totalPrice + 5}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Call the order placement method
                              ReviewCartProvider reviewCartProvider =
                                  Provider.of<ReviewCartProvider>(context, listen: false);

                              // Get the checkout provider to save order data
                              CheckoutProvider checkoutProvider =
                                  Provider.of<CheckoutProvider>(context, listen: false);

                              // Add order data to Firebase
                              checkoutProvider.addPlaceOderData(
                                oderItemList: reviewCartProvider.getReviewCartDataList,
                                subTotal: totalPrice.toString(),
                                address: widget.deliverAddressList,
                                shipping: "5",
                              );

                              // Navigate to confirmation screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OrderConfirmationScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor, // Changed from primary to backgroundColor
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                "Confirm Order",
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ListTile(
              title: Text("Total Amount"),
              subtitle: Text(
                "\$${totalPrice > 300 ? (totalPrice - (totalPrice * discount) / 100) + 5 : totalPrice + 5}",
                style: TextStyle(
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              trailing: Container(
                width: 160,
                child: MaterialButton(
                  onPressed: () {
                    // Toggle the checkout summary visibility
                    setState(() {
                      showCheckoutSummary = !showCheckoutSummary;
                    });
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SingleDeliveryItem(
                  address:
                      "aera, ${widget.deliverAddressList.aera}, street, ${widget.deliverAddressList.street}, society ${widget.deliverAddressList.scoirty}, pincode ${widget.deliverAddressList.pinCode}",
                  title:
                      "${widget.deliverAddressList.firstName} ${widget.deliverAddressList.lastName}",
                  number: widget.deliverAddressList.mobileNo,
                  addressType: widget.deliverAddressList.addressType ==
                          "AddressTypes.Home"
                      ? "Home"
                      : widget.deliverAddressList.addressType ==
                              "AddressTypes.Other"
                          ? "Other"
                          : "Work",
                ),
                Divider(),
                ExpansionTile(
                  children: reviewCartProvider.getReviewCartDataList.map((e) {
                    return OrderItem(
                      e: e,
                    );
                  }).toList(),
                  title: Text(
                      "Order Items ${reviewCartProvider.getReviewCartDataList.length}"),
                ),
                Divider(),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Sub Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "\$${totalPrice + 5}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Shipping Charge",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "\$${totalPrice > 300 ? (totalPrice * discount) / 100 : 0}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Compen Discount",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "\$10",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Text("Payment Options"),
                ),
                RadioListTile(
                  value: AddressTypes.Home,
                  groupValue: myType,
                  title: Text("Home"),
                  onChanged: (AddressTypes? value) {
                    setState(() {
                      myType = value!;
                    });
                  },
                  secondary: Icon(
                    Icons.work,
                    color: primaryColor,
                  ),
                ),
                RadioListTile(
                  value: AddressTypes.OnlinePayment,
                  groupValue: myType,
                  title: Text("OnlinePayment"),
                  onChanged: (AddressTypes? value) {
                    setState(() {
                      myType = value!;
                    });
                  },
                  secondary: Icon(
                    Icons.devices_other,
                    color: primaryColor,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
