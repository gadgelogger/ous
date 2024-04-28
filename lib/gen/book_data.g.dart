// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookDataImpl _$$BookDataImplFromJson(Map<String, dynamic> json) =>
    _$BookDataImpl(
      title: json['title'] as String,
      author: json['author'] as String,
      price: json['price'] as String,
      catalogingStatus: json['catalogingStatus'] as String,
      catalogingRule: json['catalogingRule'] as String,
      managementDescription: json['managementDescription'] as String,
      bibRecordCategory: json['bibRecordCategory'] as String,
      bibRecordSubCategory: json['bibRecordSubCategory'] as String,
      imageUrl: json['imageUrl'] as String,
      isbn: json['isbn'] as String,
      publishedDate: json['publishedDate'] as String,
      extent: json['extent'] as String,
      subject:
          (json['subject'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$BookDataImplToJson(_$BookDataImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'price': instance.price,
      'catalogingStatus': instance.catalogingStatus,
      'catalogingRule': instance.catalogingRule,
      'managementDescription': instance.managementDescription,
      'bibRecordCategory': instance.bibRecordCategory,
      'bibRecordSubCategory': instance.bibRecordSubCategory,
      'imageUrl': instance.imageUrl,
      'isbn': instance.isbn,
      'publishedDate': instance.publishedDate,
      'extent': instance.extent,
      'subject': instance.subject,
    };
