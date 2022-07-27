import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class View extends StatefulWidget {
  View(this.doc);

  QueryDocumentSnapshot doc;

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.doc.get('zyugyoumei')),
            Text(
              widget.doc.get('syurui'),
              style: TextStyle(fontSize: 18.sp),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '講師名',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  widget.doc.get('kousimei'),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '単位数',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  widget.doc.get('tannisuu').toString(),
                ),
              ),
              Text(
                '授業形式',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(widget.doc.get('zyugyoukeisiki')),
              ),
              Text(
                '出席確認の有無',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(widget.doc.get('syusseki')),
              ),
              Text(
                '教科書の有無',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(widget.doc.get('kyoukasyo')),
              ),
              Text(
                'テスト形式',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(widget.doc.get('tesutokeisiki')),
              ),
              Divider(),
              Container(
                child: Column(
                  children: [
                    Text(
                      '講義の面白さ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Container(
                      height: 200.h,
                    child: SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                          minimum: 0,
                          maximum: 5,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.2,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color.fromARGB(139, 134, 134, 134),
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: widget.doc
                                  .get('omosirosa' as String)
                                  .toDouble(),
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.2.w,
                              sizeUnit: GaugeSizeUnit.factor,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  widget.doc
                                          .get('omosirosa' as String)
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                      ' / 5',
                                  style: TextStyle(
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.bold),
                                ))
                          ])
                    ])
                    ),
                    Text(
                      '単位の取りやすさ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Container(
                      height: 200.h,
                    child: SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                          minimum: 0,
                          maximum: 5,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.2,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color.fromARGB(139, 134, 134, 134),
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: widget.doc
                                  .get('toriyasusa' as String)
                                  .toDouble(),
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.2.w,
                              sizeUnit: GaugeSizeUnit.factor,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  widget.doc
                                          .get('toriyasusa' as String)
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                      ' / 5',
                                  style: TextStyle(
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.bold),
                                ))
                          ])
                    ]),
                    ),
                    Text(
                      '総合評価',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Container(
                      height: 200.h,
                    child: SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                          minimum: 0,
                          maximum: 5,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.2,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color.fromARGB(139, 134, 134, 134),
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: widget.doc
                                  .get('sougouhyouka' as String)
                                  .toDouble(),
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.2.w,
                              sizeUnit: GaugeSizeUnit.factor,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  widget.doc
                                          .get('sougouhyouka' as String)
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                      ' / 5',
                                  style: TextStyle(
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.bold),
                                ))
                          ])
                    ]),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '講義に関するコメント',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(widget.doc.get('komento'),style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                  ),),
                  Text(
                    'ニックネーム',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 50,
                    ),
                    child: Text(widget.doc.get('name')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
