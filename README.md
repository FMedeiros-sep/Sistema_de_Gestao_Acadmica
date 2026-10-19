# 🎓 Academic Management System (Lab 5)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.style=for-the-badge)

> Sistema de Gestão Acadêmica desenvolvido em **Flutter** como parte dos laboratórios práticos da disciplina. O aplicativo permite o gerenciamento e visualização de informações acadêmicas de forma intuitiva e multiplataforma.

---

## 📌 Sumário
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Funcionalidades](#-funcionalidades)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Como Executar o Projeto](#-como-executar-o-projeto)



---

## 🛠️ Tecnologias Utilizadas

O projeto utiliza as seguintes tecnologias e ferramentas:

| Tecnologia | Descrição |
| :--- | :--- |
| **[Flutter](https://flutter.dev/)** | Framework UI para desenvolvimento multiplataforma (Android, iOS, Web, Desktop) |
| **[Dart](https://dart.dev/)** | Linguagem de programação reativa e fortemente tipada |
| **[Material Design](https://m3.material.io/)** | Sistema de design do Google para componentes visuais padronizados |
| **Android SDK / Gradle** | Ferramentas de compilação para dispositivos Android |
| **Xcode / CocoaPods** | Suporte para suporte e build no ecossistema iOS/macOS |

---

## ⚡ Funcionalidades

- [x] Interface intuitiva para navegação entre telas acadêmicas.
- [x] Suporte para temas e fundos personalizados.
- [x] Estrutura adaptável para execução em **Android**, **iOS**, **Web** e **Windows/macOS**.

---

## 📁 Estrutura do Projeto

A organização dos arquivos e pastas do projeto está disposta da seguinte forma:

```text
academic-management-system/
└── lab_5/
    ├── android/            # Configurações e código nativo Android
    ├── ios/                # Configurações e código nativo iOS
    ├── macos/              # Configurações e código nativo macOS
    ├── windows/            # Configurações e código nativo Windows
    ├── web/                # Configurações e assets para Web
    ├── assets/             # Imagens e recursos estáticos (ex: fundo.jpeg)
    ├── lib/
    │   └── main.dart       # Ponto de entrada (entry point) do aplicativo
    ├── test/               # Testes unitários e de widgets
    ├── pubspec.yaml        # Gerenciador de dependências e assets
    └── README.md           # Documentação do projeto
