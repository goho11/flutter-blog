import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailModel {
  // 게시글 목록 = post객체 그대로 들고오기
  Post post;

  PostDetailModel.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);
}

// family > 타입 int > FamilyNotifier > int 추가
// autoDispose 화면 파괴시 창고도 같이 소멸
final postDetailProvider = NotifierProvider.family
    .autoDispose<PostDetailVM, PostDetailModel?, int>(() {
  return PostDetailVM();
});

class PostDetailVM extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostDetailModel? build(id) {
    init(id);
    return null;
  }

  Future<void> init(id) async {
    // 4. 위임 -무조건 Map을 받음
    // findById 메서드 생성
    Map<String, dynamic> responseBody = await postRepository.findById(id);

    // 에러 처리를 뷰모델이 처리
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 상세보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // Map 던지게 만들기 -> 상단 fromMap 메서드 생성
    PostDetailModel model = PostDetailModel.fromMap(responseBody["response"]);
    state = model;
  }

  // 게시글 삭제 메서드
  Future<void> deleteById(int id) async {
    Map<String, dynamic> responseBody = await postRepository.delete(id);
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 삭제 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // PostlistVm의 상태를 변경
    // 1) 뷰모델이 통신을 다시해 데이터 초기화 (추천x)
    // ref.read(postListProvider.notifier).init(0);
    // 2)
    ref.read(postListProvider.notifier).remove(id);

    // 화면 파괴시 vm이 autoDispose 됨
    // Navigator.pop(mContext);
    Navigator.pop(mContext);
  }
}
