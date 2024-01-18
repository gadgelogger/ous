# 岡理アプリ

非公式岡理アプリのソースコードです。<br>
FlutterとFirebaseを用いて制作した楽な講義を検索できる機能を備えた大学の便利アプリ的なものです。<br>

> **:warning: コードを閲覧する前に**  
> - 中の人はFlutter歴１年でド素人です。インターンにも落ちまくっておりチーム開発の経験がありません。なのでGithubのリポジトリ運用がめちゃくちゃだったりコード規則ガン無視で最高に汚いです。お許しください。（絶賛勉強中です）

## このアプリは何？

### アプリの概要
**動画**
@[tweet](https://twitter.com/i/status/1495295998759153666)

**紹介サイト**
https://ous-unoffical-app.studio.site/

まあ詳しくはここを見てほしい（というか書くのめんどくさい）んやけど、
・大学の便利な情報を掲載（電話番号とかマップとか掲示板とかね）
・楽に単位が取りやすい講義・取りにくい講義を投稿できるSNSのような機能
を搭載している感じやわ。
押したい機能は後者の方やね。
## 制作背景

制作しようと思った理由は２つあって<br>
１つ目（真面目なほう）は
・大学のポータルサイトがうんちク◯UNIPAなので、それに代替になるようなor併用して使ってもらうことが出来るようなアプリを作りたかったから。
​

２つ目は（不真面目なほう）はこれが原因だね。
![](https://storage.googleapis.com/zenn-user-upload/9ac79c057d37-20231203.png)
​
俺「単位落としすぎて草ぁ！。留年しそｗ」
​
​

・まあアホ投稿者が１年の前期に大学をサボりすぎて留年しかけた為、単位を検索出来るようなアプリを作りたかったからやね。（最悪な理由だな）

## 使っている技術

投稿者自信はプログラミング経験は皆無であり<br>
ワイ「プログラミング何もわかんねぇ・・・・・」
ワイ「スマホアプリ作るならSwiftとKotlinってやつがあるんやな。」ぐらいのスキルやね。<br><br>
正直言って、自分には一緒に開発してくれる友達なんか居なかったので、以下の技術を選定したで。

・Flutter（フロントエンド側で使用）<br>
・Firebase（バックエンド側で使用）

なぜこの技術を選んだかと言うと<br>
・とりあえず早くリリースに漕ぎ着きたかったから<br>
やね。
投稿者には一緒に開発してくれる友達もいないので、一人でSwiftとKotlinを学習するには結構キツい&なる早で完成させたかったという理由があってこれにした感じ。

あとクロスプラットフォームの分野で「情報が多そう・積極的にバグ等の修正が行われてそう」な理由から選んだってのもある。


## アピりたい機能

ニュース機能|講義検索機能|詳細画面
--|--|--
![](https://storage.googleapis.com/zenn-user-upload/502703fa5eca-20231203.png)|![](https://storage.googleapis.com/zenn-user-upload/e843f863d007-20231203.png)|![](https://storage.googleapis.com/zenn-user-upload/3ad00f994b2b-20231203.png)

​
アピりまくりたい機能は上の３つやね。<br>
​
## ニュース
![](https://storage.googleapis.com/zenn-user-upload/502703fa5eca-20231203.png)


**開発背景**<br>
とりま最初にどの機能を作ろうか・・・・・と思っていた際に取り掛かったのがこの機能。
Webページからスクレイピングしてくるだけなのですぐに実装できるしそんなに難易度は高くなかった。<br>
​
**使用技術**
主なやつはこれ
https://pub.dev/packages/http
​
**参考にさせてもらった記事**
https://zenn.dev/maguroburger/articles/flutter_scraping
​
## 講義評価投稿機能
このアプリで１番のイキリたい機能はこれ。講義評価投稿。
なぜこれを作ろうかと思った理由が色々あって
​
### 俺が留年しかけたから
まあそりゃそうよな。
​
### 下級生が気軽に情報を得れるようにしたかったから
大学の情報ってどうしても先輩とかに聞かないと得ることが出来なかったりするよね。
そうなると必然的にサークルに入ったり何らかの組織に属さないといけないことが多い。
ただ世の中にはサークルに入りたくない・友達を作るハードルが高い
みたいな人も多いから、そういう人や下級生がこのような情報を得ることができれば良いなと思って作ったのが理由でもあるわ。
​
### そもそも講義の評価って開示すべきじゃね？
これは投稿者の拗れた思想なので申し訳ない
どこの大学にも講義評価アンケートがあると思うんやけど、あれ、他の人にも見れるようにするべきじゃないのか？と思ってしまったんよね。
​
​
### 普通のアプリだと誰も使わないのでインパクトある機能が必要じゃね？
大学のポータルサイトの代替になるようなアプリを作りましたー。。。。。と言っても使ってくれる人は少なさそうな感じがしたのも理由一つであるね。
ワイ「なんか・・・・パンチの聞いた機能入れたいな・・・・・せや！楽単検索できるアプリ需要あるんじゃね？？？？」
と思ったのが始まりやわ。
​
**使用技術**
投稿するためにアカウント機能を用いるので
Firebase Authを使用
データの保管に
FireStoreを使用したわ。
​
**参考にした記事**
まずはFirebase？？？？？？なにそれ？？？？？なレベルだったので
これとか
https://zenn.dev/kazutxt/books/flutter_practice_introduction/viewer/29_chapter4_overview
こんなのとか
https://www.flutter-study.dev/firebase/about-firebase
を参考にしてみたわ

## 作ってみて

## 今後やりたいこと（今後の目標）


