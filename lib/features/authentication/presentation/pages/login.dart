import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitch_plus/core/api/api_keys.dart';
import 'package:kitch_plus/core/constants/local_storage.dart';
import 'package:kitch_plus/core/routes/app-routes.dart';
import 'package:kitch_plus/core/constants/loading_widget.dart';
import 'package:kitch_plus/core/functions/snackBar_message.dart';
import 'package:kitch_plus/features/authentication/presentation/widget/form_login_widget.dart';
import '../bloc/authentication_bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: _listenWhen,
            listener: _listen,
            builder: _builder
        ));
  }

  bool _listenWhen(previous, current) {
    return current is AuthSuccess || current is AuthFailure;
  }

  void _listen(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      SnackBarMessage().showSuccessSnackBar(message: state.message, context: context);
      LocalStorage().saveData(key: ApiKeys.isLogin, value: true);
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,(route)=>false);
    }

    if (state is AuthFailure) {
      SnackBarMessage().showErrorSnackBar(message: state.message, context: context);}
  }

  Widget _builder(BuildContext context, AuthState state) {
    if (state is AuthLoading) {
      return progressIndicator();
    }
    return FormLoginWidget();
  }
}
