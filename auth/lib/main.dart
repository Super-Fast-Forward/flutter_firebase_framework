import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'generic_state_notifier.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(ProviderScope(child: MainApp()));
// }

// class MainApp extends ConsumerWidget {
//   const MainApp({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//       title: 'JOB SEARCH NINJA',
//       home: TheApp(),
//     );
//   }
// }

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

// class TheApp extends ConsumerStatefulWidget {
//   const TheApp({Key? key}) : super(key: key);
//   @override
//   TheAppState createState() => TheAppState();
// }

// class TheAppState extends ConsumerState<TheApp> {
//   //bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     ref.read(isLoading.notifier).value = true;
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         ref.read(isLoggedIn.notifier).value = false;
//         ref.read(isLoading.notifier).value = false;
//       } else {
//         ref.read(isLoggedIn.notifier).value = true;
//         ref.read(isLoading.notifier).value = false;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (ref.watch(isLoading)) {
//       return Center(
//         child: Container(
//           alignment: Alignment(0.0, 0.0),
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else {
//       return Scaffold(
//           body: ref.watch(isLoggedIn) == false
//               ? LoginScreen('login', 'test', {
//                   "loginGitHub": false,
//                   "loginGoogle": true,
//                   "loginEmail": false,
//                   "loginSSO": false,
//                   "loginAnonymous": true,
//                   "signupOption": false,
//                 })
//               : Text('Logged in!'));
//     }
//   }
// }
