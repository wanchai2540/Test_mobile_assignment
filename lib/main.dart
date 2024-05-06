// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Assignment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> dataModal = [];
  List<Map<String, dynamic>> squareData = [];
  List<Map<String, dynamic>> crossData = [];
  List<Map<String, dynamic>> circleData = [];
  ScrollController controller = ScrollController();
  int? lastRemovedIndex;
  int? lastAddedIndex;

  @override
  void initState() {
    for (int i = 0; i <= 40; i++) {
      _sumFibo(i);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: dataModal.length,
        itemBuilder: (context, int index) {
          int keyIndex = dataModal[index]["index"];
          int num = dataModal[index]["result"];
          IconData icon = dataModal[index]["icon"];

          return Container(
            color: lastRemovedIndex == index ? Colors.red[200] : Colors.transparent,
            child: ListTile(
              title: Text("Index: ${keyIndex}, Number: ${num}"),
              trailing: IconButton(
                icon: Icon(icon),
                onPressed: () {
                  setState(() {
                    if (icon == Icons.crop_square_outlined) {
                      lastAddedIndex = dataModal[index]["index"];
                      squareData.add(dataModal[index]);
                      bottomSheet(context, squareData);
                    } else if (icon == Icons.close) {
                      lastAddedIndex = dataModal[index]["index"];
                      crossData.add(dataModal[index]);
                      bottomSheet(context, crossData);
                    } else if (icon == Icons.circle) {
                      lastAddedIndex = dataModal[index]["index"];
                      circleData.add(dataModal[index]);
                      bottomSheet(context, circleData);
                    }

                    dataModal.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> bottomSheet(BuildContext context, List data) {
    data.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            padding: EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, int key) {
              int keyIndex = data[key]["index"];
              int result = data[key]["result"];
              IconData icon = data[key]["icon"];
              return ListTile(
                tileColor: lastAddedIndex == keyIndex ? Colors.green[500] : Colors.transparent,
                title: Text("Number: ${result}"),
                subtitle: Text("index: ${keyIndex}"),
                trailing: Icon(icon),
                onTap: () {
                  setState(() {
                    lastRemovedIndex = data[key]["index"];
                    dataModal.insert(data[key]["index"], data[key]);

                    controller.animateTo(
                      data[key]["index"] * 40.toDouble(),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    data.removeAt(key);
                    Navigator.pop(context);
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  _sumFibo(int index) {
    int number = 0;
    Map<String, dynamic> result = {};
    if (index == 0) {
      result = {"index": index, "result": index, "icon": Icons.circle};
      dataModal.add(result);
      return result;
    } else if (index == 1) {
      result = {"index": index, "result": index, "icon": Icons.crop_square_outlined};
      dataModal.add(result);
      return result;
    }

    IconData iconDemo = Icons.circle;
    IconData icon1 = dataModal[index - 1]["icon"];
    IconData icon2 = dataModal[index - 2]["icon"];

    // Square
    if ((icon1 == Icons.close) && (icon2 == Icons.close)) {
      iconDemo = Icons.crop_square_outlined;
    } else if ((icon1 == Icons.circle) && (icon2 == Icons.crop_square_outlined) ||
        (icon1 == Icons.crop_square_outlined) && (icon2 == Icons.circle)) {
      iconDemo = Icons.crop_square_outlined;
    }

    // Cross
    else if ((icon1 == Icons.crop_square_outlined) && (icon2 == Icons.crop_square_outlined)) {
      iconDemo = Icons.close;
    } else if ((icon1 == Icons.close) && (icon2 == Icons.circle) || (icon1 == Icons.circle) && (icon2 == Icons.close)) {
      iconDemo = Icons.close;
    }

    // Circle
    else if ((icon1 == Icons.crop_square_outlined) && (icon2 == Icons.close) ||
        (icon1 == Icons.close) && (icon2 == Icons.crop_square_outlined)) {
      iconDemo = Icons.circle;
    }

    number = (index - 1) + (index - 2);
    result = {"index": index, "result": number, "icon": iconDemo};
    dataModal.add(result);
    return result;
  }
}
