import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../utils/utilities.dart';
import '../constants/constants.dart';

class UsagePolicyPage extends StatelessWidget {
  const UsagePolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Intl.message("usagePolicyTitle"),
          style: const  TextStyle(
            color: ColorConstants.appbarTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorConstants.appbarBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: Intl.message("usagePolicySubTitle"),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.themeColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              Intl.message("usagePolicyExplain"),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _buildUsageTitle(Intl.message("usagePolicy1Title")),
            const SizedBox(height: 10),
            _buildUsageContent(Intl.message("usagePolicy1Content")),
            const SizedBox(height: 40),
            _buildUsageTitle(Intl.message("usagePolicy2Title")),
            const SizedBox(height: 10),
            _buildUsageContent(Intl.message("usagePolicy2Content")),
            const SizedBox(height: 40),
            _buildUsageTitle(Intl.message("usagePolicy3Title")),
            const SizedBox(height: 10),
            _buildUsageContent(Intl.message("usagePolicy3Content")),
            const SizedBox(height: 40),
            _buildUsageTitle(Intl.message("usagePolicy4Title")),
            const SizedBox(height: 10),
            _buildUsageContent(Intl.message("usagePolicy4Content")),
            const SizedBox(height: 40),
            _buildUsageTitle(Intl.message("usagePolicy5Title")),
            const SizedBox(height: 10),
            _buildUsageContent(Intl.message("usagePolicy5Content")),
            const SizedBox(height: 40),
            _buildUsageTitle(Intl.message("usagePolicy6Title")),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: Intl.message("usagePolicy6Content1"),
                    style: const TextStyle(
                        fontSize: 16,
                        color: ColorConstants.thickGreyColor
                    ),
                  ),
                  TextSpan(
                    text: Intl.message("usagePolicy6Content2"),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Utilities.launchURL(AppConstants.openAIUsagePolicy);
                      },
                  ),
                  TextSpan(
                    text: Intl.message("usagePolicy6Content3"),
                    style: const TextStyle(
                        fontSize: 16,
                        color: ColorConstants.thickGreyColor
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // More Text Widgets for other paragraphs or sections could go here.
          ],
        ),
      ),
    );
  }

  Widget _buildUsageTitle(String text){
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUsageContent(String text){
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16,
          color: ColorConstants.thickGreyColor
      ),
    );
  }

}
