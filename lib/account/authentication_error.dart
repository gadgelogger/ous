// Firebase Authentication利用時の日本語エラーメッセージ
class Authentication_error_to_ja {
  // ログイン時の日本語エラーメッセージ
  login_error_msg(int errorCode, String orgErrorMsg) {
    String errorMsg;

    if (errorCode == 360587416) {
      errorMsg = '有効なメールアドレスを入力してください。';
    } else if (errorCode == 505284406) {
      // 入力されたメールアドレスが登録されていない場合
      errorMsg = 'メールアドレスかパスワードが間違っています。';
    } else if (errorCode == 185768934) {
      // 入力されたパスワードが間違っている場合
      errorMsg = 'メールアドレスかパスワードが間違っています。';
    } else if (errorCode == 382293344) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください。';
    } else {
      errorMsg = '$orgErrorMsg[$errorCode]';
    }

    return errorMsg;
  }

  // アカウント登録時の日本語エラーメッセージ
  register_error_msg(int errorCode, String orgErrorMsg) {
    String errorMsg;

    if (errorCode == 360587416) {
      errorMsg = '有効なメールアドレスを入力してください。';
    } else if (errorCode == 34618382) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = '既に登録済みのメールアドレスです。';
    } else if (errorCode == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください。';
    } else {
      errorMsg = '$orgErrorMsg[$errorCode]';
    }

    return errorMsg;
  }
}