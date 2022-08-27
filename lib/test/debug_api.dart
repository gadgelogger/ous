import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  final Reference ref;
  final String url;
  final String name;

  FirebaseFile({
    required this.ref,
    required this.url,
    required this.name,
  });

  @override
  String toString() {
    return 'file "$name"';
  }
}

class DownloadFirebaseApi {
  /// Transform the items (the files) contained in the [result] (a folder).
  /// The items are transformed into a list of [FirebaseFile] objects.
  static Future<List<FirebaseFile>> _getFilesFrom(ListResult result) async {
    List<String> urls = await _getDownloadLinks(result.items);
    return urls
        .asMap()
        .map((index, url) {
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(name: name, url: url, ref: ref);
      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  /// Explores all the nested directories and
  /// returns a list of all the files as [FirebaseFile] objects.
  static Future<List<FirebaseFile>> _exploreDirectories(
      ListResult result,
      ) async {
    List<FirebaseFile> files = [];
    if (result.prefixes.isEmpty) {
      if (result.items.isEmpty) {
        return [];
      } else {
        return await _getFilesFrom(result);
      }
    } else {
      for (Reference prefix in result.prefixes) {
        ListResult nestedResult = await prefix.listAll();
        if (nestedResult.items.isNotEmpty) {
          files.addAll(await _getFilesFrom(nestedResult));
        }
        if (nestedResult.prefixes.isNotEmpty) {
          files.addAll(await _exploreDirectories(nestedResult));
        }
      }
    }
    return files;
  }

  /// Returns a list of all the files as [FirebaseFile] objects.
  static Future<List<FirebaseFile>> listAll(String s) async {
    final ref = FirebaseStorage.instance.ref();
    List<FirebaseFile> files = [];
    ListResult result = await ref.listAll();
    if (result.prefixes.isNotEmpty) {
      files = await _exploreDirectories(result);
    } else if (result.items.isNotEmpty) {
      files = await _getFilesFrom(result);
    } else {
      return [];
    }

    return files;
  }

  /// Gets the download URL of every file with their [refs].
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) async {
    return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  }
}