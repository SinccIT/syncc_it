import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        appBar: AppBar(
          title: Text('로그인'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  user == null ? '로그인 해주세요' : '${user.email}님 안녕하세요',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: '이메일'),
              ),
              TextField(
                controller: passwordController,
                //비밀번호 숨기기
                obscureText: true,
                decoration: InputDecoration(hintText: '비밀번호'),
              ),
              ElevatedButton(
                onPressed: () {
                  //로그인
                  authService.signIn(
                    email: emailController.text,
                    password: passwordController.text,
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('로그인 성공'),
                        ),
                      );
                      //로그인 성공시 홈페이지로 이동
                      // pushReplacement 새로운 페이지로 이동해서 뒤로버튼 X
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    },
                    onError: (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  authService.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    onSuccess: () {
                      //회원가입 성공
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('회원가입 성공'),
                        ),
                      );
                      // print('회원가입 성공');
                    },
                    onError: (err) {
                      //에러발생
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err),
                        ),
                      );
                      // print('회원가입 실패 : $err');
                    },
                  );
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

// 홈페이지

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDoList"),
        actions: [
          TextButton(
            onPressed: () {
              //로그 버튼을 눌렀을 때 로그인 페이지로 이동
              context.read<AuthService>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // 입력창
                Expanded(
                  child: TextField(
                    controller: jobController,
                    decoration: InputDecoration(
                      hintText: "job을 입력해주세요",
                    ),
                  ),
                ),
                // 추가버튼
                ElevatedButton(
                  onPressed: () {
                    // job이 없다면
                    if (jobController.text.isEmpty) {
                      print('create job');
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          // 투두 리스트
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                String job = "$index";
                bool isDone = false;
                return ListTile(
                  title: Text(
                    job,
                    style: TextStyle(
                        fontSize: 24,
                        color: isDone ? Colors.grey : Colors.black,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: IconButton(
                    icon: Icon(CupertinoIcons.delete),
                    onPressed: () {},
                  ),
                  onTap: () {
                    // 아이템 클릭하여 isDone 상태 변경
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
