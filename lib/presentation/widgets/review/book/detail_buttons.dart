// Flutter imports:
import 'package:flutter/material.dart';
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
                    onPressed: () {},
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
