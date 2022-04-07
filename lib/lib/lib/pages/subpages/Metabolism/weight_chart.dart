import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:weaversmvp/models/user.dart';

class ChartWeight{
  int? numberOfWeeks;
  int? weight;
  ChartWeight(this.numberOfWeeks, this.weight);

}

class WeightChart extends StatefulWidget{

  final List<chart.Series<ChartWeight, num>> weightList;
  final bool animate;

  WeightChart(this.animate, this.weightList);

  factory WeightChart.startWithData({bool animate = true, required List<Weight>? weightList}){

    List<ChartWeight> weightCharts = [];
    for(int v =0; v <(weightList?.length ?? 0); v++){
      weightCharts.add(ChartWeight(v, weightList?[v].weightValue));
    }

    weightCharts.sort((a, b) => a.weight!.compareTo(b.weight!));

    final list =  chart.Series<ChartWeight, num>(
      id: 'Weights',
      colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
      domainFn: (ChartWeight weight, _) => num.parse(weight.numberOfWeeks.toString()),
      measureFn: (ChartWeight weight, _) => weight.weight,
      data: weightCharts);

    return WeightChart(animate, [list]);
  }

  @override
  _WeightChartState createState() {
    return _WeightChartState();
  }


  /*
  ((MIN VALUE ON WEIGHT LIST) - 5) TO ((MAX VALUE ON WEIGHT LIST) + 5)
   */
}

class _WeightChartState extends State<WeightChart>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: 200,
        child:  chart.LineChart( widget.weightList, animate: widget.animate,
          primaryMeasureAxis: const chart.NumericAxisSpec(
            tickProviderSpec:
            chart.BasicNumericTickProviderSpec(zeroBound: false),
          ),
        ),
      ),
    );
  }

  
}
