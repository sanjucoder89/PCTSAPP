import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
 // _MyHomePage({required Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPointIndex = 4;
  late int selectedAxisPointIndex;

  // Globally initialize the selection behavior for the series for using its public methods.
  SelectionBehavior selection = SelectionBehavior(
    enable: true,
    selectedOpacity: 1.0,
    unselectedOpacity: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
          // For storing the selected data point’s index
            onSelectionChanged: (args) {
              if (selectedPointIndex == args.pointIndex) {
                selectedPointIndex = -1;
              } else {
                selectedPointIndex = args.pointIndex;
              }
              setState(() {});
            },
            // Checked for the selected data point’s index and changing the color of the respective axis label
            onDataLabelRender: (args) {
              TextStyle axisLabelStyle = args.textStyle;
              if (args.text == 'primaryXAxis') {
                if (args.pointIndex == selectedPointIndex) {
                  args.textStyle = axisLabelStyle.copyWith(color: Colors.white);
                } else {
                  args.textStyle = axisLabelStyle.copyWith(color: Colors.grey);
                }
              }
            },
            // Axis label tapped event to select the data points using selectDataPoints public method.
            onAxisLabelTapped: (args) {
              if (args.axisName == 'primaryXAxis') {
                selectedAxisPointIndex = args.hashCode;
                selection.selectDataPoints(selectedAxisPointIndex);
              }
            },
            primaryXAxis: CategoryAxis(
                name: 'primaryXAxis',
                // Set the default color for the axis labels
                labelStyle: TextStyle(color: Colors.grey)),
            // Chart title
            title: ChartTitle(text: 'Half yearly sales analysis'),
            series: <ChartSeries<_SalesData, String>>[
              ColumnSeries<_SalesData, String>(
                  initialSelectedDataIndexes: [
                    4,
                  ],
                  dataSource: <_SalesData>[
                    _SalesData('Jan', 35),
                    _SalesData('Feb', 28),
                    _SalesData('Mar', 34),
                    _SalesData('Apr', 32),
                    _SalesData('May', 40),
                    _SalesData('Jun', 0),
                    _SalesData('Jul', 28),
                    _SalesData('Aug', 34),
                    _SalesData('Sep', 0),
                  ],
                  emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.average,
                  ),
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  selectionBehavior: selection)
            ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
