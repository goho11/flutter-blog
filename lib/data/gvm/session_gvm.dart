import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

// 글로벌 View Model - 화면과 1대1 매칭 모델X. 공통 뷰모델
// 뷰가 뷰모델을 호출
class SessionGVM extends Notifier<SessionUser> {
  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!;
  UserRepository userRepository = const UserRepository();

  @override
  SessionUser build() {
    return SessionUser(
        id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login() async {}

  // 회원가입
  // Map으로 바꾸기 - 알아서 json바꿔 던짐
  Future<void> join(String username, String email, String password) async {
    final body = {
      "username": username,
      "email": email,
      "passsword": password,
    };

    Map<String, dynamic> responseBody = await userRepository.save(body);
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
      // 실패시 회원가입 화면 그대로(화면이동X)
      // return에 값이 없으면 메서드 종료(문법)
      return;
    }
    Navigator.pushNamed(mContext, "/login"); // 성공시 바로 빠져나와 로그인 화면 이동
  }

  Future<void> logout() async {}

  Future<void> autoLogin() async {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.popAndPushNamed(mContext, "/login");
      },
    );
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});
