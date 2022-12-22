import 'package:flutter/material.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main(){
  runApp(DemoChartApp());
}

class DemoChartApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DemoChartApp();
}

class _DemoChartApp extends State<DemoChartApp> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState(){
    _tooltipBehavior =  TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: 350,
                height: 400,
                child: SfCartesianChart(
                    series: <CartesianSeries>[
                      AreaSeries<ChartData, double>(
                        dataSource: [
                          // Bind data source
                          ChartData(0 ,3),
                          ChartData(1,4.5),
                          ChartData(2,5.5),
                          ChartData(3,6.4),
                          ChartData(4,7),
                          ChartData(5,7.5),
                          ChartData(6,7.9),
                          ChartData(6,8.2),
                          ChartData(8,8.5),
                          ChartData(9,8.9),
                          ChartData(10,9.2),
                          ChartData(11,9.4),
                          ChartData(12,9.6),
                          ChartData(13,9.9),
                          ChartData(14,10.1),
                          ChartData(15,10.3),
                          ChartData(16,10.5),
                          ChartData(17,10.6),
                          ChartData(18,10.9),
                          ChartData(19,11.1),
                          ChartData(20,11.3),
                          ChartData(21,11.5),
                          ChartData(22,11.7),
                          ChartData(23,12),
                          ChartData(24,12.1),
                          ChartData(25,12.3),
                          ChartData(26,12.5),
                          ChartData(27,12.7),
                          ChartData(28,12.9),
                          ChartData(29,13.1),
                          ChartData(30,13.3),
                          ChartData(31,13.5),
                          ChartData(32,13.6),
                          ChartData(33,13.8),
                          ChartData(34,14),
                          ChartData(35,14.1),
                          ChartData(36,14.2),
                        ],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        borderWidth: 2,
                        borderColor:  ColorConstants.map_green_border_color,
                        color: ColorConstants.map_green_color,
                      ),
                      AreaSeries<ChartData, double>(
                        dataSource: [
                          // Bind data source
                          ChartData(0 ,2.5),
                          ChartData(1,3.4),
                          ChartData(2,4.3),
                          ChartData(3,5),
                          ChartData(4,5.5),
                          ChartData(5,6),
                          ChartData(6,6.4),
                          ChartData(6,6.6),
                          ChartData(8,6.9),
                          ChartData(9,7.1),
                          ChartData(10,7.4),
                          ChartData(11,7.5),
                          ChartData(12,7.7),
                          ChartData(13,7.9),
                          ChartData(14,8.1),
                          ChartData(15,8.3),
                          ChartData(16,8.5),
                          ChartData(17,8.6),
                          ChartData(18,8.8),
                          ChartData(19,9),
                          ChartData(20,9.1),
                          ChartData(21,9.3),
                          ChartData(22,9.4),
                          ChartData(23,9.5),
                          ChartData(24,9.6),
                          ChartData(25,9.9),
                          ChartData(26,10),
                          ChartData(27,10.1),
                          ChartData(28,10.3),
                          ChartData(29,10.4),
                          ChartData(30,10.5),
                          ChartData(31,10.6),
                          ChartData(32,10.8),
                          ChartData(33,10.9),
                          ChartData(34,11),
                          ChartData(35,11.2),
                          ChartData(36,11.3),
                        ],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        borderWidth: 2,
                        borderColor: Colors.yellow,
                        color: ColorConstants.map_yellow_color,
                      ),
                      AreaSeries<ChartData, double>(
                        dataSource: [
                          // Bind data source
                          ChartData(0 ,2.1),
                          ChartData(1,3),
                          ChartData(2,3.9),
                          ChartData(3,4.5),
                          ChartData(4,4.9),
                          ChartData(5,5.3),
                          ChartData(6,5.6),
                          ChartData(6,5.7),
                          ChartData(8,6.4),
                          ChartData(9,6.5),
                          ChartData(10,6.7),
                          ChartData(11,6.8),
                          ChartData(12,7),
                          ChartData(13,7.1),
                          ChartData(14,7.2),
                          ChartData(15,7.4),
                          ChartData(16,7.5),
                          ChartData(17,7.6),
                          ChartData(18,7.8),
                          ChartData(19,8),
                          ChartData(20,8.1),
                          ChartData(21,8.2),
                          ChartData(22,8.3),
                          ChartData(23,8.4),
                          ChartData(24,8.6),
                          ChartData(25,8.7),
                          ChartData(26,8.9),
                          ChartData(27,9),
                          ChartData(28,9.1),
                          ChartData(29,9.3),
                          ChartData(30,9.4),
                          ChartData(31,9.5),
                          ChartData(32,9.6),
                          ChartData(33,9.7),
                          ChartData(34,9.8),
                          ChartData(35,9.9),
                          ChartData(36,10),
                        ],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        borderWidth: 2,
                        borderColor: ColorConstants.map_orange_border_color,
                        color: ColorConstants.map_orange_color,
                      ),


                    ]
                )
            ) /*Container(
                width: 400,
                height: 500,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      StackedLineSeries<ResponseChartData, double>(
                          width: 2,
                          color: Colors.black,
                          dataSource: [
                            // Bind data source
                            ResponseChartData(0, 5),
                            ResponseChartData(3, 5),
                            ResponseChartData(5, 5)
                          ],
                          xValueMapper: (ResponseChartData data, _) => data.x,
                          yValueMapper: (ResponseChartData data, _) => data.y
                      ),
                      StackedAreaSeries<ChartData, double>(
                          color: ColorConstants.map_orange_color,
                          borderWidth: 2,
                          borderColor: ColorConstants.map_orange_border_color,
                          groupName: 'Group A',
                          dataLabelSettings: DataLabelSettings(
                              isVisible: false,
                              useSeriesColor: false
                          ),
                          dataSource: [
                            // Bind data source
                            ChartData(0 ,0),
                            ChartData(3, 1),
                            ChartData(3.9,2),
                            ChartData(4.5,3 ),
                            ChartData(4.9,4)
                          ],
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y
                      ),
                      StackedAreaSeries<ChartData, double>(
                          color: ColorConstants.map_yellow_color,
                          opacity: 0.6,
                          borderWidth: 2,
                          borderColor: Colors.yellow,
                          groupName: 'Group B',
                          dataLabelSettings: DataLabelSettings(
                              isVisible: false,
                              useSeriesColor: false
                          ),
                          dataSource: [
                            // Bind data source
                            ChartData(0, 5),
                            ChartData(3, 20),
                            ChartData(5, 30)
                          ],
                         // dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y
                      ),
                      StackedAreaSeries<ChartData, double>(
                          color: ColorConstants.map_green_color,
                          opacity: 0.6,
                          borderWidth: 2,
                          borderColor: Colors.green,
                          groupName: 'Group C',
                          dataLabelSettings: DataLabelSettings(
                              isVisible: false,
                              useSeriesColor: false
                          ),
                          dataSource: [
                            // Bind data source
                            ChartData(0, 10),
                            ChartData(3, 25),
                            ChartData(5, 40)
                          ],
                          //dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y
                      )
                    ]
                )
            )*/
        )
    );
  }

}

class ResponseChartData {
  ResponseChartData(this.x, this.y);
  final double? x;
  final double? y;
}
class ChartData {
  ChartData(this.x, this.y);
  final double? x;
  final double? y;
}