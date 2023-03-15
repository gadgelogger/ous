import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Reference> _folderRefs = [];

  // Define the folder names that should not be displayed
  List<String> _ignoredFolders = ['DL', 'UP','users'];

  @override
  void initState() {
    super.initState();
    _getFolders();
  }

  Future<void> _getFolders() async {
    ListResult result = await _storage.ref().listAll();
    setState(() {
      _folderRefs = result.prefixes.where((ref) => !_ignoredFolders.contains(ref.name)).toList();
    });
  }



  late File _image;

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  Text? _text;

  _myDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text("アップロード完了"),
        content: const Text("アップロードありがとうございます！\nファイルは一週間以内に反映されます。"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          )
        ],
      ),
    );
  }

  void uploadPic() async {
    try {
      /// 画像を選択
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      File file = File(image!.path);

      /// Firebase Cloud Storageにアップロード
      String generateNonce([int length = 32]) {
        const charset =
            '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        final randomStr = List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
        if (mounted) {
          // ←これを追加！！
          setState(() => _text = _myDialog());
        }
        return randomStr;
      }

      String uploadName = generateNonce();
      final storageRef =
      FirebaseStorage.instance.ref().child('UP/$userID/$uploadName');
      final task = await storageRef.putFile(file);
    } catch (e) {
      print(e);
    }
  }

  void uploadcamera() async {
    try {
      /// 画像を選択
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      File file = File(image!.path);

      /// Firebase Cloud Storageにアップロード
      String generateNonce([int length = 32]) {
        const charset =
            '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        final randomStr = List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
        if (mounted) {
          // ←これを追加！！
          setState(() => _text = _myDialog());
        }
        return randomStr;
      }

      String uploadName = generateNonce();
      final storageRef =
      FirebaseStorage.instance.ref().child('UP/$userID/$uploadName');
      final task = await storageRef.putFile(file);
    } catch (e) {
      print(e);
    }
  }

  Future<ListResult> _getFilesInFolder(Reference folderRef) async {
    return await folderRef.listAll();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('過去問まとめ'),
      ),
      body: ListView.builder(
        itemCount: _folderRefs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child:  ListTile(
              leading: Icon(Icons.folder),
              trailing: Icon(Icons.chevron_right),
              title: Text(_folderRefs[index].name),
              onTap: () async {
                ListResult result = await _getFilesInFolder(_folderRefs[index]);
                List<Reference> fileRefs = result.items.where((ref) => !ref.name.endsWith('/')).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FileListScreen(folderRef: _folderRefs[index]),
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
                    margin: EdgeInsets.only(top: 450),
                    decoration: BoxDecoration(
                      //モーダル自体の色
                      color: Theme.of(context).brightness == Brightness.light ?  Colors.white :  Color(
                          0xFF424242),
                      //角丸にする
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: (Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '過去問をアップロード',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          LimitedBox(
                            maxHeight: 200,
                            child: ListView(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.photo_library),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('アルバムから選択'),
                                    onTap: uploadPic,
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.camera),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('写真を撮る'),
                                    onTap: uploadcamera,
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.file_copy_outlined),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('ファイル（PDF,wordなど）'),
                                    onTap: () => launch(
                                        'https://forms.gle/3JZkTzo1t3TuHpTs5'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '投稿ありがとうございます！',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
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

  FileListScreen({required this.folderRef});

  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
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
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text(_folderNames[index]),
                onTap: () async {
                  Reference folderRef = widget.folderRef.child(_folderNames[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FileListScreen(folderRef: folderRef)),
                  );
                },
              ),
            );
          } else {
            // Display file name
            int fileIndex = index - _folderNames.length;
            return Card(
              child: ListTile(
                leading: Icon(Icons.file_copy_outlined),
                trailing: Icon(Icons.chevron_right),
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
                        builder: (context) => ImageViewerScreen(imageRef: fileRef),
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

  ImageViewerScreen({required this.imageRef});

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
                  child: Container(
                      child: Image.network(
                        snapshot.data!,
                        height: double.infinity,
                      )
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}