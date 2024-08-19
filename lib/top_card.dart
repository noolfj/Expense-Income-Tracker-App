import 'package:flutter/material.dart';

class TopNeuCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;

  TopNeuCard({
    required this.balance,
    required this.expense,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Б А Л А Н С',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16)),
              Text(
                '\$' + balance,
                style: TextStyle(color: Colors.grey[800], fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/arrow_up.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Приход',
                                style: TextStyle(color: Colors.grey[500])),
                            SizedBox(
                              height: 5,
                            ),
                            Text('\$' + income,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/arrow_down.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Расход',
                                style: TextStyle(color: Colors.grey[500])),
                            SizedBox(
                              height: 5,
                            ),
                            Text('\$' + expense,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
