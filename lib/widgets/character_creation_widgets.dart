import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/color_constants.dart';
import '../constants/path_constants.dart';
import '../models/models.dart';

class ProfilePicture extends StatelessWidget {
  final double width;
  final double height;
  final Future<void> Function()? onPickImage;
  final Uint8List? imageBLOBData;
  final bool? isMutable;

  const ProfilePicture({
    super.key,
    required this.width,
    required this.height,
    this.imageBLOBData,
    this.onPickImage,
    this.isMutable,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            clipBehavior: Clip.hardEdge,
            child: imageBLOBData?.isNotEmpty ?? false
            ? SizedBox(
              width: width,
              height: height,
              child: Image.memory(
                imageBLOBData!,
                fit: BoxFit.cover,
                errorBuilder: (context, object, stackTrace) {
                  return Icon(
                    Icons.account_circle_rounded,
                    size: width,
                    color: ColorConstants.greyColor,
                  );
                },
              ),
            )
            : Icon(
              Icons.account_circle_rounded,
              size: width,
              color: ColorConstants.greyColor,
            ),
          ),
        ),
        isMutable != null && isMutable!
        ? Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => onPickImage!(),
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.photo_library,
              color: ColorConstants.primaryColor,
            ),
          ),
        )
        : const SizedBox.shrink()
      ],
    );
  }
}


class PromptField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final int? index;
  final Function(int index)? onRemove;

  const PromptField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.index,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              scrollPhysics: const BouncingScrollPhysics(),
              cursorColor: Colors.white,
              maxLines: null, // unlimited lines
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w300,
                ),
                hintMaxLines: 10,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: labelText,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                counterStyle: const TextStyle(color: Colors.white),
                suffixIcon: index != null
                ? IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  onPressed: () => onRemove!(index!),
                )
                : null,
              ),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }
}

class PaLMExamplePromptFields extends StatelessWidget {
  final TextEditingController inputExampleController;
  final TextEditingController outputExampleController;

  const PaLMExamplePromptFields({
    super.key,
    required this.inputExampleController,
    required this.outputExampleController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.white, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  Intl.message("paLMExamplePromptLabel"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  Intl.message("paLMExamplePromptHint"),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 10),
            child: PromptField(
              labelText:  Intl.message("paLMExampleInputLabel"),
              hintText: Intl.message("paLMExampleInputHint"),
              controller: inputExampleController
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 10),
            child: PromptField(
                labelText:  Intl.message("paLMExampleOutputLabel"),
                hintText: Intl.message("paLMExampleOutputHint"),
                controller: outputExampleController
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class NameEnteringField extends StatelessWidget {

  final String label;
  final String hint;
  final TextEditingController controller;

  const NameEnteringField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.w300,
        ),
        suffixIcon: const Icon(
          Icons.edit, // Pencil icon
          color: Colors.white,
          size: 18, // Adjust the size of the icon
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class TemperatureSlider extends StatefulWidget {
  final ServiceType serviceType;
  final double? initialTemperature;
  final Function(double) onTemperatureChange;

  const TemperatureSlider({
    super.key,
    required this.serviceType,
    required this.onTemperatureChange,
    this.initialTemperature
  });

  @override
  _TemperatureSliderState createState() => _TemperatureSliderState();
}

class _TemperatureSliderState extends State<TemperatureSlider> {
  double _currentTemperature = 0.0;

  @override
  void initState() {
    super.initState();
    _initDefault();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Intl.message("temperatureLabel"),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Slider.adaptive(
          value: _validateValue(_currentTemperature),
          min: 0.0,
          max: _initMax(),
          divisions: 200,
          label: _currentTemperature.toStringAsFixed(2),
          activeColor: Colors.white,
          inactiveColor: Colors.white60,
          onChanged: (value) {
            setState(() {
              _currentTemperature = value;
              widget.onTemperatureChange(value);
            });
          },
        ),
        Text(
          _currentTemperature.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  double _validateValue(double value){
    switch(widget.serviceType){
      case ServiceType.openAI:
        if (value>OpenAIService.maxTemperature){
          _currentTemperature = OpenAIService.defaultTemperature;
        }
      case ServiceType.paLM:
        if (value>PaLMService.maxTemperature){
          _currentTemperature = PaLMService.defaultTemperature;
        }
    }
    return _currentTemperature;
  }

  void _initDefault(){
    if (widget.initialTemperature != null){
      _currentTemperature = widget.initialTemperature!;
      return;
    }

    switch(widget.serviceType){
      case ServiceType.openAI:
        _currentTemperature = OpenAIService.defaultTemperature;
      case ServiceType.paLM:
        _currentTemperature = PaLMService.defaultTemperature;
    }
  }

  double _initMax(){
    switch(widget.serviceType){
      case ServiceType.openAI:
        return OpenAIService.maxTemperature;
      case ServiceType.paLM:
        return PaLMService.maxTemperature;
    }
  }
}

class BackGroundButton extends StatelessWidget {
  final Future<void> Function() onPressed;

  const BackGroundButton({
    super.key,
    required this.onPressed
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
                Icons.image, // Use any icon you want
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                Intl.message("background"),
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

