import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/path_constants.dart';
import '../../../models/models.dart';

class ImportCharacterButton extends StatelessWidget {
  final Future<void> Function() onPressed;

  const ImportCharacterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 80,
        width: 80,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                Intl.message("import"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelsDropdown extends StatefulWidget {
  final List<String> models; // List of available models
  final String selectedModel; // Currently selected model
  final Function(String)? onModelSelected; // Callback for handling model selection

  const ModelsDropdown({
    Key? key,
    required this.models,
    required this.selectedModel,
    this.onModelSelected,
  }) : super(key: key);

  @override
  _ModelsDropdownState createState() => _ModelsDropdownState();
}

class _ModelsDropdownState extends State<ModelsDropdown> {
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
    if (OpenAIService.openAIModels.contains(optionName)) {
      imagePath = PathConstants.chatGPTImage;
    } else if (PaLMService.paLMModels.contains(optionName)) {
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

