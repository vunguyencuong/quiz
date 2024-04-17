import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';



@RoutePage()
class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  String qrData = 'This is a sample QR code data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quizz'),
      ),
      body: Container(
        color: Colors.white, // Màu nền của màn hình
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút import file JSON 1
              },
              child: const Text('Import File JSON 1'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút import file JSON 2
              },
              child: const Text('Import File JSON 2'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút import file JSON 3
              },
              child: const Text('Import File JSON 3'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút Submit
                setState(() {
                  qrData = 'Dữ liệu của bạn';
                });
                // Hiển thị dialog chứa hình ảnh mã QR
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('QR Code'),
                      content: QrImageView(
                        data: qrData,
                        version: 1,
                        size: 200.0,
                        gapless: false,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Đóng'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}