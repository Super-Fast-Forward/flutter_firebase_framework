import 'dart:async';
import 'dart:convert';

import 'package:auth/main.dart';
import 'package:auth/providers/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

final linkedinAuthProvider =
    StateNotifierProvider<LinkedinAuthProvider, String>(
  (ref) {
    return LinkedinAuthProvider(ref);
  },
);

class LinkedinAuthProvider extends StateNotifier<String> {
  LinkedinAuthProvider(this._ref) : super('');
  final Ref _ref;

  Future<String?> validateUrl() async {
    const tokenType = 'validate_url';
    try {
      final url = Uri.parse(
          'https://us-central1-jsninja-dev.cloudfunctions.net/custom-token?token_type=$tokenType');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error validate_url: $e');
    }
    return null;
  }

  Future<bool> checkCustomUserExists(String uid) async {
    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  // It is require to enable IAM Service Account Credentials API
  // in cloud console Creates short-lived credentials
  // for impersonating IAM service accounts
  // http request with userID in this case linkedin ID user
  // Finally get response with a custome token, this allow to sign in
  // new client who is intending sign in in our app

  FutureOr<String?> generateCustomToken(String userID) async {
    try {
      await initializeFirebase();

      // Replace with the desired token type
      const tokenType = 'generate_custom_token';

      final url = Uri.parse(
        'https://us-central1-jsninja-dev.cloudfunctions.net/custom-token?userID=$userID&token_type=$tokenType',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final customToken = response.body;
        return customToken;
      } else {
        print(
          'Failed to fetch custom token. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Failed to authenticate user: $e');
    }
    return null;
  }

  // After generate a custom token is require verify if the customer already
  // exists in our database and finish login therwise is created, save data
  // and login to the app
  Future<bool> signInWithCustomToken(String customToken) async {
    try {
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      return true;
    } catch (e) {
      print('Authentication with custom token Error: $e');
      return false;
    }
  }

  // Fuction that autenticate custom Provider (Linkedin, seek, Indeed)
  Future<void> signinCustomUserFirebase(
    userId,
    String email,
    String pictureURL,
    userName,
  ) async {
    //Generate custom user
    final customToken = await generateCustomToken(userId);
    final signinfirebase = await signInWithCustomToken(customToken ?? "");

    if (signinfirebase) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        if (userId == uid) {
          // Check if the user exists in the database
          bool userExists = await checkCustomUserExists(uid);

          if (!userExists) {
            // User doesn't exist in the database, create a new user, save data, and perform login
            await _ref.read(firebaseAuthProvider.notifier).saveDataFirebase(
                  uid,
                  email,
                  pictureURL,
                  userName,
                );
          }
        } else {
          print("Authentication Failed - something went wrong");
        }
      }
    }
  }

  // this is client service request
  // I need to do a http request with the code
  // Requests an access token using the authorization code
  Future<void> requestAccessTokenLinkedin({
    required String code,
    required String clientId,
    required String redirectUri,
  }) async {
    const tokenType = 'access_token_linkedin';
    try {
      final url = Uri.parse(
          'https://us-central1-jsninja-dev.cloudfunctions.net/custom-token?code=$code&token_type=$tokenType&CLIENT_ID=$clientId&REDIRECT_URI=$redirectUri');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);
        final userId = responseData['user_id'];
        final email = responseData['email'];
        final pictureUrl = responseData['picture_url'];
        final userName = responseData['user_name'];

        _ref.read(showLoading.notifier).value = false;
        await signinCustomUserFirebase(userId, email, pictureUrl, userName);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error requestAccessTokenLinkedin: $e');
      // Handle the error
    }
  }

  Future<void> authenticateLinkedin() async {
    final validUrl = await validateUrl();

    const String clientId = '86huxyar2l3rkb';
    final String redirectUri = '${validUrl}/auth.html';
    //final String redirect_uri = 'http://localhost:49215/auth.html';

    final url = 'https://www.linkedin.com/oauth/v2/authorization?'
        'response_type=code&'
        'client_id=$clientId&'
        'redirect_uri=$redirectUri&'
        'scope=r_liteprofile%20r_emailaddress';

    // Open the authorization URL in a web view and wait for the result
    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'https',
    );

    // Extract the authorization code from the result
    final code = await handleAuthResultCodeLinkedin(result);

    // Request an access token using the authorization code
    if (code != null) {
      await requestAccessTokenLinkedin(
        code: code,
        clientId: clientId,
        redirectUri: redirectUri,
      );
    }

    _ref.read(showLoading.notifier).value = false;
  }

  // Extracts the authorization code from the callback URL
  Future<String?> handleAuthResultCodeLinkedin(String result) async {
    final currentUri = Uri.parse(result);
    return currentUri.queryParameters['code'];
  }
}
