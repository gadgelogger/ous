import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ShareGaugeSection extends StatelessWidget {
  final String title;
  final double value;

  const ShareGaugeSection({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 100,
          width: 100,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 5,
                showLabels: false,
                showTicks: false,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.2,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Color.fromARGB(139, 134, 134, 134),
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: value,
                    cornerStyle: CornerStyle.bothCurve,
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.2,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    positionFactor: 0.1,
                    angle: 90,
                    widget: Text(
                      '${value.toStringAsFixed(0)} / 5',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
