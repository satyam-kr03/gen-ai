// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fpdart/fpdart.dart' as fp;
// import 'package:institute_app/application/auth/auth_bloc.dart';
// import 'package:institute_app/data/auth/firebase_auth_repo.dart';
// import 'package:institute_app/domain/auth/models/auth_user.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({required this.getData, super.key});
//   final GetData getData;

//   @override
//   Widget build(BuildContext context) {
//     //assuming user is signed in
//     final authUser = getData._authRepo
//         .getSignedInUser()
//         .getOrElse(() => AuthUser(id: '', name: '', email: ''));

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('User ID: ${authUser.id}'),
//               Text('User Name: ${authUser.name}'),
//               Text('User Email: ${authUser.email}'),
//             ],
//           ),
//           ElevatedButton(
//             onPressed: () {
//               BlocProvider.of<AuthBloc>(context)
//                   .add(const AuthEvent.signedOut());
//               Navigator.of(context, rootNavigator: true)
//                   .pushReplacementNamed('/');
//             },
//             child: const Text('Sign Out'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GetData {
//   GetData(this._authRepo);
//   final FirebaseAuthRepo _authRepo;
//   FirebaseAuthRepo get authRepo => _authRepo;
// }