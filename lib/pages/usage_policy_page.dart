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
            ..._buildUsagePolicySections(),
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

  List<Widget> _buildUsagePolicySections() {
    final items = <Widget>[];
    for (var i = 1; i <= 5; i++) {
      final title = Intl.message("usagePolicy${i}Title");
      final content = Intl.message("usagePolicy${i}Content");
      items.add(_buildUsagePolicySection(title: title, content: content));
      items.add(const SizedBox(height: 40.0));
    }

    return items;
  }

  Widget _buildUsagePolicySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUsageTitle(title),
        const SizedBox(height: 10.0),
        _buildUsageContent(content),
      ],
    );
  }

}
