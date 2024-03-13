import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sleep_aid/util/CustomizedUtils.dart';
import 'package:sleep_aid/util/globalVar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReportPage(),
    );
  }
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late TooltipBehavior _tooltipBehavior;
  late DataLabelSettings _dataLabel;
  String TotalTime ="";
  int DSHour = 0;
  int DSMin = 0;
  int LSHour = 0;
  int LSMin = 0;
  int AHour = 0;
  int AMin = 0;

  int index = 0;

  String score = '';

  void initState() {
    _tooltipBehavior = TooltipBehavior(
        //enable: true,
        );

    _dataLabel = const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        connectorLineSettings:
            ConnectorLineSettings(type: ConnectorType.curve, length: '5%'),
        textStyle: TextStyle(fontSize: 15));
    super.initState();

    //monitorConnection(this);
    Timer periodicTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          updateReport();
          print(pieData[0]);
        });
      }
    });

    // 创建一个单次延时定时器，在5秒后取消周期性定时器
    Timer(Duration(seconds: 10), () {
      periodicTimer?.cancel();
    });

  }

  void updateReport() {
    TotalTime = calucateTime();
    pieData[0].yData = DSHour*60 + DSMin;
    pieData[1].yData = LSHour*60 + LSMin;
    pieData[2].yData = AHour*60 + AMin;
    if(pieData[0].yData+pieData[1].yData+pieData[2].yData > 0){
      pieData[0].percentage = pieData[0].yData/(pieData[0].yData+pieData[1].yData+pieData[2].yData);
      pieData[1].percentage = pieData[1].yData/(pieData[0].yData+pieData[1].yData+pieData[2].yData);
      pieData[2].percentage = pieData[2].yData/(pieData[0].yData+pieData[1].yData+pieData[2].yData);
    }
    else{
      pieData[0].percentage = 0;
      pieData[1].percentage = 0;
      pieData[2].percentage = 0;

    }
    score = report[7];
  }

  String calucateTime(){
    String str = "";
    DSHour =int.parse(report[1]);
    DSMin =int.parse(report[2]);
    LSHour =int.parse(report[3]);
    LSMin =int.parse(report[4]);
    AHour =int.parse(report[5]);
    AMin =int.parse(report[6]);

    int hour = DSHour + LSHour +AHour;
    int minute = DSMin + LSMin + AMin;
    hour += minute~/60;
    minute %= 60;
    str = '${hour.toStringAsFixed(0)}:${minute.toStringAsFixed(0)}';
    return str;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            int popCount = 0;
            isReport = false;
            Navigator.pop(context);
          },
        ),
        title: Text('REPORT'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          mySpace(50),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child:CustomizedText('Total Time: ${TotalTime}', font_color: Colors.black),
          ),
          mySpace(10),
          SfCircularChart(
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Container(
                  child: Text('${pieData[index].xData}',
                      style: TextStyle(
                          //color: Color.fromRGBO(216, 225, 227, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),),
                ),
              )
            ],
            tooltipBehavior: _tooltipBehavior,
            series: <CircularSeries<PieData, String>>[
              // Renders pie chart
              DoughnutSeries<PieData, String>(
                dataSource: pieData,
                xValueMapper: (PieData data, _) => data.xData,
                yValueMapper: (PieData data, _) => data.yData,
                pointColorMapper: (PieData data, _) => data.text,
                explode: true,
                explodeIndex: index,
                enableTooltip: true,
                radius: '80%',
                dataLabelMapper: (PieData data, _) => '${data.percentage}%',
                dataLabelSettings: _dataLabel,
                onPointTap: (ChartPointDetails details) {
                  index = details.pointIndex!;
                  setState(() {});
                },
              )
            ],
          ),
          mySpace(10),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child:CustomizedText('Average Breath rate: ${report[0]}', font_color: Colors.black),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child:CustomizedText('Score: $score', font_color: Colors.black),
          ),
        ]),
      ),
    );
  }
}
