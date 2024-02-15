import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Entry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataEntryPage(),
    );
  }
}

class DataEntryPage extends StatefulWidget {
  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  TextEditingController numberController = TextEditingController();
  TextEditingController kilometerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController inHourController = TextEditingController();
  TextEditingController inMinuteController = TextEditingController();
  TextEditingController outHourController = TextEditingController();
  TextEditingController outMinuteController = TextEditingController();

  List<Map<String, dynamic>> entries = [];
  List<int> historyNumbers = [];

  void addEntry() {
    setState(() {
      int number = int.parse(numberController.text);
      historyNumbers.add(number);

      DateTime inTime = DateTime(
        int.parse(dateController.text.split('-')[0]),
        int.parse(dateController.text.split('-')[1]),
        int.parse(dateController.text.split('-')[2]),
        int.parse(inHourController.text),
        int.parse(inMinuteController.text),
      );
      DateTime outTime = DateTime(
        int.parse(dateController.text.split('-')[0]),
        int.parse(dateController.text.split('-')[1]),
        int.parse(dateController.text.split('-')[2]),
        int.parse(outHourController.text),
        int.parse(outMinuteController.text),
      );

      if (outTime.isBefore(inTime)) {
        outTime = outTime.add(Duration(days: 1));
      }

      entries.add({
        'number': number,
        'kilometer': double.tryParse(kilometerController.text) ?? 0.0,
        'inTime': inTime,
        'outTime': outTime,
      });
      numberController.clear();
      kilometerController.clear();
      dateController.clear();
      inHourController.clear();
      inMinuteController.clear();
      outHourController.clear();
      outMinuteController.clear();
    });
  }

  double getTotalKilometer() {
    double total = 0.0;
    for (var entry in entries) {
      total += entry['kilometer'];
    }
    return total;
  }

  Duration getTotalHours() {
    Duration total = Duration.zero;
    for (var entry in entries) {
      DateTime inTime = entry['inTime'];
      DateTime outTime = entry['outTime'];
      total += outTime.difference(inTime);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number'),
              ),
              TextField(
                controller: kilometerController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Kilometer'),
              ),
              TextField(
                controller: dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inHourController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'In Hour (HH)'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: inMinuteController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'In Minute (MM)'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: outHourController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Out Hour (HH)'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: outMinuteController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Out Minute (MM)'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addEntry,
                child: Text('Add Entry'),
              ),
              SizedBox(height: 16.0),
              Text('Total Kilometer: ${getTotalKilometer()}'),
              Text('Total Hours: ${getTotalHours().inHours} hours ${getTotalHours().inMinutes.remainder(60)} minutes'),
              SizedBox(height: 16.0),
              Text('History:'),
              Wrap(
                spacing: 8,
                children: historyNumbers.map((number) {
                  return ElevatedButton(
                    onPressed: () {
                      numberController.text = number.toString();
                    },
                    child: Text(number.toString()),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text('Entries:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Number: ${entry['number']}'),
                      Text('Kilometer: ${entry['kilometer']}'),
                      Text('In Time: ${entry['inTime'].hour.toString().padLeft(2, '0')}:${entry['inTime'].minute.toString().padLeft(2, '0')}'),
                      Text('Out Time: ${entry['outTime'].hour.toString().padLeft(2, '0')}:${entry['outTime'].minute.toString().padLeft(2, '0')}'),
                      SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

