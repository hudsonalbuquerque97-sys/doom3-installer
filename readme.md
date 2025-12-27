# dhewm3 (Doom 3) Installation Script

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell Script](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)
[![Tested on Ubuntu](https://img.shields.io/badge/tested-Ubuntu%2022.x-orange.svg)](https://ubuntu.com/)
[![Tested on Mint](https://img.shields.io/badge/tested-Linux%20Mint%2022.x-success.svg)](https://linuxmint.com/)
[![Language](https://img.shields.io/badge/language-EN%20%7C%20PT--BR-blue.svg)](#)

[English](#english) | [Português (Brasil)](#português-brasil)

---

## English

### ⚠️ IMPORTANT: This script does NOT download game files

**This script only configures the environment to play Doom 3.** You **MUST** have the original game files (.pk4) from a legitimate copy of the game. The script will ask you to provide the location of these files during installation.

### What This Script Does

This automated installation script:

- Downloads and installs the **dhewm3** engine (open-source Doom 3 engine)
- Configures the game environment in `~/Games/dhewm3`
- Copies your legitimate .pk4 game files to the correct directories
- Creates system launchers for easy game access
- Installs the d3le.so mod for the Resurrection of Evil expansion
- Supports both classic Doom 3 and the Resurrection of Evil expansion

### About dhewm3 Engine

**dhewm3** is an open-source engine based on the GPL-licensed Doom 3 source code. It provides:

- Modern compatibility with current Linux systems
- Better performance and bug fixes
- Support for high resolutions and widescreen
- No CD/DVD required to play (once configured)

Official website: https://dhewm3.org/

### Where to Get Game Files

You need legitimate .pk4 files from one of these sources:

1. **Game Data DEB Packages** (recommended - easiest method)
   - Available on Archive.org: https://archive.org/
   - Search for: "doom3-data" or "doom 3 game data"
   - These DEB packages contain the game files in a convenient format
   - The script automatically extracts .pk4 files from DEB packages

2. **Steam**
   - Buy: https://store.steampowered.com/app/9050/DOOM_3/
   - Files location after installation: `~/.steam/steam/steamapps/common/Doom 3/`

3. **GOG.com**
   - Buy: https://www.gog.com/game/doom_3
   - Download the Linux installer or Windows installer (can be extracted)

4. **Original CD/DVD**
   - Mount the disc and navigate to the game data files
   - Usually in `/media/cdrom/` or `/media/<username>/DOOM3/`

5. **Wine Installation**
   - If you installed via Wine: `~/.wine/drive_c/Program Files/Doom 3/`

### Supported File Sources

The script accepts .pk4 files from:

| Source Type | Description | Example Path |
|-------------|-------------|--------------|
| **Directory** | Folder containing .pk4 files | `~/Downloads/doom3_data/` |
| **DEB Package** | Debian package with game files | `~/Downloads/doom3.deb` |
| **CD/DVD** | Mounted disc | `/media/cdrom/` |
| **Steam** | Steam installation directory | `~/.steam/steam/steamapps/common/Doom 3/base/` |
| **Wine** | Windows installation via Wine | `~/.wine/drive_c/Program Files/Doom 3/base/` |

### Installation Instructions

1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/hudsonalbuquerque97-sys/doom3-installer/refs/heads/main/doom3_installer.sh
   chmod +x doom3_installer.sh
   ```

2. **Run the script:**
   ```bash
   ./doom3_installer.sh
   ```

3. **Follow the prompts:**
   - Enter the path to your Doom 3 .pk4 files (base game)
   - Optionally install Resurrection of Evil expansion
   - Enter sudo password when prompted (for system launchers)

4. **Play the game:**
   ```bash
   doom3        # Launch Classic Doom 3
   doom3-d3xp   # Launch Resurrection of Evil
   ```

   Or use your application menu to launch the games.

### Required Game Files Structure

#### Classic Doom 3 (base game)
```
base/
├── pak000.pk4
├── pak001.pk4
├── pak002.pk4
├── pak003.pk4
├── pak004.pk4
├── pak005.pk4
├── pak006.pk4
├── pak007.pk4
└── pak008.pk4
```

#### Resurrection of Evil (expansion)
```
d3xp/
├── pak000.pk4
├── pak001.pk4
└── pak002.pk4
```

### Final Directory Structure

After installation, your game files will be organized as:

```
~/Games/dhewm3/
├── dhewm3              # Main executable
├── base/               # Classic Doom 3 files
│   ├── pak000.pk4
│   ├── pak001.pk4
│   └── ...
├── d3xp/               # Resurrection of Evil files
│   ├── pak000.pk4
│   └── ...
├── d3le.so             # Expansion mod
└── icondoom3.png       # Game icon
```

### System Integration

The script creates:

- **Launchers in `/usr/local/bin/`:**
  - `doom3` - Classic Doom 3
  - `doom3-d3xp` - Resurrection of Evil

- **Desktop entries in `~/.local/share/applications/`:**
  - Doom 3 (appears in application menu)
  - Doom 3 Resurrection of Evil (appears in application menu)

### Tested Systems

- ✅ Ubuntu 22.04 LTS
- ✅ Ubuntu 22.10
- ✅ Ubuntu 23.04
- ✅ Linux Mint 22.x (based on Ubuntu 22.04)

### Requirements

- Bash shell
- `wget` command
- `tar` command
- `sudo` privileges (for system launcher creation)
- Legitimate Doom 3 game files (.pk4)

### Troubleshooting

**Problem:** Script says "No .pk4 files found"
- **Solution:** Make sure you're pointing to the correct directory containing .pk4 files (usually `base/` or `d3xp/` subdirectory)

**Problem:** Game won't launch
- **Solution:** Verify all .pk4 files were copied correctly to `~/Games/dhewm3/base/`

**Problem:** Desktop entries don't appear
- **Solution:** Log out and log back in, or run: `update-desktop-database ~/.local/share/applications/`

### License

This script is provided as-is for personal use. dhewm3 engine is GPL-licensed. You must own a legitimate copy of Doom 3 to use this script.

---

## Português (Brasil)

### ⚠️ IMPORTANTE: Este script NÃO baixa os arquivos do jogo

**Este script apenas configura o ambiente para jogar Doom 3.** Você **DEVE** ter os arquivos originais do jogo (.pk4) de uma cópia legítima. O script pedirá a localização desses arquivos durante a instalação.

### O Que Este Script Faz

Este script de instalação automatizada:

- Baixa e instala o motor **dhewm3** (motor open-source do Doom 3)
- Configura o ambiente do jogo em `~/Games/dhewm3`
- Copia seus arquivos .pk4 legítimos para os diretórios corretos
- Cria lançadores do sistema para fácil acesso ao jogo
- Instala o mod d3le.so para a expansão Resurrection of Evil
- Suporta tanto o Doom 3 clássico quanto a expansão Resurrection of Evil

### Sobre o Motor dhewm3

**dhewm3** é um motor open-source baseado no código-fonte do Doom 3 licenciado sob GPL. Ele fornece:

- Compatibilidade moderna com sistemas Linux atuais
- Melhor desempenho e correções de bugs
- Suporte para altas resoluções e widescreen
- Não requer CD/DVD para jogar (uma vez configurado)

Site oficial: https://dhewm3.org/

### Onde Obter os Arquivos do Jogo

Você precisa de arquivos .pk4 legítimos de uma destas fontes:

1. **Pacotes DEB com Game Data** (recomendado - método mais fácil)
   - Disponível no Archive.org: https://archive.org/
   - Busque por: "doom3-data" ou "doom 3 game data"
   - Estes pacotes DEB contêm os arquivos do jogo em formato conveniente
   - O script extrai automaticamente os arquivos .pk4 dos pacotes DEB

2. **Steam**
   - Comprar: https://store.steampowered.com/app/9050/DOOM_3/
   - Localização dos arquivos após instalação: `~/.steam/steam/steamapps/common/Doom 3/`

3. **GOG.com**
   - Comprar: https://www.gog.com/game/doom_3
   - Baixar o instalador Linux ou Windows (pode ser extraído)

4. **CD/DVD Original**
   - Monte o disco e navegue até os arquivos de dados do jogo
   - Geralmente em `/media/cdrom/` ou `/media/<usuário>/DOOM3/`

5. **Instalação via Wine**
   - Se instalou via Wine: `~/.wine/drive_c/Program Files/Doom 3/`

### Fontes de Arquivos Suportadas

O script aceita arquivos .pk4 de:

| Tipo de Fonte | Descrição | Exemplo de Caminho |
|---------------|-----------|-------------------|
| **Diretório** | Pasta contendo arquivos .pk4 | `~/Downloads/doom3_data/` |
| **Pacote DEB** | Pacote Debian com arquivos do jogo | `~/Downloads/doom3.deb` |
| **CD/DVD** | Disco montado | `/media/cdrom/` |
| **Steam** | Diretório de instalação do Steam | `~/.steam/steam/steamapps/common/Doom 3/base/` |
| **Wine** | Instalação Windows via Wine | `~/.wine/drive_c/Program Files/Doom 3/base/` |

### Instruções de Instalação

1. **Baixe o script:**
   ```bash
   wget https://raw.githubusercontent.com/hudsonalbuquerque97-sys/doom3-installer/refs/heads/main/doom3_installer.sh
   chmod +x doom3_installer.sh
   ```

2. **Execute o script:**
   ```bash
   ./doom3_installer.sh
   ```

3. **Siga as instruções:**
   - Digite o caminho para seus arquivos .pk4 do Doom 3 (jogo base)
   - Opcionalmente instale a expansão Resurrection of Evil
   - Digite a senha sudo quando solicitado (para lançadores do sistema)

4. **Jogue:**
   ```bash
   doom3        # Iniciar Doom 3 Clássico
   doom3-d3xp   # Iniciar Resurrection of Evil
   ```

   Ou use o menu de aplicações para iniciar os jogos.

### Estrutura de Arquivos Necessária

#### Doom 3 Clássico (jogo base)
```
base/
├── pak000.pk4
├── pak001.pk4
├── pak002.pk4
├── pak003.pk4
├── pak004.pk4
├── pak005.pk4
├── pak006.pk4
├── pak007.pk4
└── pak008.pk4
```

#### Resurrection of Evil (expansão)
```
d3xp/
├── pak000.pk4
├── pak001.pk4
└── pak002.pk4
```

### Estrutura Final de Diretórios

Após a instalação, seus arquivos do jogo serão organizados como:

```
~/Games/dhewm3/
├── dhewm3              # Executável principal
├── base/               # Arquivos do Doom 3 Clássico
│   ├── pak000.pk4
│   ├── pak001.pk4
│   └── ...
├── d3xp/               # Arquivos do Resurrection of Evil
│   ├── pak000.pk4
│   └── ...
├── d3le.so             # Mod da expansão
└── icondoom3.png       # Ícone do jogo
```

### Integração com o Sistema

O script cria:

- **Lançadores em `/usr/local/bin/`:**
  - `doom3` - Doom 3 Clássico
  - `doom3-d3xp` - Resurrection of Evil

- **Entradas desktop em `~/.local/share/applications/`:**
  - Doom 3 (aparece no menu de aplicações)
  - Doom 3 Resurrection of Evil (aparece no menu de aplicações)

### Sistemas Testados

- ✅ Ubuntu 22.04 LTS
- ✅ Ubuntu 22.10
- ✅ Ubuntu 23.04
- ✅ Linux Mint 22.x (baseado no Ubuntu 22.04)

### Requisitos

- Shell Bash
- Comando `wget`
- Comando `tar`
- Privilégios `sudo` (para criação de lançadores do sistema)
- Arquivos legítimos do jogo Doom 3 (.pk4)

### Solução de Problemas

**Problema:** Script diz "Nenhum arquivo .pk4 encontrado"
- **Solução:** Certifique-se de apontar para o diretório correto contendo arquivos .pk4 (geralmente subdiretório `base/` ou `d3xp/`)

**Problema:** Jogo não inicia
- **Solução:** Verifique se todos os arquivos .pk4 foram copiados corretamente para `~/Games/dhewm3/base/`

**Problema:** Entradas desktop não aparecem
- **Solução:** Faça logout e login novamente, ou execute: `update-desktop-database ~/.local/share/applications/`

### Licença

Este script é fornecido como está para uso pessoal. O motor dhewm3 é licenciado sob GPL. Você deve possuir uma cópia legítima do Doom 3 para usar este script.
