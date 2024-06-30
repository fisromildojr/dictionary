// test/modules/user/controllers/user_controller_test.dart
import 'package:dictionary/modules/user/controllers/user_controller.dart';
import 'package:dictionary/modules/user/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class MockUserController extends GetxController implements UserController {
  @override
  final isLoading = false.obs;

  @override
  var formMode = 'Login'.obs;

  @override
  final loginController = TextEditingController();

  @override
  final passwordController = TextEditingController();

  @override
  final nameController = TextEditingController();

  @override
  Future<void> register(GlobalKey<FormState> formKey) async {}

  @override
  Future<void> login(GlobalKey<FormState> formKey) async {}

  @override
  Future<void> logout() async {}
}

void main() {
  late MockUserController mockUserController;

  setUp(() {
    mockUserController = MockUserController();
    Get.put<UserController>(mockUserController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoginForm renders correctly and interactions work',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: LoginForm(),
        ),
      ),
    );

    expect(find.byKey(const Key('loginField')), findsOne);
    expect(find.byKey(const Key('passwordField')), findsOne);
    expect(find.byKey(const Key('changeToRegister')), findsOne);
    expect(find.byKey(const Key('loginButton')), findsOne);

    await tester.enterText(find.byType(TextFormField).at(0), 'testUser');
    await tester.enterText(find.byType(TextFormField).at(1), 'testPassword');

    expect(mockUserController.loginController.text, 'testUser');
    expect(mockUserController.passwordController.text, 'testPassword');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(mockUserController.loginController.text, 'testUser');
    expect(mockUserController.passwordController.text, 'testPassword');

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(mockUserController.formMode.value, 'Register');

    expect(find.byKey(const Key('nameField')), findsOne);
    expect(find.byKey(const Key('loginField')), findsOne);
    expect(find.byKey(const Key('passwordField')), findsOne);
    expect(find.byKey(const Key('changeToLogin')), findsOne);
    expect(find.byKey(const Key('registerButton')), findsOne);

    await tester.enterText(find.byType(TextFormField).at(0), 'testName');
    await tester.enterText(find.byType(TextFormField).at(1), 'testUser');
    await tester.enterText(find.byType(TextFormField).at(2), 'testPassword');

    expect(mockUserController.nameController.text, 'testName');
    expect(mockUserController.loginController.text, 'testUser');
    expect(mockUserController.passwordController.text, 'testPassword');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(mockUserController.nameController.text, 'testName');
    expect(mockUserController.loginController.text, 'testUser');
    expect(mockUserController.passwordController.text, 'testPassword');
  });
}
