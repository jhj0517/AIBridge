import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:aibridge/widgets/character_creation_widgets.dart';
import 'package:aibridge/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';


class CharacterCreationPage extends StatefulWidget {
  const CharacterCreationPage({Key? key, required this.arguments}) : super(key: key);

  final CharacterCreationPageArguments arguments;

  @override
  CharacterCreationState createState() => CharacterCreationState();
}

class CharacterCreationState extends State<CharacterCreationPage> {

  late ThemeProvider themeProvider;
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
    themeProvider = context.read<ThemeProvider>();
    characterProvider = context.read<CharactersProvider>();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.watch<ThemeProvider>();
    return Stack(
      children: [
        // Background placeholder image
        const SizedBox.expand(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(PathConstants.characterCreationPageBackgroundPlaceholderImage),
          ),
        ),
        // Background image
        Visibility(
          visible: _selectedBackgroundImageBLOB!.isNotEmpty,
          child: SizedBox.expand(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.memory(
                    _selectedBackgroundImageBLOB!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, object, stackTrace) {
                      return const SizedBox.expand(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(PathConstants.characterCreationPageBackgroundPlaceholderImage),
                        ),
                      );
                    },
                  )
              )
          ),
        ),
        // Apply a color filter on top of the background image
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make the Scaffold's background transparent
          appBar: AppBar(
            backgroundColor: themeProvider.attrs.appbarColor,
            elevation: 0, // Remove AppBar Shadow
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white, // Update the color of the back button to match the text color
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: widget.arguments.character.characterName.isEmpty
            ? Text(
              Intl.message("newCharacter"),
              style: const TextStyle(color: ColorConstants.appbarTextColor),
            )
            : Text(
              Intl.message("editCharacterOption"),
              style: const TextStyle(color: ColorConstants.appbarTextColor),
            ),
            centerTitle: false,
            actions: [
              _buildDoneButton(),
            ],
          ),
          // Content
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
                          //ProfilePicture
                          _buildProfilePicture(),
                          const SizedBox(height: 5),
                          NameEnteringField(
                              label: Intl.message("name"),
                              hint: Intl.message("characterNameHint"),
                              controller: _textFieldControllerName
                          ),
                          const SizedBox(height: 20),
                          //ModelSelection
                          //_buildModelSelectionDropdown(),
                          ModelsDropdown(
                            models: models,
                            selectedModel: _selectedModel!,
                            onModelSelected: (newModel) => setState(() => _selectedModel = newModel)
                          ),
                          const SizedBox(height: 20),
                          TemperatureSlider(
                            serviceType: _getServiceType(_selectedModel!),
                            onTemperatureChange: (value) {
                              _onTemperatureChanged(value);
                            },
                            initialTemperature: _currentTemperature,
                          ),
                          //_buildTemperatureSlider(),
                          const SizedBox(height: 20),
                          // Different UI by Service
                          if (OpenAIService.openAIModels.contains(_selectedModel)) ...[
                            // 1. Instruction System prompt
                            _buildOpenAIPromptsListView(),
                            const SizedBox(height: 15),
                          ] else if (PaLMService.paLMModels.contains(_selectedModel)) ... [
                            PromptField(
                                labelText: Intl.message("paLMContextPromptLabel"),
                                hintText: Intl.message("paLMContextPromptHint"),
                                controller: _textFieldControllerPaLMContext
                            ),
                            const SizedBox(height: 15),
                            PaLMExamplePromptFields(
                              inputExampleController: _textFieldControllerPaLMExampleInput,
                              outputExampleController: _textFieldControllerPaLMExampleOutput
                            )
                          ],
                          const SizedBox(height: 20),
                          NameEnteringField(
                            label: Intl.message("characterRecognizeUserName"),
                            hint: Intl.message("characterRecognizeUserNameHint"),
                            controller: _textFieldControllerYourName
                          ),
                          const SizedBox(height: 20),
                          PromptField(
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
          // Bottom navigation bar
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding to left and right
                child: Divider(
                  color: Colors.white, // Choose the color you prefer
                  thickness: 0.3, // Adjust the thickness if needed
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BackGroundButton(
                    onPressed: () async => await _pickImageFromGallery(
                      imageData: _selectedBackgroundImageBLOB!
                    ),
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

  void _init(){
    final serviceType = widget.arguments.character.service.serviceType;
    switch (serviceType) {
      case ServiceType.openAI:
        final service = widget.arguments.character.service as OpenAIService;
        if (service.systemPrompts.isNotEmpty){
          for (final (index, systemPrompt) in service.systemPrompts.indexed) {
            if(index==0){
              _textFieldControllersSystemPrompts.first.text = systemPrompt;
            } else {
              _textFieldControllersSystemPrompts.add(TextEditingController());
              _textFieldControllersSystemPrompts[index].text = systemPrompt;
            }
          }
        }
        setState(() {
          _selectedModel = service.modelName;
          if(_currentTemperature < OpenAIService.maxTemperature){
            _currentTemperature = service.temperature;
          }
        });
        break;
      case ServiceType.paLM:
        final service = widget.arguments.character.service as PaLMService;
        _textFieldControllerPaLMContext = TextEditingController(text: service.context ?? "");
        setState(() {
          _selectedModel = service.modelName;
          if(_currentTemperature > PaLMService.maxTemperature){
            _currentTemperature = PaLMService.defaultTemperature;
          }
          _currentTemperature = service.temperature;
          _textFieldControllerPaLMContext = TextEditingController(text: service.context);
          _textFieldControllerPaLMExampleInput =  TextEditingController(text: service.exampleInput);
          _textFieldControllerPaLMExampleOutput = TextEditingController(text: service.exampleOutput);
        });
        break;
      default:
        throw Exception('Unknown service type: $serviceType');
    }

    _textFieldControllerName = TextEditingController(text: widget.arguments.character.characterName);
    _textFieldControllerYourName = TextEditingController(text: widget.arguments.character.userName);
    _textFieldControllerFirstMessage = TextEditingController(text: widget.arguments.character.firstMessage);

    widget.arguments.character.photoBLOB.isNotEmpty ?
    _selectedProfileImageBLOB = widget.arguments.character.photoBLOB :
    _selectedProfileImageBLOB = Uint8List(0);

    widget.arguments.character.backgroundPhotoBLOB.isNotEmpty ?
    _selectedBackgroundImageBLOB = widget.arguments.character.backgroundPhotoBLOB :
    _selectedBackgroundImageBLOB = Uint8List(0);

    _isDoneButtonEnabled = _textFieldControllerName.text.isNotEmpty;
    _textFieldControllerName.addListener(() {
      setState(() {
        _isDoneButtonEnabled = _textFieldControllerName.text.isNotEmpty;
      });
    });
  }

  Future<void> _pickProfileImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final mimeType = lookupMimeType(image.path);
      if (mimeType != null && !mimeType.startsWith('image/gif')) { //check if image is gif
        final File imageFile = File(image.path);
        final File compressedImageFile = await ImageConverter.compressImage(imageFile);
        Uint8List BLOB = await ImageConverter.convertImageToBLOB(compressedImageFile);
        setState(() {
          _selectedProfileImageBLOB = BLOB;
        });
      } else {
        Fluttertoast.showToast(msg: Intl.message("toastSelectStaticImage"));
      }
    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> _pickImageFromGallery({required Uint8List imageData}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final mimeType = lookupMimeType(image.path);

      if (mimeType != null && !mimeType.startsWith('image/gif')) { //check if image is gif
        final File imageFile = File(image.path);
        final File compressedImageFile = await ImageConverter.compressImage(imageFile);
        Uint8List BLOB = await ImageConverter.convertImageToBLOB(compressedImageFile);
        setState(() {
          imageData = BLOB;
        });
      } else {
        Fluttertoast.showToast(msg: Intl.message("toastSelectStaticImage"));
      }
    } else {
      debugPrint('No image selected.');
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

      await _updateCharacter(character: character, image: compressedBLOB);
    } else {
      Fluttertoast.showToast(msg: Intl.message("toastSelectStaticImage"));
    }
  }

  Future<void> _updateCharacter({
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

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            _pickProfileImageFromGallery();
          },
          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            clipBehavior: Clip.hardEdge,
            child: _selectedProfileImageBLOB!.isNotEmpty
                ? SizedBox(
                width: 100,
                height: 100,
                child: Image.memory(
                  _selectedProfileImageBLOB!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, object, stackTrace) {
                    return const Icon(
                      Icons.account_circle_rounded,
                      size: 100,
                      color: ColorConstants.greyColor,
                    );
                  },
                )
            )
                : const Icon(
              Icons.account_circle_rounded,
              size: 100,
              color: ColorConstants.greyColor,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            mini: true,
            onPressed: () async {
              // Implement your functionality to pick an image from the gallery
              _pickProfileImageFromGallery();
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.photo_library,
              color: ColorConstants.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _onTemperatureChanged(double temperature){
    _currentTemperature = temperature;
  }

  Widget _buildOpenAIPromptsListView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // To ensure full width
      children: [
        for (int index = 0; index < _textFieldControllersSystemPrompts.length; index++)
          PromptField(
            labelText: index == 0 ? Intl.message("description") : Intl.message("systemPrompt"),
            hintText: index == 0 ? Intl.message("descriptionHint") : Intl.message("systemPromptHint"),
            controller: _textFieldControllersSystemPrompts[index],
            index: index,
            onRemove: (index) { _removePromptField(index); },
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Align buttons at each end
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Light background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
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

  void _removePromptField(int index){
    setState(() {
      _textFieldControllersSystemPrompts.removeAt(index);
    });
  }

  Widget _buildDoneButton() {
    Color textColor = _isDoneButtonEnabled ? Colors.white : Colors.white38;
    return TextButton(
      onPressed: _isDoneButtonEnabled
      ? () async {
        if (Utilities.isKeyboardShowing(context)) {
          Utilities.closeKeyboard(context);
        }
        _selectedBackgroundImageBLOB!.isEmpty ? _selectedBackgroundImageBLOB = await ImageConverter.convertAssetImageToBLOB(PathConstants.defaultCharacterBackgroundImage) : Uint8List(0);

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
          final firstChatRoom = ChatRoom.firstChatRoom(newCharacter);
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
