import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ous/apikey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:uuid/uuid.dart';

class DevInfo extends StatefulWidget {
  const DevInfo({Key? key}) : super(key: key);

  @override
  State<DevInfo> createState() => _DevInfoState();
}

class _DevInfoState extends State<DevInfo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //大学のアカウント以外は非表示にする
  late FirebaseAuth auth;
  bool showFloatingActionButton = false;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null &&
        user.email != null &&
        (user.email == dev_email || user.email == dev_email2)) {
      showFloatingActionButton = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1)); // 1秒待機
          initState();
        },
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('dev_info')
              .orderBy('day', descending: true)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('何もありません'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        data['title'],
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      subtitle: Text(
                        DateFormat('yyyy/MM/dd').format(data['day'].toDate()),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPost(
                              text: data['text'],
                              day: data['day'],
                              title: data['title'],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: showFloatingActionButton
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevPost(),
                  ),
                );
              },
              child: const Icon(Icons.post_add),
            )
          : null,
    );
  }
}

class ViewPost extends StatefulWidget {
  final text;
  final day;
  final title;
  const ViewPost(
      {Key? key, required this.text, required this.day, required this.title})
      : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('開発者からのお知らせ'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                textAlign: TextAlign.left,
              ),
              Text(
                DateFormat('yyyy/MM/dd').format(widget.day.toDate()),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 600.h,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MarkdownWidget(
                        data: widget.text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class DevPost extends StatefulWidget {
  const DevPost({Key? key}) : super(key: key);

  @override
  State<DevPost> createState() => _DevPostState();
}

class _DevPostState extends State<DevPost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();

  Future<void> _addPost() async {
    try {
      await FirebaseFirestore.instance.collection('dev_info').add({
        'title': _titleController.text,
        'text': _textController.text,
        'day': _selectedDate,
        'uuid': const Uuid().v4(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投稿しました')),
      );
      _titleController.clear();
      _textController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投稿に失敗しました')),
      );
    }
  }

  Future<void> _deletePost(String id) async {
    try {
      await FirebaseFirestore.instance.collection('dev_info').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投稿を削除しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投稿の削除に失敗しました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿管理画面'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                    child: Text(
                  'この画面は開発者のアカウントでのみ表示されます。\nThis screen is only visible for developer accounts.',
                  textAlign: TextAlign.center,
                )),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'タイトルを入力してください';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: '本文',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '本文を入力してください';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _addPost();
                    }
                  },
                  child: const Text('投稿する'),
                ),
                const Divider(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('dev_info')
                      .orderBy('day', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _deletePost(data.id);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      data['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat('yyyy/MM/dd')
                                          .format(data['day'].toDate()),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewPost(
                                            text: data['text'],
                                            day: data['day'],
                                            title: data['title'],
                                          ),
                                        ),
                                      );
                                    },
                                    leading: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditPost(
                                              text: data['text'],
                                              id: data['uuid'],
                                              title: data['title'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditPost extends StatefulWidget {
  final String? id;
  final String? title;
  final String? text;

  const EditPost({Key? key, this.id, this.title, this.text}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _text;

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
    _text = widget.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿編集'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    hintText: 'タイトル',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'タイトルを入力してください';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _title = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _text,
                  decoration: const InputDecoration(
                    hintText: '本文',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '本文を入力してください';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _text = value;
                  },
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final snapshot = await FirebaseFirestore.instance
                          .collection('dev_info')
                          .where('uuid', isEqualTo: widget.id)
                          .limit(1)
                          .get();
                      if (snapshot.docs.isNotEmpty) {
                        final doc = snapshot.docs.first;
                        await doc.reference.update({
                          'title': _title,
                          'text': _text,
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('更新する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
