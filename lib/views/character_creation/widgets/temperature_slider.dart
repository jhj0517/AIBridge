import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/models/models.dart';

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

