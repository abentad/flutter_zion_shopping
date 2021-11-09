import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);
  final double spacer = 300.0;

  final onboardingPagesList = [
    PageModel(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300.0,
            padding: const EdgeInsets.only(bottom: 45.0),
            // child: Image.asset('assets/images/facebook.png', color: pageImageColor),
          ),
          const SizedBox(width: double.infinity, child: Text('SECURED BACKUP', style: pageTitleStyle)),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Keep your files in closed safe so you can\'t lose them',
              style: pageInfoStyle,
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 300.0),
          // Image.asset('assets/images/twitter.png', color: pageImageColor),
          Text('CHANGE AND RISE', style: pageTitleStyle),
          Text(
            'Give others access to any file or folder you choose',
            style: pageInfoStyle,
          )
        ],
      ),
    ),
    PageModel(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 300.0),
          // Image.asset('assets/images/instagram.png', color: pageImageColor),
          Text('EASY ACCESS', style: pageTitleStyle),
          Text(
            'Reach your files anytime from any devices anywhere',
            style: pageInfoStyle,
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        proceedButtonStyle: ProceedButtonStyle(
          proceedButtonRoute: (context) {
            // return Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Container(),
            //   ),
            //   (route) => false,
            // );
          },
        ),
        pages: onboardingPagesList,
        indicator: Indicator(
          indicatorDesign: IndicatorDesign.line(
            lineDesign: LineDesign(
              lineType: DesignType.line_uniform,
            ),
          ),
        ),
        //-------------Other properties--------------
        // Color background,
        //EdgeInsets pagesContentPadding
        //EdgeInsets titleAndInfoPadding
        //EdgeInsets footerPadding
        //SkipButtonStyle skipButtonStyle
      ),
    );
  }
}
