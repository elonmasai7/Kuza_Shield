import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/threat_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  String _getRiskLevel(double avgConfidence) {
    if (avgConfidence > 0.7) return 'High Risk';
    if (avgConfidence > 0.4) return 'Medium Risk';
    return 'Low Risk';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThreatProvider>(
      builder: (context, provider, child) {
        final threats = provider.threats;
        if (threats.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Threat Analytics')),
            body: Center(child: Text('No threats detected yet. Perform scans to see analytics.')),
          );
        }

        // Calculate metrics
        int threatCount = threats.where((t) => t.isPhishing).length;
        int safeCount = threats.length - threatCount;
        double avgConfidence = threats.fold(0.0, (sum, t) => sum + t.confidence) / threats.length;
        String riskLevel = _getRiskLevel(avgConfidence);

        // Prepare chart data (confidence over time)
        List<FlSpot> spots = threats.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.confidence);
        }).toList();

        return Scaffold(
          appBar: AppBar(title: Text('Advanced Threat Analytics')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Threat Summary', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 8),
                Text('Total Scans: ${threats.length}'),
                Text('Detected Threats: $threatCount'),
                Text('Safe Items: $safeCount'),
                Text('Average Confidence: ${avgConfidence.toStringAsFixed(2)}'),
                Text('Predicted Risk Level: $riskLevel', style: TextStyle(color: riskLevel == 'High Risk' ? Colors.red : Colors.green)),
                SizedBox(height: 24),
                Text('Confidence Trend Over Scans', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      minX: 0,
                      maxX: threats.length - 1.toDouble(),
                      minY: 0,
                      maxY: 1,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text('Recent Threats', style: Theme.of(context).textTheme.headlineMedium),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: threats.length > 5 ? 5 : threats.length,
                  itemBuilder: (context, index) {
                    final threat = threats[index];
                    return ListTile(
                      title: Text(threat.isPhishing ? 'Threat' : 'Safe'),
                      subtitle: Text('Confidence: ${threat.confidence}, Time: ${threat.timestamp}'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}