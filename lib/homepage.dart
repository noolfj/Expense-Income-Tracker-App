import 'dart:async';
import 'package:flutter/material.dart';
import 'google_sheets_api.dart';
import 'loading_circle.dart';
import 'plus_button.dart';
import 'top_card.dart';
import 'transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }

  void _newTransaction() {
    _textcontrollerITEM.clear();
    _textcontrollerAMOUNT.clear();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'Новая транзакция',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Приход',
                          style: TextStyle(
                            fontSize: 20,
                            color: _isIncome ? Colors.green : Colors.grey,
                          ),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: !_isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = !newValue;
                              });
                            },
                            activeColor: Colors.red,
                            inactiveTrackColor: Colors.greenAccent,
                          ),
                        ),
                        Text(
                          'Расход',
                          style: TextStyle(
                            fontSize: 20,
                            color: !_isIncome ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Для чего?',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Введите описание';
                              }
                              return null;
                            },
                            controller: _textcontrollerITEM,
                            style: TextStyle(),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Сумма',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Введите сумму';
                              }
                              return null;
                            },
                            controller: _textcontrollerAMOUNT,
                            style: TextStyle(),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  color: Color(0xff008000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Добавить',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _enterTransaction();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.04,
            ),
            TopNeuCard(
              balance: (GoogleSheetsApi.calculateIncome() -
                      GoogleSheetsApi.calculateExpense())
                  .toString(),
              income: GoogleSheetsApi.calculateIncome().toString(),
              expense: GoogleSheetsApi.calculateExpense().toString(),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: GoogleSheetsApi.loading == true
                            ? LoadingCircle()
                            : ListView.builder(
                                itemCount:
                                    GoogleSheetsApi.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return MyTransaction(
                                    transactionName: GoogleSheetsApi
                                        .currentTransactions[index][0],
                                    money: GoogleSheetsApi
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GoogleSheetsApi
                                        .currentTransactions[index][2],
                                  );
                                }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
