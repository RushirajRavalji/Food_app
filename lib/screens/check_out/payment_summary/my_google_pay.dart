import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class MyGooglePay extends StatefulWidget {
  final String? total;

  const MyGooglePay({Key? key, this.total}) : super(key: key);

  @override
  _MyGooglePayState createState() => _MyGooglePayState();
}

class _MyGooglePayState extends State<MyGooglePay> {
  late Future<PaymentConfiguration> _paymentConfigFuture;

  @override
  void initState() {
    super.initState();
    _paymentConfigFuture =
        PaymentConfiguration.fromAsset('sample_payment_configuration.json');
  }

  void onGooglePayResult(paymentResult) {
    print(paymentResult);
    // Send the resulting Google Pay token to your server or PSP
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaymentConfiguration>(
      future: _paymentConfigFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GooglePayButton(
            paymentConfiguration: snapshot.data!,
            paymentItems: [
              PaymentItem(
                label: 'Total',
                amount: widget.total ?? '0.00',
                status: PaymentItemStatus.final_price,
              )
            ],
            width: double.infinity,
            height: 50,
            type: GooglePayButtonType.pay,
            onPaymentResult: onGooglePayResult,
          );
        } else if (snapshot.hasError) {
          return Text('Error loading payment configuration');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
