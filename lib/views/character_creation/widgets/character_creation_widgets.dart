import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/path_constants.dart';
import '../../../models/models.dart';


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
  TemperatureSliderState createState() => TemperatureSliderState();
}

class TemperatureSliderState extends State<TemperatureSlider> {
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

