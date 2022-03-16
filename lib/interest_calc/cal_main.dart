import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'input_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePageInputForm(),
      // home: MyHomePage(),
    );
  }
}

class HomePageInputForm extends StatefulWidget {
  @override
  _HomePageInputFormState createState() => _HomePageInputFormState();
}

class _HomePageInputFormState extends State<HomePageInputForm>
    with WidgetsBindingObserver {
  var _globalFormKey = GlobalKey<FormState>();
  var _currency = ['taka', 'rupee', 'dollar'];
  bool _showPassword = false;

  TextEditingController amountController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        // height of the TextFormField is calculated here, and we call setState to assign this value to Button
        _height = _globalFormKey.currentContext!.size!.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interest Calculator'),
      ),
      body: Form(
        key: _globalFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: getImageAsset(),
                ),
                CustomInputForm(
                  formTextController: amountController,
                  errorMsg: 'Please enter Amount',
                  formTitle: 'Amount',
                  formHint: 'Enter amount',
                  inputType: TextInputType.number,
                  leadingIcon: Icons.currency_exchange,
                ),
                // SizedBox(height: 20), // margin between two widgets
                Padding(padding: EdgeInsets.only(top: 20)),
                CustomInputForm(
                  formTextController: rateController,
                  errorMsg: 'Please enter Rate',
                  formTitle: 'Rate',
                  formHint: 'Enter rate',
                  inputType: TextInputType.number,
                  trailingIcon: Icons.lock,
                ),

                Padding(padding: EdgeInsets.only(top: 20)),
                // margin between two widgets
                Row(
                  //
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,            // aligning two widgets inside row
                  //
                  children: [
                    Flexible(
                      child: CustomInputForm(
                        formTextController: amountController,
                        errorMsg: 'Please enter Time',
                        formTitle: 'Time',
                        formHint: 'Enter time',
                        inputType: TextInputType.number,
                        detector: GestureDetector(
                          onTap: () {
                            _togglevisibility();
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        isObscure: !_showPassword,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          filled: true,
                          isDense: true,
                          hintStyle: TextStyle(fontSize: 15),
                          hintText: "Select Currency",
                          helperText: '',
                          errorStyle: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        onChanged: (String? s) {},
                        validator: (value) =>
                            value == null ? 'field required' : null,
                        items: _currency
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  // to set width match to parent
                  height: 50,
                  width: double.infinity,
                  child: MaterialButton(
                    child: Text(
                      "Calculate",
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    onPressed: () {
                      setState(() {
                        if (_globalFormKey.currentState!.validate()) {
                          print('validate');
                          _calculateTotalReturn();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('require all field')),
                          );
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/currency.png');
    Image image = Image(
      image: assetImage,
      width: 125,
      height: 125,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(40),
    );
  }

  void _calculateTotalReturn() {
    double amount = double.parse(amountController.text);
    print(amount);
  }
}
