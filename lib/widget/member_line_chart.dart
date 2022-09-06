import 'package:common_utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/model/MemberResp.dart';

// ignore: must_be_immutable
class MemberLineChart extends StatefulWidget {
  final int? _selectTabIndex;
  final int? _selectLabelIndex;
  final MemberResp? _memberResp;

  MemberLineChart(this._memberResp, this._selectTabIndex, this._selectLabelIndex, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemberLineChartState();
}

class _MemberLineChartState extends State<MemberLineChart> {
  int getLength() {
    int length = 0;
    if (widget._selectLabelIndex == 0) {
      length = 7;
    } else if (widget._selectLabelIndex == 1) {
      length = 30;
    } else if (widget._selectLabelIndex == 2) {
      length = 90;
    } else if (widget._selectLabelIndex == 3) {
      length = 180;
    }
    return length;
  }

  List<LineChartBarData> linesBarData() {
    List<double>? dataList;
    switch (widget._selectTabIndex) {
      case 0:
        dataList = widget._memberResp?.newMember?.list;
        break;
      case 1:
        dataList = widget._memberResp?.memberSales?.list;
        break;
      case 2:
        dataList = widget._memberResp?.memberOrder?.list;
        break;
    }

    List<FlSpot> spotList = [];
    int max = getMaxValue();
    if (dataList != null) {
      List<double>? tempList = dataList.sublist(0, getLength()).reversed.toList();
      for (int i = 0; i < tempList.length; i++) {
        spotList.add(FlSpot(i.roundToDouble(), tempList[i] / max * 4 + 1));
      }
    }

    return [
      LineChartBarData(
        spots: spotList,
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0xFFA88AFF),
        ],
        barWidth: 2,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }

  int getMaxFormatter(int index, double? value) {
    int step = 0;
    if (index == 0 || index == 2) {
      step = 20;
    } else {
      step = 100;
    }
    if (value == null) return step;
    int max = value.round();
    int result = max ~/ step;
    max = (result + 1) * step;
    return max;
  }

  int getMaxValue() {
    int max = 0;
    switch (widget._selectTabIndex) {
      case 0:
        max = getMaxFormatter(0, widget._memberResp?.newMember?.max);
        break;
      case 1:
        max = getMaxFormatter(1, widget._memberResp?.memberSales?.max);
        break;
      case 2:
      default:
        max = getMaxFormatter(2, widget._memberResp?.memberOrder?.max);
        break;
    }
    return max;
  }

  LineChartData initLineData() {
    int max = getMaxValue();
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        getDrawingHorizontalLine: (value) {
          return FlLine(strokeWidth: 1.0, color: const Color(0xFFE8F8FF));
        },
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: false,
        ),
        leftTitles: SideTitles(
          showTitles: max > 0,
          getTextStyles: (context, value) => const TextStyle(
            color: HCYYColor.grey_88,
            fontSize: 10.0,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '0';
              case 2:
                return (max ~/ 4).toString();
              case 3:
                return (max ~/ 2).toString();
              case 4:
                return (max ~/ 4 * 3).toString();
              case 5:
                return max.toString();
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: getLength().roundToDouble(),
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      initLineData(),
      swapAnimationDuration: const Duration(milliseconds: 500),
    );
  }
}
