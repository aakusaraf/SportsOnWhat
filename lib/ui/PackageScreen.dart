import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sportson/models/UserData.dart';

import '../provider/AuthProvider.dart';
import '../resources/StyleResources.dart';
import '../widgets/MainTitle.dart';
import '../widgets/MyTextbox.dart';
import '../widgets/UnorderedList.dart';
import '../widgets/loading_screen.dart';

class PackageScreen extends StatefulWidget {

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  AuthProvider provider;
  int selectedIndex = -1;
  var selectedValue;
  getdata() async
  {
    await provider.getPackageDetails(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false);
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      body: (provider.allpackages==null)?loading_screen():Container(
        color: StyleResources.BlueColor,
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: StyleResources.ContainerSize,right: StyleResources.ContainerSize),
            color: StyleResources.BlueColor,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_backspace,color: Colors.white,size: 30.0),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 25.0,),
                      Text("Subscriptions",style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 20.0,
                          color: StyleResources.WhiteColor
                      ))
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: MainTitle(
                      text: "SPORTS ON WHAT",
                    ),
                  ),
                  SizedBox(height: 17.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text("CHOOSE SUBSCRIPTION",textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          height: 1.3,
                          fontSize: 20.0,
                          color: StyleResources.WhiteColor
                      ),),
                  ),
                 /* SizedBox(height: 8.0),

                  Align(
                    alignment: Alignment.center,
                    child: Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.3,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 14.0,
                          color: StyleResources.WhiteColor
                      ),),
                  ),*/
                  SizedBox(height: 15.0),
                  Row(
                      children: <Widget>[
                        SizedBox(
                          width: 50.0,
                        ),
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1.5,
                            )
                        ),
                        Container(
                          child: Text("PLANS",style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            fontSize: 16.0,
                            color: Colors.black
                          ),),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0,bottom: 10.0),
                          decoration: BoxDecoration(
                            color: StyleResources.WhiteColor,
                            borderRadius: BorderRadius.circular(25.0)
                          ),
                        ),

                        Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1.5,
                            )
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                      ]
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                 ListView.builder(
                    physics: ScrollPhysics(),
                     shrinkWrap: true,
                     itemCount: provider.allpackages.length,
                     itemBuilder: (context,index){
                       return  GestureDetector(
                         onTap: (){
                           setState(() {
                             selectedIndex = index;
                           });
                         },
                         child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20.0),
                               margin: EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text("\$"+provider.allpackages[index].packPrice.toString()+"/"+provider.allpackages[0].packDuration.toString(),style: TextStyle(
                                color:selectedIndex == index ? StyleResources.GreenColor : StyleResources.WhiteColor,
                                fontFamily: 'PoppinsMedium',
                                fontSize: 20.0,
                                letterSpacing: 1.0,
                                height: 1.3
                              )),
                              SizedBox(
                                height: 4.0,
                              ),
                              Html(
                                data: provider.allpackages[index].packDescription.toString(),
                                defaultTextStyle: TextStyle(
                                  color:selectedIndex == index ? StyleResources.GreenColor : StyleResources.WhiteColor,),
                              ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                            color: StyleResources.WhiteColor.withOpacity(0.2),
                          border: Border.all(
                              color:selectedIndex == index ? StyleResources.GreenColor : StyleResources.WhiteColor,
                              width: 2.0
                          )
                        ),
                  ),
                       );

                 }),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        
                        var selectedOption = provider.allpackages[selectedIndex];
                        var selectedPrice = selectedOption.packPrice;
                        Razorpay razorpay = Razorpay();
                        var options = {
                          'key': 'rzp_test_R1pLXp1MH1M1nZ',
                          'amount': int.parse(selectedPrice) * 100,
                          'name': 'Sports On What',
                          'description': 'Fine T-Shirt',
                          'retry': {'enabled': true, 'max_count': 1},
                          // 'send_sms_hash': true,
                          'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                          'external': {
                            'wallets': ['paytm']
                          }
                        };
                        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                        razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                        razorpay.open(options);
                      },
                      child: Text("Pay Now"),
                      style:  ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(left: 22.0,right: 22.0,top: 11.0,bottom: 11.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          primary: StyleResources.GreenColor,
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PoppinsMedium',
                              fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 54.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void handlePaymentErrorResponse(PaymentFailureResponse response){

    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response)async{
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    var paymentid = response.paymentId;
    Map<String,dynamic> params = {
      "user_id":provider.loggedinuser.userId.toString(),
      "paymentid":paymentid.toString(),
      "amount" : provider.allpackages[selectedIndex].packPrice.toString(),
      "status" : "Complete"
    };
    print("params = ${params}");
    await provider.addPackage(context,params);



  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
