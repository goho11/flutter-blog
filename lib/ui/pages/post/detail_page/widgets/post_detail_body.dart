import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailBody extends ConsumerWidget {
  // 3. postId 생성 -> ConsumerWidget 변경
  int postId;

  PostDetailBody(this.postId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider : Future, Stream 응답 계속 받음, State watch못함(전역 데이터 보관)
    // NotifierProvider 로 모든 걸 끝낼 수 있다 -> 현재 사용중
    PostDetailModel? model = ref.watch(postDetailProvider(postId));

    // 6. if문 추가
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 화면이? 다 분리되어 생성자를 넘김
            PostDetailTitle("${model.post.title}"),
            const SizedBox(height: largeGap),
            PostDetailProfile(model.post),
            PostDetailButtons(model.post),
            const Divider(),
            const SizedBox(height: largeGap),
            PostDetailContent("${model.post.content}"),
          ],
        ),
      );
    }
  }
}
