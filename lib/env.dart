import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_ANON', obfuscate: true)
  static final String supabaseAnon = _Env.supabaseAnon;

  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'TESTAD_BANNER_ID_ANDROID', obfuscate: true)
  static final String testAdBannerIdAndroid = _Env.testAdBannerIdAndroid;

  @EnviedField(varName: 'TESTAD_BANNER_ID_IOS', obfuscate: true)
  static final String testAdBannerIdIos = _Env.testAdBannerIdIos;

  @EnviedField(varName: 'AD_BANNER_ID_ANDROID', obfuscate: true)
  static final String adBannerIdAndroid = _Env.adBannerIdAndroid;

  @EnviedField(varName: 'AD_BANNER_ID_IOS', obfuscate: true)
  static final String adBannerIdIos = _Env.adBannerIdIos;

  @EnviedField(varName: 'AD_BANNER_REVIEW_BOTTOM_ID_ANDROID', obfuscate: true)
  static final String adBannerReviewBottomIdAndroid =
      _Env.adBannerReviewBottomIdAndroid;

  @EnviedField(varName: 'AD_BANNER_REVIEW_BOTTOM_ID_IOS', obfuscate: true)
  static final String adBannerReviewBottomIdIos =
      _Env.adBannerReviewBottomIdIos;

  @EnviedField(varName: 'AD_INTER_REVIEW_ID_ANDROID', obfuscate: true)
  static final String adInterReviewIdAndroid = _Env.adInterReviewIdAndroid;

  @EnviedField(varName: 'AD_INTER_REVIEW_ID_IOS', obfuscate: true)
  static final String adInterReviewIdIos = _Env.adInterReviewIdIos;

  @EnviedField(varName: 'AD_REWARDINTER_REVIEW_ID_ANDROID', obfuscate: true)
  static final String adRewardInterReviewIdAndroid =
      _Env.adRewardInterReviewIdAndroid;

  @EnviedField(varName: 'AD_REWARDINTER_REVIEW_ID_IOS', obfuscate: true)
  static final String adRewardInterReviewIdIos = _Env.adRewardInterReviewIdIos;

  @EnviedField(varName: 'AD_REVIEWLIST_ID_ANDROID', obfuscate: true)
  static final String adReviewListIdAndroid = _Env.adReviewListIdAndroid;

  @EnviedField(varName: 'AD_REVIEWLIST_ID_IOS', obfuscate: true)
  static final String adReviewListIdIos = _Env.adReviewListIdIos;
  // Start Generation Here
  @EnviedField(varName: 'AD_NEWSPAGE_ID_ANDROID', obfuscate: true)
  static final String adNewspageIdAndroid = _Env.adNewspageIdAndroid;

  @EnviedField(varName: 'AD_NEWSPAGE_ID_IOS', obfuscate: true)
  static final String adNewspageIdIos = _Env.adNewspageIdIos;
  @EnviedField(varName: 'REVENUECAT_ANDROID', obfuscate: true)
  static final String revenuecatAndroid = _Env.revenuecatAndroid;

  @EnviedField(varName: 'REVENUECAT_IOS', obfuscate: true)
  static final String revenuecatIos = _Env.revenuecatIos;
}
