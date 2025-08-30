# Estrutura das Telas do Cinebox

## Visão Geral
Este diretório contém todas as telas do aplicativo Cinebox, organizadas por funcionalidade.

## Estrutura de Diretórios

### `/core`
- **themes/**: Definições de cores, estilos de texto e tema geral
- **widgets/**: Widgets reutilizáveis em todo o app

### `/login`
- **login_screen.dart**: Tela de login com Google
- **login_view_model.dart**: ViewModel para gerenciar o estado do login
- **commands/**: Comandos para executar ações de login
- **widgets/**: Widgets específicos da tela de login

### `/home`
- **home_screen.dart**: Tela principal com lista de filmes da API TMDB
- **home_view_model.dart**: ViewModel para gerenciar o estado dos filmes
- Inclui:
  - Header com imagem de fundo (small_banner) e barra de pesquisa
  - Filtros de categoria funcionais (Todos, Ação, Comédia, Drama, Romance, Terror)
  - Seção "Mais populares" com filmes reais da API
  - Seção "Top filmes" com filmes reais da API
  - Filtros funcionais por gênero

### `/favorites`
- **favorites_screen.dart**: Tela de filmes favoritos
- Lista vertical de filmes favoritados com opção de remover

### `/profile`
- **profile_screen.dart**: Tela de perfil do usuário
- Inclui:
  - Informações do usuário
  - Estatísticas (filmes, favoritos, avaliações)
  - Menu de opções (configurações, notificações, idioma, ajuda, sobre, sair)

### `/main`
- **main_screen.dart**: Tela principal que gerencia a navegação
- Controla a barra de navegação inferior
- Gerencia a troca entre Home, Favoritos e Perfil

## Integração com API TMDB

### Configuração
- **Base URL**: `https://api.themoviedb.org/3/`
- **Chave da API**: Configurada em `lib/config/env.dart` como `THE_MOVIE_DB_API_KEY`
- **Idioma**: Português do Brasil (pt-BR)
- **Região**: Brasil (BR)

### Endpoints Utilizados
- **Filmes Populares**: `/movie/popular`
- **Top Filmes**: `/movie/top_rated`
- **Busca**: `/search/movie`
- **Descoberta por Gênero**: `/discover/movie`

### Modelos de Dados
- **Movie**: Modelo completo do filme com poster, título, ano, gêneros, etc.
- **MovieResponse**: Resposta da API com paginação
- **Genre**: Modelo de gênero com mapeamento para IDs do TMDB

### Funcionalidades Implementadas
- ✅ Carregamento de filmes populares
- ✅ Carregamento de top filmes
- ✅ Filtros por gênero funcionais
- ✅ Imagens de poster dos filmes
- ✅ Tratamento de erros
- ✅ Estados de loading
- ✅ Refresh automático

## Navegação

### Fluxo de Login
1. **Splash Screen** (`/`) → Verifica se usuário está logado
2. **Login Screen** (`/login`) → Tela de login com Google
3. **Main Screen** (`/home`) → Tela principal após login bem-sucedido

### Navegação Principal
- **Filmes** (índice 0): Tela Home com lista de filmes da API
- **Favoritos** (índice 1): Lista de filmes favoritados
- **Perfil** (índice 2): Configurações e informações do usuário

## Características das Telas

### Design System
- **Cores**: Usa `AppColors` definido em `/core/themes/colors.dart`
- **Tipografia**: Usa `AppTextStyles` definido em `/core/themes/text_styles.dart`
- **Tema**: Usa `AppTheme` definido em `/core/themes/theme.dart`

### Responsividade
- Todas as telas são responsivas e funcionam em diferentes tamanhos de tela
- Listas horizontais para filmes com scroll
- Layout adaptativo para diferentes orientações

### Estado
- **Login**: Gerenciado com Riverpod e AsyncValue
- **Filmes**: Gerenciado com Riverpod e AsyncValue
- **Navegação**: Gerenciada com IndexedStack para performance
- **Filtros**: Estado local com filtros funcionais

## Como Usar

### 1. Configuração da API
```bash
# Adicione sua chave da API do TMDB no arquivo .env
THE_MOVIE_DB_API_KEY=sua_chave_aqui
```

### 2. Executar o App
```bash
flutter run
```

### 3. Funcionalidades
- **Filtros**: Toque nos botões de gênero para filtrar filmes
- **Scroll**: Deslize horizontalmente para ver mais filmes
- **Refresh**: Puxe para baixo para atualizar a lista
- **Busca**: Use a barra de pesquisa (funcionalidade futura)

## Próximos Passos
1. ✅ Integrar com API real de filmes (TMDB) - **CONCLUÍDO**
2. Implementar sistema de favoritos persistente
3. Adicionar funcionalidade de busca funcional
4. Implementar sistema de avaliações
5. Adicionar detalhes dos filmes
6. Implementar cache offline
7. Adicionar paginação infinita
