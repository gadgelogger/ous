# 岡理アプリ

非公式岡理アプリのソースコードです。<br>
FlutterとFirebaseを用いて制作した楽な講義を検索できる機能を備えた大学の便利アプリ的なものです。<br>


## このアプリは何？
### 制作背景

https://qiita.com/gadgelogger/items/34c69f554a70e2beadc6

### 技術について（技術をどう使ったのか？）

https://qiita.com/gadgelogger/items/17261a796b7f1d09a50f


## スクリーンショット

#### demo





# 環境
-  IDE:Visual Studio Code 1.86.1
-  Flutter: 3.19.1
-  Dart: 3.3.0
-  サポートするプラットフォーム: iOS/Android

# 使用技術とパッケージ
```
name: ous
description: 岡山理科大学の非公式アプリ
publish_to: 'none' 
version: 2.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.27.0
  url_launcher: ^6.1.10
  http: ^0.13.5
  html: ^0.15.2
  flutter_screenutil: ^5.7.0
  settings_ui: ^2.0.2
  firebase_auth: ^4.17.8
  firebase_storage: ^11.1.0
  image_picker: ^0.8.7+3
  in_app_review: ^2.0.6
  google_sign_in: ^6.1.0
  path: ^1.8.2
  syncfusion_flutter_pdfviewer: ^20.4.54
  flutter_inappwebview: 
    git:
      url: https://github.com/Estrelio/flutter_inappwebview.git
      ref: fix-xcode-17  
  cloud_firestore: ^4.15.8
  shared_preferences: ^2.1.0
  syncfusion_flutter_gauges: ^20.4.54
  package_info_plus: ^3.1.0
  fluttertoast: ^8.2.1
  google_fonts: ^4.0.4
  sign_in_with_apple: ^4.3.0
  flutter_native_splash: ^2.2.0+1
  flutter_overboard: ^3.1.1
  uuid: ^3.0.7
  share: ^2.0.4
  map_launcher: ^2.5.0+1
  rxdart: ^0.27.7
  share_extend: ^2.0.0
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
  flutter_staggered_animations: ^1.1.1
  flutter_speed_dial: ^7.0.0
  carousel_slider: ^4.2.1
  slide_to_act: ^2.0.1
  markdown_widget: ^2.2.0
  dio: ^5.3.3
  xml: ^6.3.0
  firebase_remote_config: ^4.3.3
  firebase_analytics: ^10.7.4
  device_preview: ^1.1.0
  uni_links: ^0.5.1
  flutter_riverpod: ^2.4.10
  cupertino_icons: ^1.0.6
  shimmer: ^3.0.0
  expandable: ^5.0.1
  fl_chart: ^0.66.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  dependency_validator: any
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.8
  custom_lint: ^0.6.2
  riverpod_lint: ^2.3.10
  freezed: ^2.4.7  
  json_serializable: ^6.7.1
  slang_build_runner: ^3.29.0
  pedantic_mono: any
  flutter_gen_runner: ^5.4.0
  import_sorter: ^4.6.0
  flutter_lints: ^2.0.1
  
flutter:
  uses-material-design: true
  assets:
  - assets/images/
  - assets/icon/

flutter_native_splash:
  color: '#ffffff'
  image: 'assets/images/icon.png'
  color_dark: '#202124'
  image_dark: 'assets/icon/icon_dark.png'
  fullscreen: true
  android_12:
    icon_background_color: '#ffffff'
    image: 'assets/icon/icon.png'
    icon_background_color_dark: '#202124'
    image_dark: 'assets/icon/icon_dark.png'

flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon.png"


```



# フォルダ構成
```
├── lib
│   ├── constant
│   │   └── urls.dart
│   ├── controller
│   │   ├── firebase_provider.dart
│   │   └── firebase_provider.g.dart
│   ├── domain
│   │   ├── converters
│   │   ├── post_provider.dart
│   │   ├── review_provider.dart
│   │   ├── share_preferences_instance.dart
│   │   ├── theme_mode_provider.dart
│   │   └── user_providers.dart
│   ├── gen
│   │   ├── assets.gen.dart
│   │   ├── review_data.dart
│   │   ├── review_data.freezed.dart
│   │   ├── review_data.g.dart
│   │   ├── user_data.dart
│   │   ├── user_data.freezed.dart
│   │   └── user_data.g.dart
│   ├── infrastructure
│   │   ├── account_image_uploader_service.dart
│   │   ├── account_name_updater_service.dart
│   │   ├── bus_api.dart
│   │   ├── config
│   │   ├── login_auth_service.dart
│   │   ├── mylog_monitor_api.dart
│   │   ├── setting_service.dart
│   │   ├── tutorial_service.dart
│   │   └── version_check_service.dart
│   ├── main.dart
│   ├── presentation
│   │   ├── pages
│   │   ├── res
│   │   └── widgets
│   └── utils
│       └── extensions

```
# ビルド手順（※メモ）

※APIKeyなどの設定が必要なため現在ビルドできません。

- リポジトリのクローン
```
$ git clone https://github.com/gadgelogger/ous.git
```
- Dartのインストール
```
$ brew tap dart-lang/dart
$ brew install dart
```


- ディレクトリへ移動
```
$ cd ous
```

- 依存関係を読み込む
```
$ flutter pub get
```

- freezedなどのコード生成
```
$ dart run build_runner build -d
```

- ビルドラン
```
$ flutter run
```



# 帰属表示
アプリのアイコンには[Lordicon](https://lordicon.com/)を使用しました。

