import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin = false});
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

  // 로그인
  // 5. 값 정의
  // 뷰모델은 상태만 바꾸고 return필요없어 void
  Future<void> login(String username, String password) async {
    final body = {
      "username": username,
      "password": password,
    };

    // 6. 메서드 완성하기 (Repository이동)
    // 9. 값 2개 받기로 수정
    final (responseBody, accessToken) =
        await userRepository.findByUsernameAndPassword(body);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("로그인 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // 10. 정상 로그인 때 로그인 후처리 -gvm에 데이터 갱신
    // 10-1. 토큰을 Storage 저장
    await secureStorage.write(
        key: "accessToken", value: accessToken); // I/O 빨리끝남

    // 10-2. SessionUser 갱신
    Map<String, dynamic> data = responseBody["response"]; // test코드에 있는 값
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    // 10-3. Dio 토큰 세팅
    dio.options.headers["Authorization"] = accessToken;

    // Logger().d(dio.options.headers);

    Navigator.popAndPushNamed(mContext, "/post/list");
  }

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

  // 로그아웃
  // 서버측에 통신 필요 없음(레파지토리 호출x)
  Future<void> logout() async {
    // 3-1. 디바이스 토큰 삭제
    await secureStorage.delete(key: "accessToken");
    // 3-2. 상태 갱신
    state = SessionUser(); // 값이 없으면 기본 null

    // 3-3. dio 갱신
    dio.options.headers["Authorization"] = "";

    // 3-4. 화면이동
    Navigator.popAndPushNamed(mContext, "/login");
  }

  // 자동 로그인
  // 절대 SessionUser가 있을 수 없다
  Future<void> autoLogin() async {
    // 1. 토큰 디바이스 가져오기
    String? accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken == null) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    // 2. 레파지토리에 위임

    // 3. 통신
    Map<String, dynamic> responseBody =
        await userRepository.autoLogin(accessToken);

    if (!responseBody["success"]) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    dio.options.headers["Authorization"] = accessToken;

    Navigator.popAndPushNamed(mContext, "/post/list");
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});
