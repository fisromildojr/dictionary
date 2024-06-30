import 'package:dictionary/modules/user/controllers/user_controller.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final formKey = GlobalKey<FormState>();
  final controller = Get.find<UserController>();
  final _passwordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
              color: Theme.of(context).cardColor.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding * 2),
                child: Form(
                  key: formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/logo.svg',
                                  fit: BoxFit.contain,
                                  height: 60,
                                ),
                                const Positioned(
                                  bottom: -3,
                                  right: 0,
                                  child: Text(
                                    'Dictionary',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          controller.formMode.value,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withOpacity(0.7)),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        if (controller.formMode.value != 'Login')
                          TextFormField(
                            key: const Key('nameField'),
                            autofocus: true,
                            controller: controller.nameController,
                            autofillHints: const [AutofillHints.name],
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text('Name'),
                            ).applyDefaults(
                              Theme.of(context).inputDecorationTheme,
                            ),
                            validator: Validatorless.required('Required'),
                          ),
                        if (controller.formMode.value != 'Login')
                          const SizedBox(
                            height: 24,
                          ),
                        TextFormField(
                          key: const Key('loginField'),
                          autofocus: true,
                          controller: controller.loginController,
                          autofillHints: const [AutofillHints.username],
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('Login'),
                          ).applyDefaults(
                            Theme.of(context).inputDecorationTheme,
                          ),
                          validator: Validatorless.required('Required'),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Obx(() => TextFormField(
                              key: const Key('passwordField'),
                              controller: controller.passwordController,
                              autofillHints: const [AutofillHints.password],
                              keyboardType: TextInputType.text,
                              obscureText: _passwordVisible.isFalse,
                              onFieldSubmitted: (_) async {
                                await controller.login(formKey);
                              },
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible.isTrue
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    _passwordVisible(!_passwordVisible.value);
                                  },
                                ),
                              ).applyDefaults(
                                Theme.of(context).inputDecorationTheme,
                              ),
                              validator: Validatorless.required('Required'),
                            )),
                        const SizedBox(
                          height: 24,
                        ),
                        if (controller.formMode.value == 'Login')
                          ElevatedButton(
                            key: const Key('loginButton'),
                            onPressed: () async {
                              await controller.login(formKey);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                textStyle:
                                    const TextStyle(color: Colors.white)),
                            child: Text(controller.formMode.value),
                          )
                        else
                          ElevatedButton(
                            key: const Key('registerButton'),
                            onPressed: () async {
                              await controller.register(formKey);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                textStyle:
                                    const TextStyle(color: Colors.white)),
                            child: Text(controller.formMode.value),
                          ),
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        if (controller.formMode.value == 'Login')
                          Row(
                            key: const Key('changeToRegister'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('New here? '),
                              TextButton(
                                onPressed: () {
                                  controller.formMode('Register');
                                },
                                child: const Text(
                                  'Register',
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            key: const Key('changeToLogin'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have a login? '),
                              TextButton(
                                onPressed: () {
                                  controller.formMode('Login');
                                },
                                child: const Text(
                                  'Login',
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
