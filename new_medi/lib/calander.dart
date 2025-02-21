import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'questions.dart';
import 'dart:async';
import 'dart:convert';

class TimeSlot {
  // ignore: non_constant_identifier_names
  final String Title;
  // ignore: non_constant_identifier_names
  final String Selection;
  // ignore: non_constant_identifier_names
  final DateTime Time;

  const TimeSlot(
      // ignore: non_constant_identifier_names
      {required this.Title,
      required this.Selection,
      required this.Time});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      Title: json['Title'],
      Selection: json['Selection'],
      Time: DateTime.parse(json['Time']),
    );
  }
}

//  <uses-permission android:name="android.permission.INTERNET" />
class Booking extends StatefulWidget {
  final String location;
  const Booking({super.key, required this.location});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Future<TimeSlot> _setTime(
      // ignore: non_constant_identifier_names
      String Title,
      String Selection,
      DateTime Time) async {
    final response = await http.post(
      Uri.parse('https://medi.bto.bistecglobal.com/api/SaveTimeSlot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Title': Title,
        'Selection': Selection,
        'Time': Time.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/questions');
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return TimeSlot.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  String place = '';
  @override
  void initState() {
    super.initState();
    place = widget.location;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String dropdownvalue1 = '09.00 a.m';
  var items1 = [
    '09.00 a.m',
    '11.00 a.m',
    '12.00 a.m',
    '03.00 p.m',
    '05.00 p.m',
    '07.00 p.m',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Schedule"),
      ),
      body: Column(
        children: [
          Container(
            height: 393,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 201, 228, 250),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2033, 10, 26),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 1, left: 20, right: 20, bottom: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text("Preffered Time Slots"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    DropdownButton(
                        value: dropdownvalue1,
                        // ignore: prefer_const_constructors
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        items: items1.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 9, 169, 20)),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue1 = newValue!;
                          });
                        }),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 137, 193, 238),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "09.00 a.m",
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 139, 199, 155),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "11.00 a.m",
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 242, 179, 133),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "12.00 a.m",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 235, 169, 218),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "03.00 p.m",
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 172, 243, 192),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "05.00 p.m",
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 169, 163, 245),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "07.00 p.m",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.only(
                          top: 3, bottom: 5, right: 30, left: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 29, 121, 242),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _setTime(place, dropdownvalue1, _focusedDay);
                          });
                        },

                        //  _setTime(dropdownvalue2.,dropdownvalue1, _selectedDay),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
