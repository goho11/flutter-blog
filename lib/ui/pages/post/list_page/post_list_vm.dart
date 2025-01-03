import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 초기 세팅: 화면에 필요한 모델 페이지 생성
// 화면 정보를 받는 클래스 생성 및 받기
// return값을 api문서로 찾기
class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  PostListModel.fromMap(Map<String, dynamic> map)
      : isFirst = map["isFirst"],
        isLast = map["isLast"],
        pageNumber = map["pageNumber"],
        size = map["size"],
        totalPage = map["totalPage"],
        // dynamic으로 변환
        posts = (map["posts"] as List<dynamic>)
            .map((e) => Post.fromMap(e))
            .toList();
// 데이터 통신
// 1. list 타입으로 바꾸고
// 2. .map을 사용가능할때, 다이나믹으로 바꿈
// 3. e가 묵시적 형변환
}

// Provider 창고관리자
final postListProvider = NotifierProvider<PostListVM, PostListModel?>(() {
  return PostListVM();
});

// VM 창고
// post레파지토리 만들고 넘어옴
class PostListVM extends Notifier<PostListModel?> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostListModel? build() {
    init(0);
    return null;
  }

  // init 화면 초기화
  Future<void> init(int page) async {
    // 데이터 받기
    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: page);

    // 받은 데이터 검증
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 목록보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // 실패안하면 state에 데이터 적용
    state = PostListModel.fromMap(responseBody["response"]);
  }
}
