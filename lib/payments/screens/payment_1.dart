
import 'package:braintree/braintree.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/widgets/event_widget.dart';

import 'package:http/http.dart' as http;

class PaymentMainPage extends StatefulWidget {
  @override
  _PaymentMainPageState createState() => _PaymentMainPageState();
}

class _PaymentMainPageState extends State<PaymentMainPage> {

  Event event;

  startPayment()async{

    final request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_q7zgyn9g_fr7wvkwvcn3mw39z',
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: event.admissionPrice,
        currencyCode: 'CAD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: event.admissionPrice,
        displayName: 'Links',
      ),
    );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);

    if (result != null) {
      var resultHTTP = await http.post(
        Uri.parse("https://us-central1-links-170cf.cloudfunctions.net/paypalPayment"),
        body: {
          'payment_method_nonce' : result.paymentMethodNonce.toString(),
          'ammount': event.admissionPrice,
          'device_data': result.deviceData
        }
      );

      print(resultHTTP.body);

      if(resultHTTP.body == "Success"){
        //Add to event + anything else after payment



      }

    } else {
      print('Selection was canceled.');
    }

  }

  @override
  Widget build(BuildContext context) {

    event = ModalRoute.of(context).settings.arguments as Event;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment to join"),
      ),
      body: Column(
        children: [
          WidgetMyPage(event),
          Expanded(child: SizedBox()),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  )
                )
              ),
              onPressed: ()=>startPayment(),
              icon: Icon(Icons.payment),
              label: Text("Pay and join")
            ),
          )
        ],
      ),
    );
  }

}
