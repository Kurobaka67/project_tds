import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';
import 'package:project_transdata/screens/login_page.dart';
import 'package:project_transdata/screens/main_page.dart';
import 'package:project_transdata/services/users_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/widgets.dart';

const _animationDuration = Duration(milliseconds: 500);
const _padding = 20.0;

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({
    super.key,
  });

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _modeChangeController;

  late List<PasscodeDigit> _passcodeDigitValues;
  var _currentInputIndex = 0;

  var _passcodeAnimationInProgress = false;

  bool get _isAnimating =>
      _modeChangeController.isAnimating || _passcodeAnimationInProgress;

  @override
  void initState() {
    super.initState();

    _modeChangeController = AnimationController(
      duration: _animationDuration * 2,
      vsync: this,
    )..addListener(() => setState(() {}));

    _resetDigits();
  }

  @override
  void dispose() {
    _modeChangeController.dispose();

    super.dispose();
  }

  void _onDigitSelected(int index, {bool autovalidate = false}) {
    if (_isAnimating) return;


    final digitValue = _passcodeDigitValues[_currentInputIndex];
    
    setState(() {
      _passcodeDigitValues[_currentInputIndex++] = digitValue.copyWith(
        value: RotaryDialConstants.inputValues[index],
      );
    });

    if (autovalidate) _validatePasscode();
  }

  Future<void> onDigitDelete() async{
    if (_isAnimating) return;


    if(_currentInputIndex > 0) {
      _currentInputIndex--;
      setState(() {
        _passcodeDigitValues[_currentInputIndex].value = null;
      });
    }
  }

  Future<void> onSuccess() async {
    SharedPreferencesAsync? prefs = SharedPreferencesAsync();
    await prefs.setBool('admin', true);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage()));
  }

  void onError() {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _resetDigits() => setState(() {
        _currentInputIndex = 0;
        _passcodeDigitValues = List.generate(
          5,
          (index) => PasscodeDigit(
            backgroundColor: Colors.white,
            fontColor: Colors.black,
          ),
          growable: false,
        );
      });

  Future<void> _validatePasscode() async {
    if (_isAnimating) return;



    if (_currentInputIndex != 5) return;

    final interval = _animationDuration.inMilliseconds ~/ 5;
    final codeInput = _passcodeDigitValues.fold<String>(
      '',
      (code, element) => code += element.value?.toString() ?? '',
    );

    _togglePasscodeAnimation();

    final verify = (await UsersService().verify(codeInput));

    if (verify) {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        interval: interval,
      );

      await Future.delayed(const Duration(milliseconds: 1000));
      onSuccess();
    } else {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        interval: interval,
      );
      await Future.delayed(const Duration(seconds: 1));
      await _changePasscodeDigitColors(
        backgroundColor: Colors.white,
        fontColor: Colors.black,
        interval: interval,
      );

      await Future.delayed(const Duration(milliseconds: 1000));
      onError();
    }

    await Future.delayed(_animationDuration);
    _resetDigits();
    _togglePasscodeAnimation();
  }

  Future<void> _changePasscodeDigitColorById({
    Color? backgroundColor,
    Color? fontColor,
    int interval = 0,
    required int id,
  }) async {
    await Future.delayed(Duration(milliseconds: interval));

    setState(() {
      if (backgroundColor != null) {
        _passcodeDigitValues[id] = _passcodeDigitValues[id].copyWith(
          backgroundColor: backgroundColor,
        );
      }

      if (fontColor != null) {
        _passcodeDigitValues[id] = _passcodeDigitValues[id].copyWith(
          fontColor: fontColor,
        );
      }
    });
  }

  Future<void> _changePasscodeDigitColors({
    Color? backgroundColor,
    Color? fontColor,
    int interval = 0,
  }) async {
    for (var i = 0; i < _passcodeDigitValues.length; i++) {
      await Future.delayed(Duration(milliseconds: interval));

      setState(() {
        if (backgroundColor != null) {
          _passcodeDigitValues[i] = _passcodeDigitValues[i].copyWith(
            backgroundColor: backgroundColor,
          );
        }

        if (fontColor != null) {
          _passcodeDigitValues[i] = _passcodeDigitValues[i].copyWith(
            fontColor: fontColor,
          );
        }
      });
    }
  }

  void _togglePasscodeAnimation() => setState(
        () => _passcodeAnimationInProgress = !_passcodeAnimationInProgress,
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _padding,
            _padding * 3,
            _padding,
            _padding * 2,
          ),
          child: LocalHeroScope(
            curve: Curves.easeInOut,
            duration: _animationDuration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Entrer\nle code'.toUpperCase(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 32.0),
                Align(
                  alignment: Alignment.center,
                  child: PasscodeDigits(
                    animationDuration: _animationDuration,
                    passcodeDigitValues: _passcodeDigitValues,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: PasscodeInput(
                          onDigitSelected: (index) => _onDigitSelected(
                            index,
                            autovalidate: true,
                          ),
                        )
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Retour', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20,)),
                        )
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: ClipPath(
                        clipper: ArrowClipper(),
                        child: TextButton(
                            onPressed: () {
                              onDigitDelete();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Icon(Icons.clear, color: theme.colorScheme.onPrimary, size: 30,),
                            )
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    double arrowWidth = size.height / 2; // Adjust the proportion of arrow height

    path.lineTo(size.width, 0.0);
    path.lineTo(arrowWidth, 0.0);
    path.lineTo(0.0, size.height / 2);
    path.lineTo(arrowWidth, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    /*path.lineTo(size.width - arrowWidth, 0.0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - arrowWidth, size.height);
    path.lineTo(0.0, size.height);
    path.close();*/


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
