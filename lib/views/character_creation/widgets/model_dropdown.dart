import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/constants/constants.dart';
import 'package:aibridge/models/models.dart';

class ModelsDropdown extends StatefulWidget {
  final List<String> models;
  final String selectedModel;
  final Function(String)? onModelSelected;

  const ModelsDropdown({
    Key? key,
    required this.models,
    required this.selectedModel,
    this.onModelSelected,
  }) : super(key: key);

  @override
  ModelsDropdownState createState() => ModelsDropdownState();
}

class ModelsDropdownState extends State<ModelsDropdown> {
  late String _currentModel;

  @override
  void initState() {
    super.initState();
    _currentModel = widget.selectedModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8, left: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<String>(
        value: _currentModel,
        hint: Text(Intl.message("selectModel")),
        onChanged: (String? newModel) {
          setState(() {
            _currentModel = newModel!;
            // I should call setState() on "Parent" page after this.
            widget.onModelSelected?.call(newModel);
          });
        },
        items: widget.models.map<DropdownMenuItem<String>>((value) {
          return _buildDropdownOption(value);
        }).toList(),
        underline: const SizedBox.shrink(),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownOption(String optionName) {
    String imagePath = "";
    if (OpenAIPlatform.openAIModels.contains(optionName)) {
      imagePath = PathConstants.chatGPTImage;
    } else if (PaLMPlatform.paLMModels.contains(optionName)) {
      imagePath = PathConstants.paLMImage;
    }
    return DropdownMenuItem<String>(
      value: optionName,
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Text(optionName),
        ],
      ),
    );
  }
}
