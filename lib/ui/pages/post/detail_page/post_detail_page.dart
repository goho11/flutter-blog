import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_body.dart';

class PostDetailPage extends StatelessWidget {
  // 2. postId 생성
  int postId;

  PostDetailPage(this.postId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostDetailBody(postId),
    );
  }
}
