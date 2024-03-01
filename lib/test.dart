// Dart imports:
import 'dart:math';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Reference> _folderRefs = [];

  // Define the folder names that should not be displayed
  final List<String> _ignoredFolders = ['DL', 'UP', 'users'];

  @override
  void initState() {
    super.initState();
    _getFolders();
  }

  Future<void> _getFolders() async {
    ListResult result = await _storage.ref().listAll();
    setState(() {
      _folderRefs = result.prefixes
          .where((ref) => !_ignoredFolders.contains(ref.name))
          .toList();
    });
  }

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  void uploadPic() async {
    try {
      /// 画像を選択

      /// Firebase Cloud Storageにアップロード
      String generateNonce([int length = 32]) {
        const charset =
            '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        final randomStr = List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
        if (mounted) {
          // ←これを追加！！
        }
        return randomStr;
      }

      String uploadName = generateNonce();
      FirebaseStorage.instance.ref().child('UP/$userID/$uploadName');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void uploadcamera() async {
    try {
      /// 画像を選択

      /// Firebase Cloud Storageにアップロード
      String generateNonce([int length = 32]) {
        const charset =
            '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        final randomStr = List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
        if (mounted) {
          // ←これを追加！！
        }
        return randomStr;
      }

      String uploadName = generateNonce();
      FirebaseStorage.instance.ref().child('UP/$userID/$uploadName');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<ListResult> _getFilesInFolder(Reference folderRef) async {
    return await folderRef.listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('過去問まとめ'),
      ),
      body: ListView.builder(
        itemCount: _folderRefs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.folder),
              trailing: const Icon(Icons.chevron_right),
              title: Text(_folderRefs[index].name),
              onTap: () async {
                ListResult result = await _getFilesInFolder(_folderRefs[index]);
                result.items.where((ref) => !ref.name.endsWith('/')).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FileListScreen(folderRef: _folderRefs[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              //モーダルの背景の色、透過
              backgroundColor: Colors.transparent,
              //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                    margin: const EdgeInsets.only(top: 450),
                    decoration: BoxDecoration(
                      //モーダル自体の色
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : const Color(0xFF424242),
                      //角丸にする
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: (Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '過去問をアップロード',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          LimitedBox(
                            maxHeight: 200,
                            child: ListView(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    trailing: const Icon(Icons.chevron_right),
                                    title: const Text('アルバムから選択'),
                                    onTap: uploadPic,
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.camera),
                                    trailing: const Icon(Icons.chevron_right),
                                    title: const Text('写真を撮る'),
                                    onTap: uploadcamera,
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading:
                                        const Icon(Icons.file_copy_outlined),
                                    trailing: const Icon(Icons.chevron_right),
                                    title: const Text('ファイル（PDF,wordなど）'),
                                    onTap: () => launchUrlString(
                                        'https://forms.gle/3JZkTzo1t3TuHpTs5'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '投稿ありがとうございます！',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                        ],
                      )),
                    ));
              });
        },
        child: const Icon(Icons.upload_rounded),
      ),
    );
  }
}

class FileListScreen extends StatefulWidget {
  final Reference folderRef;

  const FileListScreen({Key? key, required this.folderRef}) : super(key: key);

  @override
  FileListScreenState createState() => FileListScreenState();
}

class FileListScreenState extends State<FileListScreen> {
  List<Reference> _fileRefs = [];
  List<String> _folderNames = [];
  List<String> _fileNames = [];

  @override
  void initState() {
    super.initState();
    _getFilesAndFolders();
  }

  Future<void> _getFilesAndFolders() async {
    ListResult result = await widget.folderRef.listAll();
    setState(() {
      _fileRefs = result.items.where((ref) => !ref.name.endsWith('/')).toList();
      _folderNames = result.prefixes.map((ref) => ref.name).toList();
      _fileNames = _fileRefs.map((ref) => ref.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderRef.name),
      ),
      body: ListView.builder(
        itemCount: _folderNames.length + _fileNames.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < _folderNames.length) {
            // Display folder name
            return Card(
              child: ListTile(
                leading: const Icon(Icons.folder),
                trailing: const Icon(Icons.chevron_right),
                title: Text(_folderNames[index]),
                onTap: () async {
                  Reference folderRef =
                      widget.folderRef.child(_folderNames[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FileListScreen(folderRef: folderRef)),
                  );
                },
              ),
            );
          } else {
            // Display file name
            int fileIndex = index - _folderNames.length;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.file_copy_outlined),
                trailing: const Icon(Icons.chevron_right),
                title: Text(_fileNames[fileIndex]),
                onTap: () async {
                  Reference fileRef = _fileRefs[fileIndex];
                  String fileExtension = fileRef.name.split('.').last;
                  if (fileExtension.toLowerCase() == 'pdf') {
                    // Display PDF file
                    String url = await fileRef.getDownloadURL();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: Text(fileRef.name)),
                          body: SfPdfViewer.network(url),
                        ),
                      ),
                    );
                  } else {
                    // Display the image
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageViewerScreen(imageRef: fileRef),
                      ),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final Reference imageRef;

  const ImageViewerScreen({Key? key, required this.imageRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(imageRef.name)),
      body: FutureBuilder(
        future: imageRef.getDownloadURL(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 5,
              child: Image.network(
                snapshot.data!,
                height: double.infinity,
              ),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
