import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  //로그인한 유저정보 가져오기
  User? currentUser() {
    //로그인 되지 않으면 Null 반환
    return FirebaseAuth.instance.currentUser;
  }

  /**
   * 이름지정 매개변수
   * 소괄호 안에 중괄호를 넣고, 그 안에 매개변수를 넣어서 표현 할 수 있다.
   * 이름지정 매개변수는 해당 이름으로 값을 받아 오는 역할을 한다.
   */
  //회원가입
  void signUp({
    required String email,
    required String password,
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    //회원가입
    if (email.isEmpty) {
      onError('이메일을 입력해주세요');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요');
      return;
    }
    // firebase auth 회원가입
    try {
      // 회원가입 시도
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //성공하면
      onSuccess();
    } on FirebaseAuthException catch (e) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 성공 함수 호출
        onSuccess();
      } on FirebaseAuthException catch (e) {
        // 에러메시지 한국어로 바꾸기
        if (e.code == 'weak-password') {
          onError('비밀번호를 6자리 이상 입력해 주세요.');
        } else if (e.code == 'email-already-in-use') {
          onError('이미 가입된 이메일 입니다.');
        } else if (e.code == 'invalid-email') {
          onError('이메일 형식을 확인해주세요.');
        } else if (e.code == 'user-not-found') {
          onError('일치하는 이메일이 없습니다.');
        } else if (e.code == 'wrong-password') {
          onError('비밀번호가 일치하지 않습니다.');
        } else {
          onError(e.message!);
        }
        // Firebase auth 에러 발생
        // ! => null을 강제로 벗겨준다.
        onError(e.message!);
      } catch (e) {
        // Firebase auth 이외의 에러 발생
        onError(e.toString());
      }

      // FireVase auth 에러 발생
      // ! => null을 강제로 벗겨준다.
      onError(e.message!);
    } catch (e) {
      // FireBase auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  //로그인
  void signIn({
    required String email,
    required String password,
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    // 로그인 입력 검증
    if (email.isEmpty) {
      onError('이메일을 입력해주세요');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요');
      return;
    }
    //로그인 시도
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //성공시 호출
      onSuccess();

      //로그인 상태변경 알림
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException에서 오류 메시지를 가져와 onError 콜백 함수를 호출합니다.
      onError(e.message ?? '로그인 오류가 발생했습니다.');
    } catch (e) {
      // 그 외의 예외가 발생했을 때의 처리입니다.
      onError(e.toString());
    }
  }

  //로그아웃
  void signOut() async {
    //로그아웃
    await FirebaseAuth.instance.signOut();
  }
}
