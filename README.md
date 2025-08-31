# 🎬 Cinebox - App de Filmes

Um aplicativo Flutter moderno para descobrir e acompanhar filmes, construído com arquitetura limpa e boas práticas de desenvolvimento.

## ✨ **Funcionalidades Principais**

- 🎭 **Catálogo de Filmes**: Explore filmes populares e bem avaliados
- 🔍 **Filtros por Gênero**: Filtre filmes por categoria (Ação, Comédia, Drama, etc.)
- ❤️ **Sistema de Favoritos**: Salve seus filmes preferidos
- 🔐 **Login com Google**: Autenticação segura e rápida
- 📱 **Interface Responsiva**: Design adaptável para diferentes tamanhos de tela
- 🌙 **Tema Moderno**: Interface elegante e intuitiva

## 🚀 **Melhorias Implementadas**

### **Performance e Velocidade**
- ✅ **Removido delay artificial** de 2 segundos no login
- ✅ **Sistema de cache otimizado** para autenticação Google
- ✅ **Timeout configurável** para evitar travamentos
- ✅ **Retry automático** em caso de falhas de rede

### **Interface e UX**
- ✅ **Botão de login animado** com feedback visual
- ✅ **Sistema de cores expandido** com variações e gradientes
- ✅ **Widgets de loading otimizados** (Shimmer, Spinner animado)
- ✅ **Transições de página suaves** com animações customizadas
- ✅ **Tratamento de erros melhorado** com botão de retry

### **Arquitetura e Código**
- ✅ **Gerenciamento de estado otimizado** com Riverpod
- ✅ **Sistema de timeout robusto** para operações de rede
- ✅ **Cache inteligente** com validação de tempo
- ✅ **Tratamento de erros centralizado** e informativo

## 🛠️ **Tecnologias Utilizadas**

- **Flutter** - Framework de desenvolvimento
- **Riverpod** - Gerenciamento de estado
- **Dio** - Cliente HTTP
- **Google Sign-In** - Autenticação OAuth
- **Flutter Secure Storage** - Armazenamento seguro
- **Retrofit** - Cliente REST API
- **Envied** - Gerenciamento de variáveis de ambiente

## 📱 **Estrutura do Projeto**

```
lib/
├── config/           # Configurações e variáveis de ambiente
├── core/             # Utilitários e componentes base
├── data/             # Camada de dados (models, services, repositories)
├── ui/               # Interface do usuário
│   ├── core/         # Componentes base da UI
│   ├── home/         # Tela principal
│   ├── login/        # Autenticação
│   ├── favorites/    # Favoritos
│   └── profile/      # Perfil do usuário
└── main.dart         # Ponto de entrada da aplicação
```

## 🚀 **Como Executar**

### **Pré-requisitos**
- Flutter SDK 3.8.1 ou superior
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS ou emulador

### **Configuração**
1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/cinebox.git
cd cinebox
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure as variáveis de ambiente:
   - Crie um arquivo `.env` na raiz do projeto
   - Adicione suas chaves de API:
```env
GOOGLE_API_KEY=sua_chave_google
THE_MOVIE_DB_API_KEY=sua_chave_tmdb
BACKEND_BASE_URL=https://api.themoviedb.org/3
```

4. Execute o projeto:
```bash
flutter run
```

## 🔧 **Configurações de Build**

### **Android**
- API Level mínimo: 21
- Target API: 33
- Suporte a arquiteturas: arm64-v8a, armeabi-v7a, x86_64

### **iOS**
- iOS mínimo: 12.0
- Suporte a dispositivos: iPhone e iPad


**Desenvolvido com ❤️ usando Flutter**
