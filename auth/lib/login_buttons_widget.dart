part of flutter_firebase_auth;

const loginGitHub = "loginGitHub";
const loginGoogle = "loginGoogle";
const loginSSO = "loginSSO";
const loginEmail = "loginEmail";
const loginAnonymous = "loginAnonymous";
const signupOption = "signupOption";

bool showGoogleAuth = false;
bool showGitHubAuth = false;
bool showSsoAuth = false;
bool showEmailAuth = false;
bool showAnonymousAuth = false;
bool showSignupOption = false;

const borderColor = Color.fromARGB(255, 208, 208, 208);
const borderDecor = BoxDecoration(
  border: Border(
    right: BorderSide(
      color: borderColor,
    ),
  ),
);

final userLoggedIn = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

final showLoading = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

class LoginButtonsWidget extends ConsumerWidget {
  final String screenTitle;
  final Map<String, bool> loginOptions;

  ///Login Options:
  ///
  /// "**loginGitHub**" for Login via Github
  ///
  /// "**loginGoogle**" for Login via Google
  ///
  /// "**loginSSO**" for Login via SSO
  ///
  /// "**loginEmail**" for Login via Email
  ///
  /// "**loginAnonymous**" for Login as Anonymous user
  ///
  /// "**signupOption**"" for SignUp option
  ///
  const LoginButtonsWidget({
    required this.screenTitle,
    required this.loginOptions,
    Key? key,
  }) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  ElevatedButton imageButton(
      String title, String imageName, VoidCallback callback) {
    return ElevatedButton(
        onPressed: callback,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: borderDecor,
              margin: const EdgeInsets.only(right: 70),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset('/assets/$imageName.svg',
                    package: 'flutter_firebase_auth', width: 30, height: 30),
              ),
            ),
            SizedBox(width: 180, child: Text(title)),
          ],
        ));
  }

  ElevatedButton iconButton(
      String title, IconData iconData, VoidCallback callback) {
    return ElevatedButton(
      onPressed: callback,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            height: 50,
            width: 50,
            decoration: borderDecor,
            margin: const EdgeInsets.only(right: 70),
            child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: Icon(
                  iconData,
                  size: 30,
                  color: Colors.black,
                ))),
        SizedBox(width: 180, child: Text(title))
      ]),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(showLoading)) {
      return Center(
        child: Container(
          alignment: const Alignment(0.0, 0.0),
          child: const CircularProgressIndicator(),
        ),
      );
    }
    List<String> configFlags = [];

    //Separating all the "true" values from loginOptions
    loginOptions.forEach((key, value) {
      if (value == true) configFlags.add(key);
    });

    //Setting the flags
    setAuthOptions(configFlags);

    bool isWideScreen = MediaQuery.of(context).size.width >= 800;

    final ElevatedButton googleButton =
        imageButton("Log in with Google", "google_logo", () {
      signInWithGoogle().whenComplete(() {
        ref.read(userLoggedIn.notifier).value = true;
      });
    });

    final ElevatedButton githubButton =
        imageButton("Log in with Github", "github_logo", () async {
      ref.read(showLoading.notifier).value = true;
      await FirebaseAuth.instance.signInAnonymously().then((a) => {
            ref.read(userLoggedIn.notifier).value = true,
            ref.read(showLoading.notifier).value = false,
          });
    });

    final ElevatedButton ssoButton =
        iconButton("Log in with SSO", Icons.key, () {});

    final ElevatedButton emailButton =
        iconButton("Log in with Email", Icons.mail, () {});

    final ElevatedButton anonymousButton =
        iconButton("Log in Anonymous", Icons.account_circle, () async {
      // ref.read(isLoading.notifier).value = true;
      await FirebaseAuth.instance.signInAnonymously().then((a) => {
            //     ref.read(isLoggedIn.notifier).value = true,
            //     ref.read(isLoading.notifier).value = false,
          });
    });

    List<Widget> widgets = [
      Expanded(
        flex: isWideScreen ? 1 : 0,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 340,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      screenTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: showGoogleAuth,
                    child: Column(
                      children: [
                        const Gap(25),
                        SizedBox(width: double.infinity, child: googleButton),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showGitHubAuth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Gap(50),
                        SizedBox(width: double.infinity, child: githubButton),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: showSsoAuth,
                      child: Column(
                        children: [
                          const Gap(50),
                          SizedBox(width: double.infinity, child: ssoButton),
                        ],
                      )),
                  Visibility(
                    visible: showEmailAuth,
                    child: Column(
                      children: [
                        const Gap(50),
                        SizedBox(width: double.infinity, child: emailButton)
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showAnonymousAuth,
                    child: Column(
                      children: [
                        const Gap(50),
                        SizedBox(
                            width: double.infinity, child: anonymousButton),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showSignupOption,
                    child: Column(
                      children: [
                        const Gap(50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Don't have an account ? ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            InkWell(
                              //onTap: () => {print("Clicked")},
                              child: Text(
                                " Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.blueGrey),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(50),
                ],
              ),
            ),
          ),
        ),
      )
    ];

    return isWideScreen
        ? Flex(direction: Axis.horizontal, children: widgets)
        : SingleChildScrollView(
            child: Flex(
                direction: Axis.vertical, children: widgets.reversed.toList()));
  }

  void setAuthOptions(List config) {
    showGitHubAuth = config.contains(loginGitHub);
    showGoogleAuth = config.contains(loginGoogle);
    showEmailAuth = config.contains(loginEmail);
    showSsoAuth = config.contains(loginSSO);
    showAnonymousAuth = config.contains(loginAnonymous);
    showSignupOption = config.contains(signupOption);
  }
}
