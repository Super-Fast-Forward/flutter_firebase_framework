part of flutter_firebase_framework;

final userLoggedIn = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

final showLoading = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
    (ref) => AuthStateNotifier<bool>(false));

final openEmailLogin = StateNotifierProvider<AuthStateNotifier<bool>, bool>(
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

class LogInWidget extends ConsumerWidget {
  const LogInWidget({
    super.key,
    this.termsAndConditionsPageUrl,
    required this.anonymousLogin,
    required this.githubLogin,
    required this.googleLogin,
    required this.linkedInLogin,
  });

  final bool anonymousLogin;
  final bool linkedInLogin;
  final bool googleLogin;
  final bool githubLogin;
  final String? termsAndConditionsPageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSignIn = ref.watch(openEmailLogin);
    return AutofillGroup(
      child: Container(
        constraints: const BoxConstraints(minWidth: 310),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: isSignIn
            ? SignUpWidget(
                anonymousLogin: anonymousLogin,
                githubLogin: githubLogin,
                googleLogin: googleLogin,
                linkedInLogin: linkedInLogin,
                termsAndConditionsPageUrl: termsAndConditionsPageUrl,
              )
            : SignInWidget(
                anonymousLogin: anonymousLogin,
                githubLogin: githubLogin,
                googleLogin: googleLogin,
                linkedInLogin: linkedInLogin,
              ),
      ),
    );
  }
}

class SignInWidget extends ConsumerWidget {
  const SignInWidget({
    super.key,
    required this.anonymousLogin,
    required this.githubLogin,
    required this.googleLogin,
    required this.linkedInLogin,
  });

  final bool anonymousLogin;
  final bool linkedInLogin;
  final bool googleLogin;
  final bool githubLogin;

