import 'package:flutter_blog/data/repository/user_repository.dart';

void main() async {
  // 8. 로그인 메서드 테스트
  UserRepository userRepository = const UserRepository();
  await userRepository
      .findByUsernameAndPassword({"username": "ss", "password": "1234"});
}
