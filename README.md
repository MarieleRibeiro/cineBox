# 🎬 Cinebox - App de Filmes Profissional

> **Um aplicativo Flutter moderno e otimizado para explorar, buscar e gerenciar filmes favoritos com API TMDB integrada.**

## 🌟 **Destaques do Projeto**

- ✅ **Sistema completo de favoritos** via API TMDB
- ✅ **Autenticação Google** otimizada e segura
- ✅ **Busca inteligente** em tempo real
- ✅ **Arquitetura limpa** com Riverpod
- ✅ **Performance otimizada** e responsiva
- ✅ **UI/UX moderna** com Material Design 3

## 📱 **Download e Teste**

### **🎯 APK Funcional para Teste**
**[📱 Baixar APK - Cinebox](https://drive.google.com/file/d/1N4kbIuePVtdvfQyOHrHC48QwkMn9MZXs/view?usp=drive_link)**

### **📋 Instruções de Instalação**
1. **Baixe o APK** do link acima
2. **Habilite "Fontes desconhecidas"** nas configurações do Android
3. **Instale o aplicativo**
4. **Faça login** com sua conta Google
5. **Explore os filmes** e teste todas as funcionalidades!

---

## 🚀 **Funcionalidades Implementadas**

### **🎭 Sistema de Filmes**
- **Catálogo completo** de filmes populares e bem avaliados
- **Busca inteligente** em tempo real
- **Filtros por gênero** (Ação, Comédia, Drama, Romance, Terror)
- **Detalhes completos** de cada filme
- **Navegação intuitiva** entre telas

### **❤️ Sistema de Favoritos**
- **Adicionar/remover** filmes dos favoritos
- **Lista sincronizada** em tempo real
- **Contador dinâmico** de favoritos
- **Persistência na nuvem** via TMDB API
- **Sincronização automática** entre todas as telas

### **🔐 Autenticação Segura**
- **Login Google** otimizado e rápido
- **Gerenciamento de sessão** seguro
- **Cache inteligente** para melhor performance
- **Tratamento de erros** robusto

### **🎨 Interface Moderna**
- **Design responsivo** e intuitivo
- **Animações suaves** e feedback visual
- **Sistema de cores** consistente
- **Loading states** otimizados
- **Transições de página** personalizadas

---

## 🛠️ **Stack Tecnológica**

### **Framework Principal**
- **Flutter 3.32.8** - Framework multiplataforma
- **Dart 3.8.1** - Linguagem de programação

### **Gerenciamento de Estado**
- **Riverpod** - Gerenciamento de estado reativo
- **Riverpod Generator** - Code generation para providers

### **APIs e Serviços**
- **TMDB API** - Banco de dados de filmes
- **Google Sign-In** - Autenticação OAuth
- **Dio** - Cliente HTTP robusto
- **Retrofit** - Code generation para APIs

### **Arquitetura e Padrões**
- **Clean Architecture** - Separação de responsabilidades
- **Repository Pattern** - Abstração de dados
- **Service Layer** - Lógica de negócio
- **Provider Pattern** - Injeção de dependências

### **Ferramentas de Desenvolvimento**
- **Build Runner** - Code generation
- **Envied** - Gerenciamento de variáveis de ambiente
- **JSON Serializable** - Serialização de dados
- **Custom Lint** - Regras de código personalizadas

---

## 🏗️ **Arquitetura do Projeto**

```
lib/
├── 📱 main.dart                    # Ponto de entrada da aplicação
├── 🎯 cinebox_main_app.dart        # Configuração principal do app
├── ⚙️ config/                      # Configurações e variáveis de ambiente
├── 🔧 core/                        # Lógica central e utilitários
│   └── result/                     # Padrão Result para tratamento de erros
├── 📊 data/                        # Camada de dados
│   ├── models/                     # Modelos de dados (Movie, Genre)
│   ├── repositories/               # Repositórios abstratos
│   ├── services/                   # Serviços de API e autenticação
│   └── exceptions/                 # Tratamento de exceções
└── 🎨 ui/                          # Interface do usuário
    ├── core/                       # Componentes base e temas
    ├── home/                       # Tela principal com listas de filmes
    ├── login/                      # Tela de autenticação Google
    ├── favorites/                  # Tela de filmes favoritos
    ├── profile/                    # Tela de perfil do usuário
    ├── movie_details/              # Tela de detalhes do filme
    └── splash/                     # Tela de inicialização
```

---

## 🚀 **Como Executar o Projeto**

### **📋 Pré-requisitos**
- Flutter 3.32.8+
- Dart 3.8.1+
- Android Studio / VS Code
- Dispositivo Android ou emulador

### **⚡ Execução Rápida**
```bash
# Clone o repositório
git clone https://github.com/MarieleRibeiro/cineBox.git

# Entre na pasta
cd cineBox

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### **🔨 Build para Produção**
```bash
# APK para Android
flutter build apk --release

# Web (se configurado)
flutter build web
```

---


## 🎯 **Funcionalidades Técnicas**

### **🔄 Sistema de Favoritos**
- **API TMDB integrada** com account_id configurado
- **Estado reativo** com Riverpod
- **Sincronização automática** entre telas
- **Tratamento de erros** robusto

### **🔍 Busca Inteligente**
- **Busca em tempo real** via API TMDB
- **Filtros dinâmicos** por gênero
- **Resultados paginados** para performance
- **Cache inteligente** de resultados

### **📱 Navegação e UX**
- **Navegação intuitiva** entre telas
- **Transições suaves** e animações
- **Feedback visual** para todas as ações
- **Loading states** otimizados

---

## 🧪 **Testes e Qualidade**

### **🔍 Análise de Código**
```bash
# Análise estática
flutter analyze

# Verificação de dependências
flutter doctor
```

---

## 🚀 **Melhorias Futuras Planejadas**

### **🎨 Interface e UX**
- [ ] **Tema Escuro/Claro** com persistência
- [ ] **Animações avançadas** e micro-interações
- [ ] **Suporte a gestos** personalizados
- [ ] **Modo offline** com cache local

### **🔧 Funcionalidades**
- [ ] **Sistema de avaliações** de filmes
- [ ] **Watchlist** para filmes para assistir
- [ ] **Recomendações personalizadas** baseadas em histórico
- [ ] **Compartilhamento** de filmes favoritos

### **📊 Analytics e Performance**
- [ ] **Métricas de uso** e analytics
- [ ] **Testes A/B** para otimização de UX
- [ ] **Performance monitoring** em tempo real
- [ ] **Crash reporting** e telemetria

---

## 📞 **Contato e Suporte**

- **GitHub**: [@MarieleRibeiro](https://github.com/MarieleRibeiro)
- **Email**: [marieleribeirocontato@gmail.com]

---

## 🙏 **Agradecimentos**

- **Flutter Team** pelo framework incrível
- **TMDB** pela API de filmes gratuita
- **Google** pelo sistema de autenticação
- **Comunidade Flutter** pelo suporte e recursos

---

## ⭐ **Avaliação do Projeto**

**Se este projeto te ajudou ou impressionou, deixe uma estrela no repositório!**

---

**🎬 Desenvolvido com ❤️ por Mariele Ribeiro**
