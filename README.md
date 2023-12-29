# AI Bridge

AIBridge is a open-source flutter project that allows you to use external APIs for AI Chat.

https://github.com/jhj0517/AIBridge/assets/97279763/c23efc97-59d8-4540-ad30-6ca66607ec92

Currently implemented APIs are :
- ChatGPT
- PaLM

You can also use the built version directly from Stores :

[![download on playstore](https://github.com/jhj0517/AIBridge/assets/97279763/6457404a-a4d9-4303-b614-f4a8e58c5b79)](https://play.google.com/store/apps/details?id=com.wecraftstudio.aibridge)
[![download on appstore](https://github.com/jhj0517/AIBridge/assets/97279763/5394f501-89c3-446c-882f-a571a493161d)](https://apps.apple.com/app/id6474897375)

# Architecture
![diagram](https://github.com/jhj0517/AIBridge/blob/master/gitimages/architecture.png)

# Techs
| Tech | Usage |
| ---------- | ----- |
| Provider pattern | Monitor data changes using ChangeNotifier |
| sqflite | Used to store chat data as local data |
| dio | 	Used for requesting API responses over the network. However, a different built-in package, dart_openai, is specifically used for ChatGPT. Dio is primarily used for PaLM. |
| dart_openai | 	A built-in package for requesting ChatGPT API responses in Flutter |
| flutter_image_compress | Efficiently reduces image size, which is cost-effective for storing images on the server. Demonstrates efficiency with reductions from 2MB to 95kB, without compromising image quality. |
| tiktoken | 	A built-in package for counting tokens in ChatGPT |
| flutter_markdown | 	Enables markdown rendering in chat |
| intl | Used for localization. This project is localized in English, Korean, and Japanese. |
| flutter_secure_storage | 	Stores API keys securely within the app. This package implements a security algorithm to safeguard API keys. |

# Flutter environment
This project is built fine with the following environment:
```
[√] Flutter (Channel stable, 3.13.2, on Microsoft Windows [Version 10.0.19045.3693], locale ko-KR)
    • Flutter version 3.13.2 on channel stable at C:\FlutterSDK\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision ff5b5b5fa6 (4 months ago), 2023-08-24 08:12:28 -0500
    • Engine revision b20183e040
    • Dart version 3.1.0
    • DevTools version 2.25.0
```

# License
This project is licensed under the Apache License 2.0.
