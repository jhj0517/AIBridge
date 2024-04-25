import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:aibridge/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import 'widgets/character_creation_background.dart';
import 'widgets/text_fileds/prompt_box.dart';
import 'widgets/text_fileds/palm_prompt_box.dart';
import 'widgets/text_fileds/name_enter_box.dart';
import 'widgets/bottom_buttons/import_character_button.dart';
import 'widgets/model_dropdown.dart';
import 'widgets/temperature_slider.dart';
import 'widgets/appbar/character_creation_app_bar.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';


class CharacterCreationPage extends StatefulWidget {
  const CharacterCreationPage({Key? key, required this.arguments}) : super(key: key);

  final CharacterCreationPageArguments arguments;

  @override
  CharacterCreationState createState() => CharacterCreationState();
}

class CharacterCreationState extends State<CharacterCreationPage> {

  late CharactersProvider characterProvider;
  late ChatRoomsProvider chatRoomsProvider;

  TextEditingController _textFieldControllerName = TextEditingController();
  List<TextEditingController> _textFieldControllersSystemPrompts = [TextEditingController()];
  TextEditingController _textFieldControllerPaLMContext = TextEditingController();
  TextEditingController _textFieldControllerPaLMExampleInput = TextEditingController();
  TextEditingController _textFieldControllerPaLMExampleOutput = TextEditingController();
  TextEditingController _textFieldControllerYourName = TextEditingController();
  TextEditingController _textFieldControllerFirstMessage = TextEditingController();
  TextEditingController _textFieldControllerImport = TextEditingController();
  double _currentTemperature = 0;

  bool _isDoneButtonEnabled=false;

  Uint8List? _selectedProfileImageBLOB;
  Uint8List? _selectedBackgroundImageBLOB;

  final List<String> models= [...OpenAIService.openAIModels, ...PaLMService.paLMModels];
  late String? _selectedModel;

