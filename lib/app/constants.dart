import 'package:flutter/material.dart';

const Color primaryColor = Colors.white;
const Color redColor = Colors.red;
const Color secondaryColor = Color(0xff25211f);
const Color greenColor = Color(0xff07B176);
const Color blueColor = Color(0xff41B7FA);
const Color limeColor = Color(0xffDED796);
const Color darkBgColor = Color(0xff2C2828);

const Color textColor = Color(0xff987544);
const Color buttonColor = Color(0xffbb86fc);
const Color borderColor = Color.fromRGBO(255, 255, 255, 0.59);

const LinearGradient buttonGradient = LinearGradient(colors: [
  Color(0xff414F33),
  Color(0xff382721),
]);
const LinearGradient appBarGradient = LinearGradient(
  stops: [0.05, 0.33, 0.6, 0.92],
  colors: [
    Color(0xff0F100D),
    Color(0xff141917),
    Color(0xff171818),
    Color(0xff251915)
  ],
);
const LinearGradient borderGradient = LinearGradient(
  stops: [0.05, 0.47, 0.89],
  colors: [Color(0xff957040), Color(0xffDED796), Color(0xffA37944)],
);

const double defaultPadding = 16;
const double defaultSpacing = 16;
const double defaultRadius = 16;

const String verticalLogo = "assets/images/logo.png";
const String bgImage1 = "assets/images/bg1.png";

const List<int> defaultIntervals = [1000, 3000, 5000, 10000, 30000, 60000];

final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp pswdValidatorRegExp =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
final RegExp phoneValidatorRegExp = RegExp(r'^\d{10}$');
final RegExp otpValidatorRegExp = RegExp(r'^\d{6}$');
final RegExp panValidatorRegExp = RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$");
final RegExp gstValidatorRegExp =
    RegExp(r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$");

const mBackgroundColor = Color(0xFF030E1E);
const mBlueColor = Color(0xFF006df0);
const mGreyColor = Color(0xFFB4B0B0);
const mGreyColor2 = Color(0xFFD9D9D9);
const mTitleColor = Color(0xFF23374D);
const mSubtitleColor = Color(0xFF8E8E8E);
const mBorderColor = Color(0xFFE8E8F3);
const mFillColor = Color(0xffF1F0F5);
const mFillColor2 = Color(0xfff2f2f2);
const mCardTitleColor = Color(0xFF2E4ECF);
const mCardSubtitleColor = mTitleColor;

// const mTextColor = Color(0xFFBE1335);
const mTextColor2 = Color(0xFF504F4F);
const mHintTextColot = Color(0xFF5A6881);

const Color mBlackColor = Colors.black;
const Color mWhiteColor = Colors.white;

const Color mTransparent = Colors.transparent;

const mLightPrimaryColor = Color(0xFFf6f6f6);
Color mPrimaryColor = Color(0xFFBE1335);
const mSecondaryColor = Color(0xffaf0003);
const mSuccessColor = Color(0xff20923D);
const mErrorColor = Color(0xffE50001);
const mPendingColor = Colors.orange;
