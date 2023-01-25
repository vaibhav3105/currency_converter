import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Map<String, dynamic> currency_data = {};
  List<String> currencyCodes = [];

  Future getData() async {
    final response = await http.get(
      Uri.parse("https://currencyscoop.p.rapidapi.com/latest"),
      headers: {
        "X-RapidAPI-Key": "5c5dfeca9emsh1b623633cde3cbep13b787jsn8136dc438b87",
        "X-RapidAPI-Host": "currencyscoop.p.rapidapi.com"
      },
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    setState(() {
      currency_data = data['response']['rates'];
    });
    currency_data.forEach((key, value) {
      currencyCodes.add(key);
    });
  }

  displayCurrency(String from, String to, double amount) {
    double unitConversion = currency_data[to] / currency_data[from];
    double final_amount = unitConversion * amount;
    setState(() {
      price = final_amount;
    });
  }

  String from = "USD";
  String to = "INR";
  double price = 0;

  // String initialFrom = "USD";
  // String initialTo = "INR";
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                "Currency Converter",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 50,
              ),
              DropdownButton(
                value: from,
                items:
                    currencyCodes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    from = value!;
                  });
                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    String x = from;
                    from = to;
                    to = x;
                  });
                },
                icon: Icon(
                  Icons.swap_calls,
                ),
              ),
              DropdownButton(
                value: to,
                items:
                    currencyCodes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    to = value!;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  displayCurrency(
                    from,
                    to,
                    double.parse(
                      amountController.text.trim(),
                    ),
                  );
                },
                child: Text("Get Price"),
              ),
              SizedBox(
                height: 40,
              ),
              if (price > 0)
                Text(
                  price.toString(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
