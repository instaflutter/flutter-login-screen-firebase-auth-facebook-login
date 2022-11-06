import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/auth/resetPasswordScreen/reset_password_cubit.dart';
import 'package:flutter_login_screen/ui/loading_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String _emailAddress = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (context) => ResetPasswordCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                  color: isDarkMode(context) ? Colors.white : Colors.black),
              elevation: 0.0,
            ),
            body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
              listenWhen: (old, current) => old != current,
              listener: (context, state) async {
                if (state is ResetPasswordDone) {
                  context.read<LoadingCubit>().hideLoading();
                  showSnackBar(context,
                      'Reset password email has been sent, Please check your email.');
                  Navigator.pop(context);
                } else if (state is ValidResetPasswordField) {
                  await context
                      .read<LoadingCubit>()
                      .showLoading(context, 'Sending Email...', false);
                  if (!mounted) return;
                  context
                      .read<ResetPasswordCubit>()
                      .resetPassword(_emailAddress);
                } else if (state is ResetPasswordFailureState) {
                  showSnackBar(context, state.errorMessage);
                }
              },
              buildWhen: (old, current) =>
                  current is ResetPasswordFailureState && old != current,
              builder: (context, state) {
                if (state is ResetPasswordFailureState) {
                  _validate = AutovalidateMode.onUserInteraction;
                }
                return Form(
                  autovalidateMode: _validate,
                  key: _key,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 32.0, right: 16.0, left: 16.0),
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                                color: Color(colorPrimary),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, right: 24.0, left: 24.0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            validator: validateEmail,
                            onFieldSubmitted: (_) => context
                                .read<ResetPasswordCubit>()
                                .checkValidField(_key),
                            onSaved: (val) => _emailAddress = val!,
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: const Color(colorPrimary),
                            decoration: getInputDecoration(
                                hint: 'E-mail',
                                darkMode: isDarkMode(context),
                                errorColor: Theme.of(context).errorColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 40.0, left: 40.0, top: 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width / 1.5),
                              backgroundColor: const Color(colorPrimary),
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(
                                  color: Color(colorPrimary),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Send Email',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => context
                                .read<ResetPasswordCubit>()
                                .checkValidField(_key),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
