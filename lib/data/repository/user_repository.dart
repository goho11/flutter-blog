import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../_core/utils/my_http.dart';

class UserRepository {
  const UserRepository();

  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    Response response = await dio.post("/join", data: data);

    // 200 이면 진행
    // Map으로 묵시적 형변환
    Map<String, dynamic> body = response.data; // response header, body 중에 body
    Logger().d(body); // TODO: test 코드 직접 작성
    return body;
  }
}
