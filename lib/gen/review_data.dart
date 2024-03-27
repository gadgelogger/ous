import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ous/domain/converters/date_time_timestamp_converter.dart';

part 'review_data.freezed.dart';
part 'review_data.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String? id,
    required String? accountemail,
    required String? accountname,
    required String? accountuid,
    required String? bumon,
    @DateTimeTimestampConverter() required DateTime? date,
    required String? gakki,
    required String? komento,
    required String? kousimei,
    required String? kyoukasyo,
    required String? name,
    required String? nenndo,
    required dynamic omosirosa,
    required String? senden,
    required dynamic sougouhyouka,
    required String? syusseki,
    required dynamic tannisuu,
    required String? tesutokeikou,
    required String? tesutokeisiki,
    required dynamic toriyasusa,
    required String? zyugyoukeisiki,
    required String? zyugyoumei,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
