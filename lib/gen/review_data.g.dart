// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      ID: json['ID'] as String?,
      accountemail: json['accountemail'] as String?,
      accountname: json['accountname'] as String?,
      accountuid: json['accountuid'] as String?,
      bumon: json['bumon'] as String?,
      date: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['date'], const DateTimeTimestampConverter().fromJson),
      gakki: json['gakki'] as String?,
      komento: json['komento'] as String?,
      kousimei: json['kousimei'] as String?,
      kyoukasyo: json['kyoukasyo'] as String?,
      name: json['name'] as String?,
      nenndo: json['nenndo'] as String?,
      omosirosa: json['omosirosa'],
      senden: json['senden'] as String?,
      sougouhyouka: json['sougouhyouka'],
      syusseki: json['syusseki'] as String?,
      tannisuu: json['tannisuu'],
      tesutokeikou: json['tesutokeikou'] as String?,
      tesutokeisiki: json['tesutokeisiki'] as String?,
      toriyasusa: json['toriyasusa'],
      zyugyoukeisiki: json['zyugyoukeisiki'] as String?,
      zyugyoumei: json['zyugyoumei'] as String?,
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'accountemail': instance.accountemail,
      'accountname': instance.accountname,
      'accountuid': instance.accountuid,
      'bumon': instance.bumon,
      'date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.date, const DateTimeTimestampConverter().toJson),
      'gakki': instance.gakki,
      'komento': instance.komento,
      'kousimei': instance.kousimei,
      'kyoukasyo': instance.kyoukasyo,
      'name': instance.name,
      'nenndo': instance.nenndo,
      'omosirosa': instance.omosirosa,
      'senden': instance.senden,
      'sougouhyouka': instance.sougouhyouka,
      'syusseki': instance.syusseki,
      'tannisuu': instance.tannisuu,
      'tesutokeikou': instance.tesutokeikou,
      'tesutokeisiki': instance.tesutokeisiki,
      'toriyasusa': instance.toriyasusa,
      'zyugyoukeisiki': instance.zyugyoukeisiki,
      'zyugyoumei': instance.zyugyoumei,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