  final bool isLocalPersistanceEnabled = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(showLoading)) {
      return const Center(child: CircularProgressIndicator());
    }

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Header(text: "Log in into your account"),
        const SizedBox(height: 30),
        SocialSignIn(
          anonymousLogin: anonymousLogin,
          githubLogin: githubLogin,
          googleLogin: googleLogin,
          linkedInLogin: linkedInLogin,
          isLocalPersistanceEnabled: isLocalPersistanceEnabled,
        ),
        const SizedBox(height: 21),
        const LinedText(text: "OR"),
        const SizedBox(height: 21),
        SizedBox(
          width: 464,
          child: Column(
            children: [
              LoginTextField(
                autofillHints: const [AutofillHints.username],
                header: "Email",
                controller: emailController,
                text: "email address",
              ),
              const SizedBox(height: 12),
              LoginPasswordTextField(controller: passwordController),
              const SizedBox(height: 14),
              RememberMe(provider: rememberMeSignIn),
              const SizedBox(height: 30),
              LongButton(
                text: "Log In",
                onTap: () {
                  ref.read(firebaseAuthProvider.notifier).signInWithEmail(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                },
              ),
              const SizedBox(height: 58),
              TextAndClickableText(
                onTap: () {
                  ref.read(openEmailLogin.notifier).value = true;
                  ref.read(showPasswordProvider.notifier).changeTheme(true);
                },
                text1: "Don’t have an account?",
                text2: "Sign up for free",
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SignUpWidget extends ConsumerWidget {
  const SignUpWidget({
    super.key,
    this.termsAndConditionsPageUrl,
    required this.anonymousLogin,
    required this.githubLogin,
    required this.googleLogin,
    required this.linkedInLogin,
  });

  final bool anonymousLogin;
  final bool linkedInLogin;
  final bool googleLogin;
  final bool githubLogin;
  final String? termsAndConditionsPageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(showLoading)) {
      return const Center(child: CircularProgressIndicator());
    }

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Header(text: "Create Your Free Account"),
        const SizedBox(height: 30),
        SocialSignIn(
          anonymousLogin: anonymousLogin,
          githubLogin: githubLogin,
          googleLogin: googleLogin,
          linkedInLogin: linkedInLogin,
        ),
        const SizedBox(height: 21),
        const LinedText(text: "OR"),
        const SizedBox(height: 21),
        SizedBox(
          width: 464,
          child: Column(
            children: [
              LoginTextField(
                autofillHints: const [AutofillHints.username],
                header: "Email",
                controller: emailController,
                text: "email address",
              ),
              const SizedBox(height: 12),
              LoginPasswordTextField(controller: passwordController),
              const SizedBox(height: 14),
              RememberMe(provider: rememberMeSignUp),
              const SizedBox(height: 30),
              LongButton(
                text: "Create Account",
                onTap: () {
                  ref.read(firebaseAuthProvider.notifier).signUpWithEmail(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                },
              ),
              const SizedBox(height: 16),
              TextAndClickableText(
                onTap: () async {
                  if (termsAndConditionsPageUrl != null) {
                    final Uri url = Uri.parse(
                      termsAndConditionsPageUrl ?? "",
                    );
                    await launchUrl(url);
                  }
                },
                text1: "By signing up I agree with Job Search Ninja’s",
                text2: "Terms and conditions.",
                style: const TextStyle(
                  color: Color(0xFF616161),
                  fontSize: 14,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                  letterSpacing: -0.28,
                ),
              ),
              const SizedBox(height: 23),
              TextAndClickableText(
                onTap: () {
                  ref.read(openEmailLogin.notifier).value = false;
                  ref.read(showPasswordProvider.notifier).changeTheme(true);
                },
                text1: "Already a user?",
                text2: "Log In",
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SocialSignIn extends ConsumerWidget {
  const SocialSignIn({
    super.key,
    required this.anonymousLogin,
    required this.githubLogin,
    required this.googleLogin,
    required this.linkedInLogin,
    isLocalPersistanceEnabled,
  });

  final bool anonymousLogin;
  final bool linkedInLogin;
  final bool googleLogin;
  final bool githubLogin;

  final bool isLocalPersistanceEnabled = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        LoginButton(
          text: "Continue with LinkedIn",
          icon: 'assets/linkedin_logo.svg',
          isVisible: linkedInLogin,
          onPressed: () {
            ref.read(linkedinAuthProvider.notifier).authenticateLinkedin();
          },
        ),
        LoginButton(
          text: "Continue with Google",
          icon: 'assets/google_logo.svg',
          isVisible: googleLogin,
          onPressed: () async {
            await ref.read(firebaseAuthProvider.notifier).signInWithGoogle(
                  localPersistanceEnabled: isLocalPersistanceEnabled,
                );
            ref.read(userLoggedIn.notifier).value = true;
          },
        ),
        LoginButton(
          text: "Continue with Github",
          icon: 'assets/github_logo.svg',
          isVisible: githubLogin,
          onPressed: () async {
            ref.read(showLoading.notifier).value = true;
            ref
                .read(firebaseAuthProvider.notifier)
                .signInWithGitHub()
                .whenComplete(
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
          },
        ),
      ],
    );
  }
}

class RememberMe extends ConsumerWidget {
  const RememberMe({
    required this.provider,
    super.key,
  });

  final AutoDisposeStateNotifierProvider<RememberMeProvider, bool> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.grey,
            value: ref.watch(provider),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            onChanged: (bool? value) {
              ref.read(provider.notifier).toggleRememberMe();
            },
          ),
        ),
        const SizedBox(width: 11),
        const Text(
          AppText.rememberMe,
          style: TextStyle(
            color: Color(0x99080708),
            fontSize: 16,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
        fontSize: 24,
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 464,
          ),
          child: const Divider(
            color: Color(0x7F404040),
            thickness: 1.1,
          ),
        ),
        Container(
          color: Colors.white,
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
      ],
    );
  }
}

class LoginPasswordTextField extends ConsumerWidget {
  const LoginPasswordTextField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool textObscure = ref.watch(showPasswordProvider);
    return LoginTextField(
      autofillHints: const [AutofillHints.password],
      header: AppText.password,
      controller: controller,
      text: AppText.password,
      icon: ObscureText(
        isVisible: textObscure,
        onTap: ref.read(showPasswordProvider.notifier).toggleTheme,
      ),
      obscureText: textObscure,
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.header,
    this.controller,
    this.obscureText = false,
    this.text,
    this.icon,
    this.autofillHints,
  });

  final String header;
  final bool obscureText;
  final String? text;
  final Widget? icon;
  final TextEditingController? controller;
  final Iterable<String>? autofillHints;

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
            autofillHints: autofillHints,
            decoration: InputDecoration(
              focusedBorder: _customBorder(),
              enabledBorder: _customBorder(),
              hintText: text,
              hintStyle: const TextStyle(
                color: Color(0xFF080708),
                fontSize: 14,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                height: 1.40,
                letterSpacing: -0.28,
              ),
              suffixIcon: icon,
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
    this.style,
  });

  final String text1;
  final String text2;
  final TextStyle? style;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Text(
            text1,
            style: _style(),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              text2,
              style: _styleBlue(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _style() {
    return style ??
        const TextStyle(
          color: Color(0x99080708),
          fontSize: 16,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
          height: 1.40,
        );
  }

  TextStyle _styleBlue() {
    return _style().copyWith(color: const Color(0xFF3772FF));
  }
}

class ObscureText extends StatelessWidget {
  const ObscureText({
    super.key,
    required this.isVisible,
    this.onTap,
  });

  final bool isVisible;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final String icon = isVisible ? AppIcons.closedEye : AppIcons.openedEye;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: SizedBox(
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.fitWidth,
            package: "auth",
          ),
        ),
      ),
    );
  }
}
