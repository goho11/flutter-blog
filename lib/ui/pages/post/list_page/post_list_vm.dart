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
  List<PostList_Post> posts;
}

// 모델에 post와 user 객체 만들어 사용
class PostList_Post {}

class PostList_User {}

// Provider 창고관리자
final postListProvider = NotifierProvider<PostListVM, PostListModel?>(() {
  return PostListVM();
});

// VM 창고
class PostListVM extends Notifier<PostListModel?> {
  @override
  PostListModel? build() {
    init();
    return null;
  }

  // init 화면 초기화
  Future<void> init() async {}
}
