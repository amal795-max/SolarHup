// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../bloc/authentication_bloc/auth_bloc.dart';
//
// class RegisterPage extends StatelessWidget {
//   const RegisterPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocConsumer<AuthBloc, AuthState>(
//           listenWhen: _listenWhen,
//           listener: _listener,
//           buildWhen: _buildWhen,
//           builder: _builder,
//         ));
//   }
//
// bool _listenWhen(previous,current) {
//   return current is AuthSuccess || current is AuthFailure;
// }
//
// _listener(BuildContext context ,state){
//   final authBloc = context.read<AuthBloc>();
//   final LocalStorage cache = LocalStorage();
//   if(state is AuthSuccess){
//     SnackBarMessage().showSuccessSnackBar(message: state.message, context: context);
//     cache.saveData(key: ApiKeys.password, value:authBloc.passwordController.text );
//     cache.saveData(key: ApiKeys.email, value:authBloc.emailController.text );
//
//     Navigator.pushReplacementNamed(context,AppRoutes.customBottomAppbar);
//
//   }  if(state is AuthFailure){
//     SnackBarMessage().showErrorSnackBar(message: state.message, context: context);
//   }
// }
//   bool _buildWhen(previous, current) {
//     return current is AuthLoading || current is AuthFailure || current is AuthSuccess;
//   }
//   Widget _builder(BuildContext context, AuthState state) {
//       if (state is AuthLoading) {
//         return progressIndicator();
//       }   return FormRegisterWidget();
//      }
// }