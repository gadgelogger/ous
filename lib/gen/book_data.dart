import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_data.freezed.dart';
part 'book_data.g.dart';

@freezed
class BookData with _$BookData {
  const factory BookData({
    required String title,
    required String author,
    required String price,
    required String catalogingStatus,
    required String catalogingRule,
    required String managementDescription,
    required String bibRecordCategory,
    required String bibRecordSubCategory,
    required String imageUrl,
    required String isbn,
    required String publishedDate,
    required String extent,
    required List<String> subject,
  }) = _BookData;

  factory BookData.fromJson(Map<String, dynamic> json) =>
      _$BookDataFromJson(json);
}
