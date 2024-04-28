import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ous/gen/book_data.dart';
import 'package:ous/presentation/pages/review/book/book_detail_page.dart';
import 'package:xml/xml.dart';

class BookScanView extends StatefulWidget {
  const BookScanView({Key? key}) : super(key: key);

  @override
  State<BookScanView> createState() => _BookScanViewState();
}

class _BookScanViewState extends State<BookScanView> {
  final _scannerController = MobileScannerController();
  String scannedValue = '';
  BookData? bookData;

  Future<void> fetchBookInfo(String isbn) async {
    final dio = Dio();
    final url =
        'https://iss.ndl.go.jp/api/sru?operation=searchRetrieve&version=1.2&recordSchema=dcndl&onlyBib=true&recordPacking=xml&query=isbn="$isbn"%20AND%20dpid=iss-ndl-opac';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);

        final publishedDate = document
            .findAllElements('dcterms:date')
            .map((node) => node.text)
            .firstWhere((date) => date.isNotEmpty, orElse: () => '');

        final extent = document
            .findAllElements('dcterms:extent')
            .map((node) => node.text)
            .join(', ');

        final subject = document
            .findAllElements('dcterms:subject')
            .map((node) => node.text)
            .toList();

        final bookModel = BookData(
          title: document
              .findAllElements('dcterms:title')
              .map((node) => node.text)
              .join(', '),
          author: document
              .findAllElements('dc:creator')
              .map((node) => node.text)
              .join(', '),
          price: document
              .findAllElements('dcndl:price')
              .map((node) => node.text)
              .join(', '),
          catalogingStatus: document
              .findAllElements('dcndl:catalogingStatus')
              .map((node) => node.text)
              .join(', '),
          catalogingRule: document
              .findAllElements('dcndl:catalogingRule')
              .map((node) => node.text)
              .join(', '),
          managementDescription: document
              .findAllElements('dcterms:description')
              .where(
                (element) =>
                    element.parentElement?.name.local == 'BibAdminResource',
              )
              .map((node) => node.text)
              .join(', '),
          bibRecordCategory: document
              .findAllElements('dcndl:bibRecordCategory')
              .map((node) => node.text)
              .join(', '),
          bibRecordSubCategory: document
              .findAllElements('dcndl:bibRecordSubCategory')
              .map((node) => node.text)
              .join(', '),
          imageUrl: document
              .findAllElements('dcndl:digitalResource')
              .map(
                (node) => node
                    .findElements('dcterms:identifier')
                    .firstWhere(
                      (element) => element.text.startsWith('http'),
                      orElse: () => XmlElement(XmlName('dcterms:identifier')),
                    )
                    .text,
              )
              .firstWhere(
                (url) => url.isNotEmpty,
                orElse: () => '',
              ),
          isbn: isbn,
          publishedDate: publishedDate,
          extent: extent,
          subject: subject,
        );

        setState(() {
          bookData = bookModel;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(bookData: bookModel),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バーコードで検索'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const scanArea = Rect.fromLTRB(
                    168,
                    228,
                    -168,
                    -228,
                  );

                  return MobileScanner(
                    overlay: const ScannerFrame(scanArea: scanArea),
                    controller: _scannerController,
                    onDetect: (capture) {
                      final List<Barcode> barcode = capture.barcodes;
                      final value = barcode[0].rawValue;
                      if (value != null) {
                        setState(() {
                          scannedValue = value;
                        });
                        debugPrint(value);
                        fetchBookInfo(value);
                      }
                    },
                  );
                },
              ),
            ),
            BarcodeScanHintCard(
              onManualInput: () {
                // 手動入力ダイアログを表示する処理を追加
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerFrame extends StatelessWidget {
  const ScannerFrame({
    Key? key,
    required this.scanArea,
  }) : super(key: key);

  final Rect scanArea;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScannerFramePainter(scanArea: scanArea),
    );
  }
}

class ScannerFramePainter extends CustomPainter {
  ScannerFramePainter({required this.scanArea});

  final Rect scanArea;

  @override
  void paint(Canvas canvas, Size size) {
    const frameThickness = 30.0;
    const lineThickness = 4.0;

    // 内側の長方形
    canvas.drawRect(
      scanArea.deflate(frameThickness / 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = frameThickness
        ..color = Colors.green,
    );

    // 中心の赤い横線
    final lineY = scanArea.center.dy;
    canvas.drawLine(
      Offset(scanArea.left, lineY),
      Offset(scanArea.right, lineY),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineThickness
        ..color = Colors.red,
    );

    // 背景の半透明の黒色
    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRect(scanArea)
        ..fillType = PathFillType.evenOdd,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black54,
    );
  }

  @override
  bool shouldRepaint(ScannerFramePainter oldPainter) {
    return scanArea != oldPainter.scanArea;
  }
}

class BarcodeScanHintCard extends StatelessWidget {
  const BarcodeScanHintCard({
    Key? key,
    required this.onManualInput,
  }) : super(key: key);

  final VoidCallback onManualInput;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '本の裏側にある"9784"から始まる\nバーコードをスキャンしてください',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // バーコードスキャンの画像を追加
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      'バーコードが読み取れない場合は、下のボタンから手動で入力できます',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onManualInput,
                      child: const Text('バーコードを手動で入力する'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
