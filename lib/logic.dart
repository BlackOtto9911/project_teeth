import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

List parseData(bool g, double cH, double cW, double bH, double bW, Excel excel) { // gender : true - f, false - m
  String gender = g ? 'ж' : 'м';

  String craniumType = '';
  double ci = cW / cH * 100;
  if (ci < 75.0) {craniumType = 'д';}
  else if (75.0 <= ci && ci < 80.0) {craniumType = 'м';}
  else {craniumType = 'б';}

  String bodyType = '';
  double bmi = bW / bH / bH * 10000;
  if (bmi < 19.0) {bodyType = 'д';}
  else if (19.0 <= bmi && bmi < 25.0) {bodyType = 'н';}
  else {bodyType = 'и';}

  //first block response
  Map enteredData = {'g' : g ? 'F' : 'M', 'ci' : double.parse(ci.toStringAsFixed(2)), 'bmi' : double.parse(bmi.toStringAsFixed(2))};

  //second block response
  Map outputType = {'gender' : gender == 'ж' ? 'пол женский' : 'пол мужской', 
                     'cranium' : craniumType == 'д' ? 'долихоцефалия — относительно длинная и узкая форма головы' : (craniumType == 'м' ? 'мезоцефалия — средние высота и ширина формы головы' : 'брахицефалия — относительно короткая и широкая форма головы'), 
                     'body' : bodyType == 'д' ? 'дефицит массы тела' : (bodyType == 'н' ? 'масса тела в пределах нормы' : 'избыток массы тела')};

  String type = gender + craniumType + bodyType;

  // read .xlsx (old method)
  // var file = Directory.current.path;
  // var bytes = File(file+'/table.xlsx').readAsBytesSync();
  // var excel = Excel.decodeBytes(bytes);

  Sheet currentSheet = excel['short_all_absolute'];
  int rowsNum = currentSheet.maxRows;
  int colsNum = currentSheet.maxCols;
  CellIndex columnIndex1 = CellIndex.indexByString('A1');
  CellIndex columnIndex2 = CellIndex.indexByString('A1');
  for (var i = 1; i < colsNum; i++){
    var cell = currentSheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
    if (cell.value.toString() == type) {
      columnIndex2 = cell.cellIndex;
      break;
    }
  }

  //third block response
  List<Map> result = [];
  //forth block response
  List<double> special = [];

  var max = currentSheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex2.columnIndex, rowIndex: rowsNum-1)).value;
  for (var i = 1; i < rowsNum-1; i++) {
    String key = currentSheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex1.columnIndex, rowIndex: i)).value.toString();
    var value = currentSheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex2.columnIndex, rowIndex: i)).value;
    // print(key);

    if (i > 16) {
      special.add(double.parse((value / max * 100).toStringAsFixed(2)));
    }
    else{
      result.add({key : double.parse((value / max * 100).toStringAsFixed(2))});
    }
  }

  return [enteredData, outputType, result, special];

}