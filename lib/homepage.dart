import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excellib;
import 'package:flutter/services.dart';
import 'package:project_teeth/logic.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum AllGenders {male, female}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  //data / assets
  var excel;

  getDataFromMyAssets() async {
    var data = await rootBundle.load('table.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    setState(() {
      excel = excellib.Excel.decodeBytes(bytes);
    });
  }

  AllGenders? _selected = AllGenders.female;

  // ignore: prefer_typing_uninitialized_variables
  var craniumHeight;
  // ignore: prefer_typing_uninitialized_variables
  var craniumWidth;

  // ignore: prefer_typing_uninitialized_variables
  var bodyHeight;
  // ignore: prefer_typing_uninitialized_variables
  var bodyWeight;

  List response = [];

  Widget output = Text('');

  Widget getResultWidget() { //response
    List<Widget> results = parseResponse();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
          children: [

            const Align(alignment: Alignment.centerLeft, child: Padding(padding:EdgeInsets.symmetric(vertical: 20.5), child:Text('Введенные данные', style: TextStyle(color: Color.fromARGB(255, 2, 84, 100), fontWeight: FontWeight.bold),))),

            results[0],

            const Align(alignment: Alignment.centerLeft, child: Padding(padding:EdgeInsets.symmetric(vertical: 20.5), child:Text('Зубные аномалии', style: TextStyle(color: Color.fromARGB(255, 68, 173, 172), fontWeight: FontWeight.bold),))),

            results[1],

            Padding(
              padding: const EdgeInsets.only(top: 20.8),
              child: results[2]
            )

          ]
        )
      );
  }

  List<Widget> parseResponse() {
    //1
    Map response1 = response[0];
    //2
    Map response2 = response[1];


    Widget result1 = 
    Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        child: Table(
          border: TableBorder.all(color: const Color.fromARGB(255, 2, 84, 100), width: 2),
          children: [

            TableRow(
              children: [
                TableCell(child: Container(color: const Color.fromARGB(255, 2, 84, 100), child: const Padding(padding: EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text('Параметр', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))))),
                TableCell(child: Container(color: const Color.fromARGB(255, 2, 84, 100), child: const Padding(padding: EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text('Введенные данные', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))))),
                TableCell(child: Container(color: const Color.fromARGB(255, 2, 84, 100), child: const Padding(padding: EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text('Результат', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))))),
              ]
            ),

            TableRow(
              children: [
                const TableCell(child: Padding(padding: EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text('Гендер')) ),
                TableCell(child: Padding(padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text(response1['g'])) ),
                TableCell(child: Padding(padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text(response2['gender'])) )
              ]
            ),

            TableRow(
              children: [
                const TableCell(child: Padding(padding: EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text('Черепной индекс')) ),
                TableCell(child: Padding(padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text(response1['ci'].toString())) ),
                TableCell(child: Padding(padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text(response2['cranium'])) )
              ]
            ),

            TableRow(
              children: [
                const TableCell(child: Padding(padding: EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text('Индекс массы тела')) ),
                TableCell(child: Padding(padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text(response1['bmi'].toString())) ),
                TableCell(child: Padding(padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6), child: Text(response2['body'])) )
              ]
            )
          ]
        )
      )
    );


    //3
    List<Map> response3 = response[2];
    //4
    List<double> response4 = response[3];

    List<TableRow> rows = [];
    for (var anomaly in response3) {
      rows.add(
        TableRow(
          children: [
            TableCell(child: Padding(padding: const EdgeInsets.all(6), child: Text(anomaly.keys.elementAt(0).toString())) ),
            TableCell(child: Padding(padding: const EdgeInsets.all(6), child: Text(anomaly.values.elementAt(0).toString()+'%')) )
          ]
        )
      );
    }

    Widget result2 = 
    Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        // width: 100,
        child: Table(
          border: TableBorder.all(color: Color.fromARGB(255, 68, 173, 172), width: 2),
          children: rows
        )
      )
    );

    Widget result3 = 
    Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(response4[0].toString()+'% людей со схожими параметрами изначально обладают ортогнотическим прикусом.')),
          Align(alignment: Alignment.centerLeft, child: Text(response4[1].toString()+'% людей носят брекеты.')),
          Align(alignment: Alignment.centerLeft, child: Text(response4[2].toString()+'% людей прошли ортогнотическое лечение.')),
        ]
    );

    return [result1, result2, result3];

  }

  setResponse() async {
    setState(() {
      response = parseData(
        _selected == AllGenders.female ? true : false, 
        double.parse(craniumHeight), 
        double.parse(craniumWidth), 
        double.parse(bodyHeight), 
        double.parse(bodyWeight),
        excel
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    getDataFromMyAssets();
    // print((excel == null ? false : true)..toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Форма')),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text('Ответьте на вопросы ниже, чтобы увидеть результат', style: TextStyle(color: Color.fromARGB(255, 24, 151, 143), fontWeight: FontWeight.bold),),

              //form box
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [ IntrinsicHeight(child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // question 1 - gender
                          Container(
                            width: (MediaQuery.of(context).size.width - 80) / 3,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromARGB(255, 84, 186, 185), width: 4)
                            ),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('1. Ваш пол')
                                ),
                                Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [



                                      Expanded(
                                        child: ListTile(
                                          title: const Text('F'),
                                          leading: Radio(
                                            value: AllGenders.female, 
                                            groupValue: _selected, 
                                            onChanged: (AllGenders? value) {
                                              setState(() {
                                                _selected = value;
                                              });
                                            }
                                          )
                                        )
                                      ),

                                      Expanded(
                                        child: ListTile(
                                          title: const Text('M'),
                                          leading: Radio(
                                            value: AllGenders.male, 
                                            groupValue: _selected, 
                                            onChanged: (AllGenders? value) {
                                              setState(() {
                                                _selected = value;
                                              });
                                            }
                                          )
                                        ),
                                      )



                                    ]
                                  )
                                ),



                              ],
                            ),
                          ),



                          // question 2 - cranium
                          Container(
                            width: (MediaQuery.of(context).size.width - 80) / 3,
                            // height: 225,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromARGB(255, 24, 151, 143), width: 4)
                            ),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('2. Информация о черепе')
                                ),
                                Container(
                                  height: 125,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration( 
                                            hintText: 'высота, см',
                                            border: OutlineInputBorder(),
                                            focusColor: Color.fromARGB(255, 0, 112, 84)
                                          ),
                                          onSaved: (value){
                                            setState(() {
                                              craniumHeight = value;
                                            });
                                          },
                                        )
                                      ),



                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration( 
                                            hintText: 'ширина, см',
                                            border: OutlineInputBorder(),
                                            focusColor: Color.fromARGB(255, 0, 112, 84)
                                          ),
                                          onSaved: (value){
                                            setState(() {
                                              craniumWidth = value;
                                            });
                                          },
                                        )
                                      )



                                    ]
                                  )
                                )



                              ],
                            )
                          ),




                          // question 3 - body
                          Container(
                            width: (MediaQuery.of(context).size.width - 80) / 3,
                            // height: 225,
                            padding: EdgeInsets.all(20),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromARGB(255, 2, 84, 100), width: 4)
                            ),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('3. Иформация о росте и весе')
                                ),
                                Container(
                                  height: 125,
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [



                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration( 
                                            hintText: 'высота, см',
                                            border: OutlineInputBorder(),
                                            focusColor: Color.fromARGB(255, 0, 112, 84)
                                          ),
                                          onSaved: (value){
                                            setState(() {
                                              bodyHeight = value;
                                            });
                                          }
                                        )
                                      ),



                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration( 
                                            hintText: 'вес, кг',
                                            border: OutlineInputBorder(),
                                            focusColor: Color.fromARGB(255, 0, 112, 84)
                                          ),
                                          onSaved: (value){
                                            setState(() {
                                              bodyWeight = value;
                                            });
                                          }
                                        )
                                      )



                                    ]
                                  )
                                )



                              ]
                            )
                          )


                        ]
                      )),



                      // submit
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          style: const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 18, horizontal: 20))),
                          onPressed: (){ 
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                            }
                            setResponse();
                            output = getResultWidget();
                          }, 
                          child: const Text('Результат')
                        )
                      )



                    ]
                  )
                )
              ),
              //see results <- response
              output
            ],
          ),
        )
      )
    );
  }
}
