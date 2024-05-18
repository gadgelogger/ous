// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailButtons extends StatelessWidget {
  const DetailButtons({
    super.key,
    required this.bookData,
  });
  final String bookData;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.shop),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      launchUrlString(
                        'https://www.amazon.co.jp/s?k=$bookData&__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&crid=2G0Y4FXZVZ5I&sprefix=test%2Caps%2C199&ref=nb_sb_noss_1',
                      );
                    },
                  ),
                  const Text('Amazon'),
                ],
              ),
              Column(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.shop),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      launchUrlString(
                        'https://books.rakuten.co.jp/search?sitem=$bookData&g=000&l-id=pc-search-box',
                      );
                    },
                  ),
                  const Text('楽天ブックス'),
                ],
              ),
              Column(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.shop),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 300.h,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Text(
                                    '教科書を今すぐ書いたい人はこちらへお問い合わせください。',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    '※勝手に掲載しています。お店側は本アプリとは一切関係ありません',
                                    textAlign: TextAlign.center,
                                  ),
                                  ListTile(
                                    title: const Text('お店の概要を見る'),
                                    leading: const Icon(Icons.web),
                                    onTap: () {
                                      launchUrlString(
                                        'https://g.co/kgs/vn5xjc3',
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('お店へ電話する'),
                                    leading: const Icon(Icons.phone),
                                    onTap: () {
                                      launchUrlString('tel:0862834516	');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('お店への行き方を調べる'),
                                    leading: const Icon(Icons.map),
                                    onTap: () {
                                      launchUrlString(
                                        'https://www.google.com/maps/dir//%E3%81%BB%E3%82%93%E3%82%84%E3%81%95%E3%82%93%E3%80%80%E5%B2%A1%E5%B1%B1%E5%A4%A7%E5%AD%A6/data=!4m6!4m5!1m1!4e2!1m2!1m1!1s0x3554066a2ce3d6b7:0x5042bf4f153aff5b?sa=X&ved=1t:3061&ictx=111',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Text('ほんやさん'),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 28, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.shop),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      launchUrlString(
                        'https://www.mercari.com/jp/search/?keyword=$bookData',
                      );
                    },
                  ),
                  const Text('メルカリ'),
                ],
              ),
              Column(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.shop),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      launchUrlString(
                        'https://auctions.yahoo.co.jp/search/search?p=$bookData',
                      );
                    },
                  ),
                  const Text('Yahoo!フリマ'),
                ],
              ),
              Column(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.shop),
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      launchUrlString(
                        'https://fril.jp/s?query=$bookData',
                      );
                    },
                  ),
                  const Text('ラクマ'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
