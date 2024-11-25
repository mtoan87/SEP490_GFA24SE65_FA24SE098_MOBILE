import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_mobile_app/utils/helpers/snackbar_helper.dart';
import 'package:sos_mobile_app/values/app_regex.dart';
import '../components/app_text_form_field.dart';
import '../resources/resources.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../values/app_constants.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'home_page.dart'; // Import the new HomePage file

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    fieldValidNotifier.value = AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password);
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://soschildrenvillage.azurewebsites.net/api/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        SnackbarHelper.showSnackBar(AppStrings.loggedIn);

        // Parse the response body
        final responseData = jsonDecode(response.body);
        final userId = responseData['userId'];
        final roleId = responseData['roleId'];
        final token = responseData['data'];

        // Save the data to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setInt('roleId', roleId);
        await prefs.setString('token', token);

        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        SnackbarHelper.showSnackBar('Login failed. Please try again.');
      }
    } catch (e) {
      SnackbarHelper.showSnackBar('Error connecting to the server.');
    }
  }

  Future<void> makeApiCall() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve saved data
    final userId = prefs.getString('userId');
    final roleId = prefs.getInt('roleId');
    final token = prefs.getString('token');

    if (userId != null && token != null) {
      // Use the saved data for making another API request
      final response = await http.get(
        Uri.parse('https://example.com/api/some-endpoint'),
        headers: {
          'Authorization': 'Bearer $token', // Use the token for authentication
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Handle the response
        print('API call successful');
      } else {
        print('Failed to fetch data');
      }
    } else {
      print('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientBackground(
            children: [
              Text(AppStrings.signInToYourNAccount, style: AppTheme.titleLarge),
              SizedBox(height: 6),
              Text(AppStrings.signInToYourAccount, style: AppTheme.bodySmall),
            ],
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    controller: emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      if (value!.isEmpty)
                        return AppStrings.pleaseEnterEmailAddress;
                      return AppConstants.emailRegex.hasMatch(value)
                          ? null
                          : AppStrings.invalidEmailAddress;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: AppStrings.password,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          if (value!.isEmpty)
                            return AppStrings.pleaseEnterPassword;
                          return AppConstants.passwordRegex.hasMatch(value)
                              ? null
                              : AppStrings.invalidPassword;
                        },
                        suffixIcon: IconButton(
                          onPressed: () =>
                              passwordNotifier.value = !passwordObscure,
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.forgotPassword),
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return FilledButton(
                        onPressed: isValid ? login : null,
                        child: const Text(AppStrings.login),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
