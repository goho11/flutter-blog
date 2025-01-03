import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../_core/utils/my_http.dart';

class UserRepository {
  const UserRepository();

  // 회원가입
  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    Response response = await dio.post("/join", data: data);

    // 200 이면 진행
    // Map으로 묵시적 형변환
    Map<String, dynamic> body = response.data; // response header, body 중에 body
    Logger().d(body); // TODO: test 코드 직접 작성
    return body;
  }

  // 로그인
  // 6. 메서드 완성하기 -> 레코드 문법 배우고 수정
  // Future에 값2개 받기, return에 body와 토큰 한번에 반환
  Future<(Map<String, dynamic>, String)> findByUsernameAndPassword(
      Map<String, dynamic> data) async {
    Response response = await dio.post("/login", data: data);

    Map<String, dynamic> body = response.data;
    // Logger().d(body);

    // 7. 토큰받기
    String accessToken = "";
    try {
      accessToken = response.headers["Authorization"]![0]; // 0번지
      // Logger().d(accessToken);
    } catch (e) {} // 토큰없음

    return (body, accessToken);
  }

  // 자동 로그인
  // 2. 메서드 생성
  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post(
      "/auto/login",
      options: Options(headers: {"Authorization": accessToken}),
    );
    Map<String, dynamic> body = response.data;
    return body;
  }
}
