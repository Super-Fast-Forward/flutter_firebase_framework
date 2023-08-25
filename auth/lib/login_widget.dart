part of flutter_firebase_framework;

final userLoggedIn = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

final showLoading = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

final openEmailLogin = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

final openEmailSignIn = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

/// LoginButtonsWidget is a widget that displays the login buttons.
/// Each button is a [ElevatedButton] that calls the appropriate login function.
/// The login functions are defined in the [LoginConfig] class.
///
/// Example:
/// LoginButtonsWidget(
///  screenTitle: 'Login',
/// onLoginAnonymousButtonPressed: () {
///  print('Login Anonymously');
/// },
///
///
///
///
///

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class LoginWidget extends ConsumerWidget {
  /// This is the function that is called when the Anonymous Login button is pressed.
  /// It is defined in the [LoginConfig] class.
  /// Use it for a follow-up action when the user has logged in anonymously.
  final Function? onLoginAnonymousButtonPressed;

  ///Login Options are set in LoginConfig
  const LoginWidget({
    this.anonymousLogin = true,
    this.onLoginAnonymousButtonPressed,
    Key? key,
  }) : super(key: key);

  final bool anonymousLogin;

  void checkUserLoggedIn(WidgetRef ref) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User autenticaticated
      print(
          'checkUserLoggedIn - Authtenticated user (current User): ${currentUser.uid}');

      print(
          'checkUserLoggedIn Current - userLoggedInState: ${ref.read(userLoggedIn.notifier).value}');
      ref.read(userLoggedIn.notifier).value = true;
      print(
          'checkUserLoggedIn - After current state change to true - userLoggedInState: ${ref.read(userLoggedIn.notifier).value}');
    } else {
      // the user is not authenticated
      print('checkUserLoggedIn - Any user is autenticated');
      print(
          'checkUserLoggedIn Exist Login - userLoggedInState: ${ref.read(userLoggedIn.notifier).value}');
      ref.read(userLoggedIn.notifier).value = false;
      print(
          'checkUserLoggedIn - After Exist Login false - userLoggedInState: ${ref.read(userLoggedIn.notifier).value}');
    }
  }

  Future<String?> validate_url() async {
    print('validate_url');
    final tokenType = 'validate_url';
    try {
      final url = Uri.parse(
          'https://us-central1-jsninja-dev.cloudfunctions.net/custom-token?token_type=$tokenType');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final validateUrl = response.body;
        //print("validate_url: $validate_url");
        return validateUrl;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error validate_url: $e');
    }
    return null;
  }

  Future<void> authenticateLinkedin({required WidgetRef ref}) async {
    // returne the current url to do the resquest
    final validUrl = await validate_url();

    const String clientId = '86huxyar2l3rkb';
    final String redirectUri = '${validUrl}/auth.html';
    print("redirect_uri: $redirectUri");
    //final String redirect_uri = 'http://localhost:49215/auth.html';

    print('Authenticating...');

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
          code: code, ref: ref, client_id: clientId, redirect_uri: redirectUri);
    }

    checkUserLoggedIn(ref);
    ref.read(showLoading.notifier).value = false;
  }

  // Extracts the authorization code from the callback URL
  Future<String?> handleAuthResultCodeLinkedin(String result) async {
    print("handleAuthResultCodeLinkedin-test");
    final currentUri = Uri.parse(result);

    if (currentUri.queryParameters.containsKey('code')) {
      final code = currentUri.queryParameters['code'];
      print("Authorization Code was obtained");
      return code;
    }

    return null;
  }

  // this is client service request
  // I need to do a http request with the code
  // Requests an access token using the authorization code
  Future<void> requestAccessTokenLinkedin({
    required String code,
    required WidgetRef ref,
    required String client_id,
    required String redirect_uri,
  }) async {
    print("requestAccessTokenLinkedin");
    final tokenType = 'access_token_linkedin';
    final clientId = client_id;
    final redirectUri = redirect_uri;

    try {
      final url = Uri.parse(
          'https://us-central1-jsninja-dev.cloudfunctions.net/custom-token?code=$code&token_type=$tokenType&CLIENT_ID=$clientId&REDIRECT_URI=$redirectUri');
      final response = await http.get(url);
      print("requestAccessTokenLinkedin - response: $response");
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);
        final userId = responseData['user_id'];
        final email = responseData['email'];
        final pictureUrl = responseData['picture_url'];
        final userName = responseData['user_name'];

        // print("User ID: $user_id");
        // print("Email: $email");
        // print("Picture URL: $picture_url");
        // print("User Name: $user_name");
        ref.read(showLoading.notifier).value = false;
        await signinCustomUserFirebase(userId, email, pictureUrl, userName);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error requestAccessTokenLinkedin: $e');
      // Handle the error
    }
  }

