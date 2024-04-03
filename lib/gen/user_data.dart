//ユーザーデータのモデル

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
// Project imports:
import 'package:ous/domain/converters/date_time_timestamp_converter.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String displayName,
    required String email,
    required String uid,
    String? photoURL,
    @Default(0) int reviewCount,
    @DateTimeTimestampConverter() required DateTime createdAt,
    @DateTimeTimestampConverter() required DateTime updatedAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
