import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostListBody extends ConsumerWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListModel? model = ref.watch(postListProvider);
    PostListVM vm =
        ref.read(postListProvider.notifier); // refreshCtrl 클래스 내부에서 꺼내오기

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SmartRefresher(
        controller: vm.refreshCtrl,
        enablePullUp: true,
        onRefresh: () async => await vm.init(),
        enablePullDown: true,
        onLoading: () async => await vm.nextList(),
        // 다음 페이지 요청(상태 업탠드)
        child: ListView.separated(
          itemCount: model.posts.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      // 1. model의 id 넘기기
                      MaterialPageRoute(
                          builder: (_) =>
                              PostDetailPage(model.posts[index].id!)));
                },
                child: PostListItem(post: model.posts[index]));
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      );
    }
  }
}
