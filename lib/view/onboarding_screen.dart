import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  //  final onboardingPagesList = [
  //         PageModel(
  //           widget: Column(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.only(bottom: 45.0),
  //                   child: Image.asset('assets/images/facebook.png',
  //                       color: pageImageColor)),
  //               Container(
  //                   width: double.infinity,
  //                   child: Text('SECURED BACKUP', style: pageTitleStyle)),
  //               Container(
  //                 width: double.infinity,
  //                 child: Text(
  //                   'Keep your files in closed safe so you can\'t lose them',
  //                   style: pageInfoStyle,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         PageModel(
  //           widget: Column(
  //             children: [
  //               Image.asset('assets/images/twitter.png', color: pageImageColor),
  //               Text('CHANGE AND RISE', style: pageTitleStyle),
  //               Text(
  //                 'Give others access to any file or folder you choose',
  //                 style: pageInfoStyle,
  //               )
  //             ],
  //           ),
  //         ),
  //         PageModel(
  //           widget: Column(
  //             children: [
  //               Image.asset('assets/images/instagram.png', color: pageImageColor),
  //               Text('EASY ACCESS', style: pageTitleStyle),
  //               Text(
  //                 'Reach your files anytime from any devices anywhere',
  //                 style: pageInfoStyle,
  //               ),
  //             ],
  //           ),
  //         ),
  //     ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // body: Onboarding(
        //         proceedButtonStyle: ProceedButtonStyle(
        //             proceedButtonRoute: (context) {
        //               return Navigator.pushAndRemoveUntil(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => Container(),
        //                 ),
        //                 (route) => false,
        //               );
        //             },
        //         ),
        //         isSkippable = true,
        //         pages: onboardingPagesList,
        //         indicator: Indicator(
        //           indicatorDesign: IndicatorDesign.line(
        //             lineDesign: LineDesign(
        //               lineType: DesignType.line_uniform,
        //             ),
        //           ),
        //         ),
        //         //-------------Other properties--------------
        //         //Color background,
        //         //EdgeInsets pagesContentPadding
        //         //EdgeInsets titleAndInfoPadding
        //         //EdgeInsets footerPadding
        //         //SkipButtonStyle skipButtonStyle
        //       ),
        );
  }
}
