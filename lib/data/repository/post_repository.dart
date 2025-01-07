import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class PostRepository {
  const PostRepository();

  Future<Map<String, dynamic>> findAll({int page = 0}) async {
    Response response =
        await dio.get("/api/post", queryParameters: {"page": page});
    Map<String, dynamic> body = response.data;
    return body;
  }

  // 5. findById 완성
  Future<Map<String, dynamic>> findById(int id) async {
    Response response = await dio.get("/api/post/$id");
    Map<String, dynamic> body = response.data;
    return body;
  }

  // 게시글 삭제
  Future<Map<String, dynamic>> delete(int id) async {
    Response response = await dio.delete("/api/post/$id");
    Map<String, dynamic> body = response.data;
    return body;
  }
}