// Fuction that autenticate custom Provider (Linkedin, seek, Indeed)

  Future<void> signinCustomUserFirebase(
      userId, String email, String pictureURL, userName) async {
    //Generate custom user

    print('signinCustomUserFirebase');
    final customToken = await generateCustomToken(userId);

    final signinfirebase = await signInWithCustomToken(customToken as String);

    if (signinfirebase) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        print('signInWithCustomToken - userID: $uid'); // Is it same?
        if (userId == uid) {
          // Check if the user exists in the database
          bool userExists = await checkCustomUserExists(uid);

          if (userExists) {
            // User exists in the database,
            print('User exists in the database');
          } else {
            // User doesn't exist in the database, create a new user, save data, and perform login
            print('User does not exist in the database');
            //Save data of user in database
            await saveDataFirebase(uid, email, pictureURL, userName);
          }
        } else {
          print("Authentication Failed - something went wrong");
        }
      }
    }
  }

  // It is require to enable IAM Service Account Credentials API
  // in cloud console Creates short-lived credentials
  // for impersonating IAM service accounts
  // http request with userID in this case linkedin ID user
  // Finally get response with a custome token, this allow to sign in
  // new client who is intending sign in in our app

  Future<String?> generateCustomToken(String userID) async {
    try {
      await initializeFirebase();
      print("generateCustomToken - Init App Firebase");

      final tokenType =
          'generate_custom_token'; // Replace with the desired token type

      final url = Uri.parse(
          'https://us-central1-jsninja-dev.cloudfunctions.net/custom-token?userID=$userID&token_type=$tokenType');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final customToken = response.body;
        print('Custom Token was obtained');
        //print('Custom Token: $customToken');
        return customToken;
      } else {
        print(
            'Failed to fetch custom token. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to authenticate user: $e');
      return null;
    }
  }

  // After generate a custom token is require verify if the customer already
  // exists in our database and finish login therwise is created, save data
  // and login to the app
  Future<bool> signInWithCustomToken(String customToken) async {
    print('signInWithCustomToken');
    try {
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      print('signInWithCustomToken done!');
      return true;
    } catch (e) {
      print('Authentication with custom token Error: $e');
      return false;
    }
  }

  Future<bool> checkCustomUserExists(String uid) async {
    print('checkCustomUserExists - start');
    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      return snapshot.exists; //true
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  // Save the user data based
  Future<void> saveDataFirebase(
      String uid, String email, String pictureURL, String userName) async {
    print('saveDataFirebase');
    try {
      final userRef = FirebaseFirestore.instance.collection('user').doc(uid);

      await userRef.set({
        'email': email,
        'pictureURL': pictureURL,
        'userName': userName,
      }, SetOptions(merge: true));

      print('User created with UID: $uid');
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    try {
      final result =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      print("Authentication successful");

      //determine if the user exists if not save custom data in the data base
      await checkUserExists(result);
    } catch (e) {
      // Handle authentication error
      print('Failed to sign in with GitHub: $e');
    }
  }

  // Auth page: https://github.com/settings/applications
  Future<void> signInWithGitHub() async {
    GithubAuthProvider githubAuthProvider = GithubAuthProvider();
    try {
      final result =
          await FirebaseAuth.instance.signInWithPopup(githubAuthProvider);
      print("Authentication successful");

      //determine if the user exists if not save custom data in the data base
      await checkUserExists(result);
    } catch (e) {
      // Handle authentication error
      print('Failed to sign in with GitHub: $e');
    }
  }

  //https://developer.twitter.com/en/portal/projects/1672405934805745666/apps/27364500/settings
  Future<void> signInWithFacebook() async {
    FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
    try {
      print("Starting Facebook authentication");
      final result =
          await FirebaseAuth.instance.signInWithPopup(facebookAuthProvider);
      print("Authentication successful");
      //determine if the user exists if not save custom data in the data base
      await checkUserExists(result);
    } catch (e) {
      // Handle authentication error
      print('Failed to sign in with Facebook: $e');
    }
  }

  Future<void> signInWithTwitter() async {
    TwitterAuthProvider twitterAuthProvider = TwitterAuthProvider();
    try {
      if (kIsWeb) {
        print("Starting twitter authentication");
        final result =
            await FirebaseAuth.instance.signInWithPopup(twitterAuthProvider);
        await checkUserExists(result);
      } else {
        final result =
            await FirebaseAuth.instance.signInWithProvider(twitterAuthProvider);
        await checkUserExists(result);
      }
      print("Authentication successful");
      //determine if the user exists if not save custom data in the data base
    } catch (e) {
      // Handle authentication error
      print('Failed to sign in with Twitter: $e');
    }
  }

  Future<void> checkUserExists(UserCredential result) async {
    print("checkUserExists");
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Access the signed-in user's information
      final user = result.user;
      final displayName = user?.displayName;
      final email = user?.email;
      final photoURL = user?.photoURL;

      // Retrieve additional user data using GitHub APIs
      // Make API calls using the 'accessToken'

      print("Current User:  ${currentUser.uid}");
      // print("User data:  $user");
      // print("Display Name: $displayName");
      // print("Email: $email");
      // print("Photo URL: $photoURL");

      // Deteremine if the user exits
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists) {
        // User already exists in the database
        print("User already exists");
      } else {
        print("data it will be saved");
        await saveDataFirebase(
            currentUser.uid, email!, photoURL!, displayName!);
        print("User data saved to Firebase");
      }
    } else {
      print("current user is null");
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Toast.showByContext(
        context: context,
        message: getFirebaseMessageFromErrorCode(e.code),
      );
    } catch (e) {
      Toast.showByContext(
        context: context,
        message: getFirebaseMessageFromErrorCode(""),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(showLoading)) {
      return const Center(child: CircularProgressIndicator());
    }

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 81),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Header(text: "Log in into your account"),
          const SizedBox(height: 42),
          LoginButton(
            text: "Continue with LinkedIn",
            icon: 'assets/linkedin_logo.svg',
            isVisible: true,
            onPressed: () {
              ref.read(showLoading.notifier).value = true;
              authenticateLinkedin(ref: ref);
            },
          ),
          LoginButton(
            text: "Continue with Google",
            icon: 'assets/google_logo.svg',
            isVisible: true,
            onPressed: () async {
              await signInWithGoogle();
              ref.read(userLoggedIn.notifier).value = true;
            },
          ),
          LoginButton(
            text: "Continue with Github",
            icon: 'assets/github_logo.svg',
            onPressed: () async {
              ref.read(showLoading.notifier).value = true;
              signInWithGitHub().whenComplete(
                () {
                  ref.read(userLoggedIn.notifier).value = true;
                  ref.read(showLoading.notifier).value = false;
                },
              );
            },
          ),
          LoginButton(
            text: "Continue with Anonymous",
            icon: 'assets/anonymous.svg',
            isVisible: anonymousLogin,
            onPressed: () async {
              await FirebaseAuth.instance.signInAnonymously();
              if (onLoginAnonymousButtonPressed != null) {
                onLoginAnonymousButtonPressed!();
              }
            },
          ),
          const SizedBox(height: 21),
          const LinedText(text: "OR"),
          const SizedBox(height: 21),
          LoginTextField(header: "Email", controller: emailController),
          const SizedBox(height: 12),
          LoginTextField(header: "Password", controller: passwordController),
          const SizedBox(height: 35),
          LongButton(
            text: "Log In",
            onTap: () {
              signInWithEmail(
                context: context,
                email: emailController.text,
                password: passwordController.text,
              );
            },
          ),
          const SizedBox(height: 58),
          TextAndClickableText(
            onTap: () {
              //TODO go signUp page
            },
            text1: "Don’t have an account?",
            text2: "Sign up for free",
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF3772FF),
        fontSize: 30,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class LongButton extends StatelessWidget {
  const LongButton({super.key, this.onTap, this.text});

  final void Function()? onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        width: 464,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF3772FF),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        alignment: Alignment.center,
        child: Text(
          text ?? "",
          style: const TextStyle(
            color: Color(0xFFF9F9F9),
            fontSize: 16,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            height: 1.10,
          ),
        ),
      ),
    );
  }
}

class LinedText extends StatelessWidget {
  const LinedText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 182,
          child: Divider(
            color: Color(0x7F404040),
            thickness: 1.1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF080708),
              fontSize: 14,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 1.40,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(
          width: 182,
          child: Divider(
            color: Color(0x7F404040),
            thickness: 1.1,
          ),
        ),
      ],
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.header,
    required this.controller,
    this.obscureText = false,
  });

  final String header;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '* ',
                style: TextStyle(
                  color: Color(0xFFD95858),
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
              TextSpan(
                text: header,
                style: const TextStyle(
                  color: Color(0xFF080708),
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 41,
          child: TextFormField(
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: _customBorder(),
              enabledBorder: _customBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _customBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF3772FF), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }
}

class TextAndClickableText extends StatelessWidget {
  const TextAndClickableText({
    super.key,
    this.onTap,
    required this.text1,
    required this.text2,
  });
  final String text1;
  final String text2;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text1,
          style: const TextStyle(
            color: Color(0x99080708),
            fontSize: 16,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
            height: 1.40,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            text2,
            style: const TextStyle(
              color: Color(0xFF3772FF),
              fontSize: 16,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 1.40,
            ),
          ),
        ),
      ],
    );
  }
}