  @override
  void initState() {
    characterProvider = context.read<CharactersProvider>();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CharacterCreationBackground(backgroundImageBLOB: _selectedBackgroundImageBLOB),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CharacterCreationAppBar(
            isNewChar: widget.arguments.character.characterName.isEmpty,
            onBack: () { Navigator.pop(context); },
            onDone: () async { await _onDone(); },
            enableDone: _isDoneButtonEnabled,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ProfilePicture(
                            width: 100,
                            height: 100,
                            imageBLOBData: _selectedProfileImageBLOB,
                            onPickImage: () async {
                              final data = await _getImageFromGallery();
                              if(data!=null){
                                setState(() {
                                  _selectedProfileImageBLOB = data;
                                });
                              }
                            },
                            isMutable: true
                          ),
                          const SizedBox(height: 5),
                          NameEnterBox(
                              label: Intl.message("name"),
                              hint: Intl.message("characterNameHint"),
                              controller: _textFieldControllerName
                          ),
                          const SizedBox(height: 20),
                          ModelsDropdown(
                            models: models,
                            selectedModel: _selectedModel!,
                            onModelSelected: (newModel) => setState(() => _selectedModel = newModel)
                          ),
                          const SizedBox(height: 20),
                          TemperatureSlider(
                            serviceType: _getServiceType(_selectedModel!),
                            onTemperatureChange: (value) {
                              _currentTemperature = value;
                              setState(() {});
                            },
                            initialTemperature: _currentTemperature,
                          ),
                          const SizedBox(height: 20),
                          // Different UI by Service
                          if (OpenAIService.openAIModels.contains(_selectedModel)) ...[
                            _buildOpenAIPromptsListView(),
                            const SizedBox(height: 15),
                          ] else if (PaLMService.paLMModels.contains(_selectedModel)) ... [
                            PromptBox(
                                labelText: Intl.message("paLMContextPromptLabel"),
                                hintText: Intl.message("paLMContextPromptHint"),
                                controller: _textFieldControllerPaLMContext
                            ),
                            const SizedBox(height: 15),
                            PaLMPromptBox(
                              inputExampleController: _textFieldControllerPaLMExampleInput,
                              outputExampleController: _textFieldControllerPaLMExampleOutput
                            )
                          ],
                          const SizedBox(height: 20),
                          NameEnterBox(
                            label: Intl.message("characterRecognizeUserName"),
                            hint: Intl.message("characterRecognizeUserNameHint"),
                            controller: _textFieldControllerYourName
                          ),
                          const SizedBox(height: 20),
                          PromptBox(
                            labelText: Intl.message("firstMessageLabel"),
                            hintText: Intl.message("firstMessageHint"),
                            controller: _textFieldControllerFirstMessage
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    // Add your other widgets, such as text fields, buttons, etc., below this line
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.white,
                  thickness: 0.3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BackGroundButton(
                    onPressed: () async {
                      final data = await _getImageFromGallery();
                      if(data!=null){
                        setState(() {
                          _selectedBackgroundImageBLOB = data;
                        });
                      }
                    }
                  ),
                  ImportCharacterButton(
                    onPressed: () async => await _handleImport()
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textFieldControllerName.dispose();
    for (var controller in _textFieldControllersSystemPrompts) {
      controller.dispose();
    }
    _textFieldControllerPaLMContext.dispose();
    _textFieldControllerPaLMExampleInput.dispose();
    _textFieldControllerPaLMExampleOutput.dispose();
    _textFieldControllerYourName.dispose();
    _textFieldControllerFirstMessage.dispose();
    _textFieldControllerImport.dispose();
    super.dispose();
  }

  void _init() {
    final service = widget.arguments.character.service;
    switch (service.serviceType) {
      case ServiceType.openAI:
        _handleOpenAIService(service as OpenAIService);
        break;
      case ServiceType.paLM:
        _handlePaLMService(service as PaLMService);
        break;
      default:
        throw Exception('Unknown service type: $service.serviceType');
    }

    _textFieldControllerName = TextEditingController(text: widget.arguments.character.characterName);
    _textFieldControllerYourName = TextEditingController(text: widget.arguments.character.userName);
    _textFieldControllerFirstMessage = TextEditingController(text: widget.arguments.character.firstMessage);

    _selectedProfileImageBLOB = widget.arguments.character.photoBLOB;
    _selectedBackgroundImageBLOB = widget.arguments.character.backgroundPhotoBLOB;

    _isDoneButtonEnabled = _textFieldControllerName.text.isNotEmpty;
    _textFieldControllerName.addListener(() {
      setState(() {
        _isDoneButtonEnabled = _textFieldControllerName.text.isNotEmpty;
      });
    });
  }

  void _handleOpenAIService(OpenAIService service) {
    if (service.systemPrompts.isNotEmpty) {
      _textFieldControllersSystemPrompts.clear();
      for (final systemPrompt in service.systemPrompts) {
        _textFieldControllersSystemPrompts.add(TextEditingController(text: systemPrompt));
      }
    }
    setState(() {
      _selectedModel = service.modelName;
      _currentTemperature = service.temperature;
    });
  }

  void _handlePaLMService(PaLMService service) {
    _textFieldControllerPaLMContext = TextEditingController(text: service.context ?? "");
    setState(() {
      _selectedModel = service.modelName;
      _currentTemperature = service.temperature;
      _textFieldControllerPaLMContext.text = service.context;
      _textFieldControllerPaLMExampleInput.text = service.exampleInput;
      _textFieldControllerPaLMExampleOutput.text = service.exampleOutput;
    });
  }

  Widget _buildOpenAIPromptsListView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < _textFieldControllersSystemPrompts.length; index++)
          PromptBox(
            labelText: index == 0 ? Intl.message("description") : Intl.message("systemPrompt"),
            hintText: index == 0 ? Intl.message("descriptionHint") : Intl.message("systemPromptHint"),
            controller: _textFieldControllersSystemPrompts[index],
            index: index,
            onRemove: (index) { _removePromptField(index); },
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ), // Circular shape
                fixedSize: const Size(30, 30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _textFieldControllersSystemPrompts.add(TextEditingController());
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoneButton() {
    Color textColor = _isDoneButtonEnabled ? Colors.white : Colors.white38;
    return TextButton(
      onPressed: _isDoneButtonEnabled
      ? () async {
        await _onDone();
      }
      : null,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: Text(
        Intl.message("done"),
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<Uint8List?> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image==null){
      debugPrint('No image selected.');
      return null;
    }

    final mimeType = lookupMimeType(image.path);
    if (mimeType != null && !mimeType.startsWith('image/gif')) { //check if image is gif
      final File imageFile = File(image.path);
      final File compressedImageFile = await ImageConverter.compressImage(imageFile);
      Uint8List BLOB = await ImageConverter.convertImageToBLOB(compressedImageFile);
      return BLOB;
    } else {
      Fluttertoast.showToast(msg: Intl.message("notSupportedImage"));
      return null;
    }
  }

  Future<void> _handleImport() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final mimeType = lookupMimeType(image.path);
    if (mimeType == null || !mimeType.startsWith('image/gif')) {
      final imageFile = File(image.path);
      final character = await ChunkManager.decodeCharacter(pickedFile: imageFile);

      if (character == null) {
        Fluttertoast.showToast(msg: Intl.message("failedToImport"));
        return;
      }

      final compressedImageFile = await ImageConverter.compressImage(imageFile);
      final compressedBLOB = await ImageConverter.convertImageToBLOB(compressedImageFile);

      _updateCharacter(character: character, image: compressedBLOB);
    } else {
      Fluttertoast.showToast(msg: Intl.message("toastSelectStaticImage"));
    }
  }

  void _updateCharacter({
    required Character character,
    required Uint8List image
  }) async {
    setState(() {
      _textFieldControllerName.text = character.characterName;
      _selectedBackgroundImageBLOB = character.backgroundPhotoBLOB;
      _selectedProfileImageBLOB = image;
      _textFieldControllerYourName.text = character.userName;
      _textFieldControllerFirstMessage.text = character.firstMessage;

      if (character.service.serviceType == ServiceType.openAI) {
        final openAIService = character.service as OpenAIService;
        _selectedModel = openAIService.modelName;

        _textFieldControllersSystemPrompts.clear();
        for (final systemPrompt in openAIService.systemPrompts) {
          final controller = TextEditingController(text: systemPrompt);
          _textFieldControllersSystemPrompts.add(controller);
        }
      }
      _textFieldControllerImport.text = "";
    });
  }

  void _onTemperatureChanged(double temperature){
    _currentTemperature = temperature;
  }

  void _removePromptField(int index){
    setState(() {
      _textFieldControllersSystemPrompts.removeAt(index);
    });
  }

  Future<void> _onDone() async {
    if (Utilities.isKeyboardShowing(context)) {
      Utilities.closeKeyboard(context);
    }
    _selectedBackgroundImageBLOB!.isEmpty ?
    _selectedBackgroundImageBLOB = await ImageConverter.convertAssetImageToBLOB(
        PathConstants.defaultCharacterBackgroundImage
    )
    : Uint8List(0);

    final newCharacter = Character(
        id: widget.arguments.character.id,
        photoBLOB: _selectedProfileImageBLOB!,
        backgroundPhotoBLOB: _selectedBackgroundImageBLOB!,
        characterName: _textFieldControllerName.text,
        userName: _textFieldControllerYourName.text,
        firstMessage: _textFieldControllerFirstMessage.text,
        service: _getServiceData()
    );
    await characterProvider.insertOrUpdateCharacter(newCharacter);
    if(newCharacter.firstMessage.isNotEmpty){
      // This only insert first Message if chatroom doesn't exist
      final firstChatRoom = ChatRoom.newChatRoom(newCharacter);
      final firstMessage = ChatMessage.firstMessage(firstChatRoom.id!, newCharacter.id!, _textFieldControllerFirstMessage.text);
      await characterProvider.insertFirstMessage(newCharacter, firstMessage);
    }

    if(widget.arguments.character.id != null){
      await characterProvider.updateCurrentCharacter(widget.arguments.character.id!);
    }
    await chatRoomsProvider.updateChatRooms();

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  ServiceType _getServiceType(String modelName){
    if (OpenAIService.openAIModels.contains(modelName)){
      return ServiceType.openAI;
    }
    if (PaLMService.paLMModels.contains(modelName)){
      return ServiceType.paLM;
    }
    else { throw Exception("No supported service"); }
  }

  IService _getServiceData(){
    if (OpenAIService.openAIModels.contains(_selectedModel)){
      List<String> _systemPrompts = [];
      for (final (index, controller) in _textFieldControllersSystemPrompts.indexed) {
        _systemPrompts.add(controller.text);
      }
      return OpenAIService(
          characterId: widget.arguments.character.id!,
          modelName: _selectedModel!,
          temperature: _currentTemperature,
          systemPrompts: _systemPrompts,
      );
    } else if (PaLMService.paLMModels.contains(_selectedModel)){
      return PaLMService(
          characterId: widget.arguments.character.id!,
          modelName: _selectedModel!,
          context: _textFieldControllerPaLMContext.text,
          exampleInput: _textFieldControllerPaLMExampleInput.text,
          exampleOutput: _textFieldControllerPaLMExampleOutput.text,
          temperature: _currentTemperature,
          candidateCount: 1
      );
    } else {
      throw Exception("Service not found $_selectedModel");
    }
  }

}

class CharacterCreationPageArguments {
  final Character character;

  CharacterCreationPageArguments({required this.character});
}
