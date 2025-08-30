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

## 📊 **Performance**

### **Antes das Melhorias**
- ⏱️ Login com Google: ~3-4 segundos
- 🔄 Verificações repetidas de autenticação
- ❌ Falta de retry automático
- 🐌 Feedback visual lento

### **Após as Melhorias**
- ⚡ Login com Google: ~1-2 segundos
- 🚀 Cache inteligente de autenticação
- 🔁 Retry automático em falhas
- ✨ Animações suaves e feedback instantâneo

## 🧪 **Testes**

Para executar os testes:
```bash
# Testes unitários
flutter test

# Testes de widget
flutter test test/widget_test.dart

# Análise de código
flutter analyze
```

## 📈 **Próximas Melhorias Planejadas**

- [ ] **Modo Offline**: Cache local de filmes
- [ ] **Notificações**: Alertas para novos filmes
- [ ] **Analytics**: Métricas de uso e performance
- [ ] **CI/CD**: Pipeline de deploy automático
- [ ] **Testes E2E**: Testes de integração completos
- [ ] **Internacionalização**: Suporte a múltiplos idiomas

## 🤝 **Contribuição**

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 **Licença**

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 **Suporte**

- 📧 Email: seu-email@exemplo.com
- 🐛 Issues: [GitHub Issues](https://github.com/seu-usuario/cinebox/issues)
- 📖 Documentação: [Wiki do Projeto](https://github.com/seu-usuario/cinebox/wiki)

---

**Desenvolvido com ❤️ usando Flutter**
