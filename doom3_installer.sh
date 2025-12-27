#!/bin/bash

# Bilingual dhewm3 Installation Script (EN/PT-BR)
# Detects system language and adapts messages accordingly

# Language detection
detect_language() {
    if [[ "$LANG" == *"pt_BR"* ]] || [[ "$LANG" == *"pt_PT"* ]] || [[ "$LANGUAGE" == *"pt"* ]]; then
        echo "pt_BR"
    else
        echo "en"
    fi
}

LANG_DETECTED=$(detect_language)

# Message functions
msg() {
    local en="$1"
    local pt="$2"
    if [ "$LANG_DETECTED" = "pt_BR" ]; then
        echo "$pt"
    else
        echo "$en"
    fi
}

error_exit() {
    local en="$1"
    local pt="$2"
    msg "$en" "$pt" >&2
    exit 1
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
msg "      dhewm3 (Doom 3) Installation Script" \
    "      Script de Instalação dhewm3 (Doom 3)"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo

# Check for required commands
for cmd in wget tar; do
    if ! command -v $cmd &> /dev/null; then
        error_exit "Required command '$cmd' not found. Please install it first." \
                   "Comando necessário '$cmd' não encontrado. Por favor, instale-o primeiro."
    fi
done

# Check for sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}$(msg 'This script needs sudo privileges to create system launchers.' 'Este script precisa de privilégios sudo para criar lançadores do sistema.')${NC}"
    echo -e "${YELLOW}$(msg 'Please enter your password when prompted.' 'Por favor, digite sua senha quando solicitado.')${NC}"
    echo
fi

# Define directories
GAMES_DIR="$HOME/Games"
DHEWM3_DIR="$GAMES_DIR/dhewm3"
BASE_DIR="$DHEWM3_DIR/base"
D3XP_DIR="$DHEWM3_DIR/d3xp"
APPLICATIONS_DIR="$HOME/.local/share/applications"

# Global variable to track temporary extraction directories
declare -a TEMP_EXTRACTION_DIRS=()

# Function to cleanup temporary directories
cleanup_temp_dirs() {
    if [ ${#TEMP_EXTRACTION_DIRS[@]} -gt 0 ]; then
        echo -e "${YELLOW}$(msg 'Cleaning up temporary files...' 'Limpando arquivos temporários...')${NC}"
        for dir in "${TEMP_EXTRACTION_DIRS[@]}"; do
            if [ -d "$dir" ]; then
                rm -rf "$dir"
                echo -e "${GREEN}✓ $(msg "Removed temporary directory: $dir" "Diretório temporário removido: $dir")${NC}"
            fi
        done
    fi
}

# Trap to ensure cleanup on script exit
trap cleanup_temp_dirs EXIT

# Create necessary directories
mkdir -p "$GAMES_DIR"
mkdir -p "$APPLICATIONS_DIR"

# Download and install dhewm3
echo -e "${YELLOW}$(msg 'Downloading dhewm3...' 'Baixando dhewm3...')${NC}"
DHEWM3_URL="https://github.com/dhewm/dhewm3/releases/download/1.5.4/dhewm3-1.5.4_Linux_amd64.tar.gz"
TEMP_DOWNLOAD=$(mktemp -d -p /tmp dhewm3-download-XXXXXX)
TEMP_EXTRACTION_DIRS+=("$TEMP_DOWNLOAD")

if ! wget -q --show-progress "$DHEWM3_URL" -O "$TEMP_DOWNLOAD/dhewm3.tar.gz"; then
    error_exit "Failed to download dhewm3. Please check your internet connection." \
               "Falha ao baixar dhewm3. Verifique sua conexão com a internet."
fi

echo -e "${GREEN}✓ $(msg 'Download completed!' 'Download concluído!')${NC}"
echo

# Extract dhewm3
echo -e "${YELLOW}$(msg 'Extracting dhewm3...' 'Extraindo dhewm3...')${NC}"
if ! tar -xzf "$TEMP_DOWNLOAD/dhewm3.tar.gz" -C "$TEMP_DOWNLOAD"; then
    error_exit "Failed to extract dhewm3." \
               "Falha ao extrair dhewm3."
fi

# Move dhewm3 to Games directory
if [ -d "$DHEWM3_DIR" ]; then
    echo -e "${YELLOW}$(msg 'Removing old dhewm3 installation...' 'Removendo instalação antiga do dhewm3...')${NC}"
    rm -rf "$DHEWM3_DIR"
fi

mv "$TEMP_DOWNLOAD/dhewm3" "$DHEWM3_DIR"
echo -e "${GREEN}✓ $(msg 'dhewm3 installed successfully!' 'dhewm3 instalado com sucesso!')${NC}"
echo

# Download game icon
echo -e "${YELLOW}$(msg 'Downloading game icon...' 'Baixando ícone do jogo...')${NC}"
ICON_URL="https://pcgw-community.sfo2.digitaloceanspaces.com/monthly_2020_06/582210549_Doom3.thumb.png.c89f4a07c0f6e2bfd9cc3239918862cb.png"
if ! wget -q "$ICON_URL" -O "$DHEWM3_DIR/icondoom3.png"; then
    echo -e "${YELLOW}$(msg 'Warning: Failed to download icon. Desktop entries will be created without icon.' 'Aviso: Falha ao baixar ícone. Entradas do desktop serão criadas sem ícone.')${NC}"
else
    echo -e "${GREEN}✓ $(msg 'Icon downloaded successfully!' 'Ícone baixado com sucesso!')${NC}"
fi
echo

# Function to copy PK4 files from directory
copy_pk4_from_dir() {
    local src_dir="$1"
    local dest_dir="$2"
    
    if [ ! -d "$src_dir" ]; then
        error_exit "Directory not found: $src_dir" \
                   "Diretório não encontrado: $src_dir"
    fi
    
    local pk4_files=$(find "$src_dir" -iname "*.pk4" 2>/dev/null)
    if [ -z "$pk4_files" ]; then
        error_exit "No .pk4 files found in: $src_dir" \
                   "Nenhum arquivo .pk4 encontrado em: $src_dir"
    fi
    
    echo -e "${YELLOW}$(msg 'Copying .pk4 files...' 'Copiando arquivos .pk4...')${NC}"
    find "$src_dir" -iname "*.pk4" -exec cp -v {} "$dest_dir/" \;
    echo -e "${GREEN}✓ $(msg 'Files copied successfully!' 'Arquivos copiados com sucesso!')${NC}"
}

# Function to extract PK4 files from DEB package
extract_pk4_from_deb() {
    local deb_file="$1"
    local dest_dir="$2"
    
    if [ ! -f "$deb_file" ]; then
        error_exit "DEB file not found: $deb_file" \
                   "Arquivo DEB não encontrado: $deb_file"
    fi
    
    echo -e "${YELLOW}$(msg 'Extracting .pk4 files from DEB package...' 'Extraindo arquivos .pk4 do pacote DEB...')${NC}"
    
    # Create a unique temporary directory in /tmp
    local temp_dir=$(mktemp -d -p /tmp doom3-deb-extract-XXXXXX)
    
    # Add to cleanup list
    TEMP_EXTRACTION_DIRS+=("$temp_dir")
    
    # Extract DEB contents
    dpkg-deb -x "$deb_file" "$temp_dir"
    
    local pk4_files=$(find "$temp_dir" -iname "*.pk4" 2>/dev/null)
    if [ -z "$pk4_files" ]; then
        error_exit "No .pk4 files found in DEB package." \
                   "Nenhum arquivo .pk4 encontrado no pacote DEB."
    fi
    
    echo -e "${YELLOW}$(msg 'Found .pk4 files, copying to destination...' 'Arquivos .pk4 encontrados, copiando para destino...')${NC}"
    
    # Count files before copy
    local file_count=$(find "$temp_dir" -iname "*.pk4" | wc -l)
    
    # Copy all .pk4 files
    find "$temp_dir" -iname "*.pk4" -exec cp -v {} "$dest_dir/" \;
    
    echo -e "${GREEN}✓ $(msg "Successfully copied $file_count .pk4 files!" "$file_count arquivos .pk4 copiados com sucesso!")${NC}"
    
    echo -e "${YELLOW}$(msg 'Temporary files will be automatically removed after installation.' 'Arquivos temporários serão removidos automaticamente após a instalação.')${NC}"
}

# Function to download and install d3le.so mod
install_d3le_mod() {
    echo
    echo -e "${YELLOW}$(msg 'Downloading dhewm3 mods package...' 'Baixando pacote de mods do dhewm3...')${NC}"
    
    MODS_URL="https://github.com/dhewm/dhewm3/releases/download/1.5.4/dhewm3-mods-1.5.4_Linux_amd64.tar.gz"
    TEMP_MODS_DIR=$(mktemp -d -p /tmp dhewm3-mods-XXXXXX)
    TEMP_EXTRACTION_DIRS+=("$TEMP_MODS_DIR")
    
    if ! wget -q --show-progress "$MODS_URL" -O "$TEMP_MODS_DIR/dhewm3-mods.tar.gz"; then
        error_exit "Failed to download dhewm3 mods package. Please check your internet connection." \
                   "Falha ao baixar pacote de mods do dhewm3. Verifique sua conexão com a internet."
    fi
    
    echo -e "${GREEN}✓ $(msg 'Mods package downloaded!' 'Pacote de mods baixado!')${NC}"
    echo
    
    echo -e "${YELLOW}$(msg 'Extracting mods package...' 'Extraindo pacote de mods...')${NC}"
    if ! tar -xzf "$TEMP_MODS_DIR/dhewm3-mods.tar.gz" -C "$TEMP_MODS_DIR"; then
        error_exit "Failed to extract mods package." \
                   "Falha ao extrair pacote de mods."
    fi
    
    # Find and copy d3le.so file
    D3LE_FILE=$(find "$TEMP_MODS_DIR" -name "d3le.so" -type f 2>/dev/null | head -n 1)
    
    if [ -z "$D3LE_FILE" ]; then
        error_exit "d3le.so file not found in mods package." \
                   "Arquivo d3le.so não encontrado no pacote de mods."
    fi
    
    echo -e "${YELLOW}$(msg 'Installing d3le.so mod...' 'Instalando mod d3le.so...')${NC}"
    
    # Backup original d3le.so if it exists
    if [ -f "$DHEWM3_DIR/d3le.so" ]; then
        echo -e "${YELLOW}$(msg 'Backing up original d3le.so...' 'Fazendo backup do d3le.so original...')${NC}"
        mv "$DHEWM3_DIR/d3le.so" "$DHEWM3_DIR/d3le.so.backup"
    fi
    
    # Copy new d3le.so
    cp "$D3LE_FILE" "$DHEWM3_DIR/"
    
    echo -e "${GREEN}✓ $(msg 'd3le.so mod installed successfully!' 'Mod d3le.so instalado com sucesso!')${NC}"
}

# Function to create launcher scripts in /usr/local/bin
create_launchers() {
    echo -e "${YELLOW}$(msg 'Creating launcher scripts...' 'Criando scripts de lançamento...')${NC}"
    
    # Create /usr/local/bin directory if it doesn't exist
    sudo mkdir -p /usr/local/bin
    
    # Create doom3 launcher for Classic Doom 3
    sudo tee /usr/local/bin/doom3 > /dev/null << EOF
#!/bin/bash
cd "$DHEWM3_DIR" || exit 1
exec ./dhewm3 +set fs_game cdoom +set fs_game_base base
EOF
    
    # Create doom3-d3xp launcher for Resurrection of Evil
    sudo tee /usr/local/bin/doom3-d3xp > /dev/null << EOF
#!/bin/bash
cd "$DHEWM3_DIR" || exit 1
#exec ./dhewm3 +set fs_game d3le +set fs_game_base d3xp
exec ./dhewm3 +set fs_game_base d3xp +set fs_game d3le
EOF
    
    # Set executable permissions
    sudo chmod +x /usr/local/bin/doom3 /usr/local/bin/doom3-d3xp
    
    echo -e "${GREEN}✓ $(msg 'Launcher scripts created successfully!' 'Scripts de lançamento criados com sucesso!')${NC}"
}

# Function to create desktop entries
create_desktop_entries() {
    echo -e "${YELLOW}$(msg 'Creating desktop entries...' 'Criando entradas do desktop...')${NC}"
    
    # Doom 3 Classic desktop entry
    cat > "$APPLICATIONS_DIR/doom3.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Doom 3
Comment=$(msg 'Classic Doom 3' 'Doom 3 Clássico')
Exec=doom3
Icon=$DHEWM3_DIR/icondoom3.png
Terminal=false
Categories=Game;ActionGame;
EOF

    # Doom 3 Resurrection of Evil desktop entry
    cat > "$APPLICATIONS_DIR/doom3-resurrection-evil.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Doom 3 Resurrection of Evil
Comment=$(msg 'Doom 3: Resurrection of Evil Expansion' 'Doom 3: Expansão Resurrection of Evil')
Exec=doom3-d3xp
Icon=$DHEWM3_DIR/icondoom3.png
Terminal=false
Categories=Game;ActionGame;
EOF

    # Make desktop entries executable
    chmod +x "$APPLICATIONS_DIR/doom3.desktop"
    chmod +x "$APPLICATIONS_DIR/doom3-resurrection-evil.desktop"
    
    echo -e "${GREEN}✓ $(msg 'Desktop entries created successfully!' 'Entradas do desktop criadas com sucesso!')${NC}"
}

# Main Doom 3 installation
echo -e "${BLUE}$(msg '--- DOOM 3 Base Game Installation ---' '--- Instalação do Jogo Base DOOM 3 ---')${NC}"
echo
msg "Please provide the location of Doom 3 .pk4 files:" \
    "Por favor, forneça a localização dos arquivos .pk4 do Doom 3:"
msg "Enter the full path (directory or .deb file):" \
    "Digite o caminho completo (diretório ou arquivo .deb):"
read -e -p "> " DOOM3_PATH

if [ -z "$DOOM3_PATH" ]; then
    error_exit "No path provided." \
               "Nenhum caminho fornecido."
fi

# Expand tilde to home directory
DOOM3_PATH="${DOOM3_PATH/#\~/$HOME}"

if [ -d "$DOOM3_PATH" ]; then
    copy_pk4_from_dir "$DOOM3_PATH" "$BASE_DIR"
elif [ -f "$DOOM3_PATH" ] && [[ "$DOOM3_PATH" == *.deb ]]; then
    extract_pk4_from_deb "$DOOM3_PATH" "$BASE_DIR"
else
    error_exit "Invalid path. Must be a directory or a .deb file." \
               "Caminho inválido. Deve ser um diretório ou arquivo .deb."
fi

echo
echo -e "${GREEN}✓ $(msg 'Doom 3 base game installed successfully!' 'Jogo base Doom 3 instalado com sucesso!')${NC}"
echo

# Ask about Resurrection of Evil expansion
msg "Do you want to install the Resurrection of Evil expansion? (y/n):" \
    "Deseja instalar a expansão Resurrection of Evil? (s/n):"
read -p "> " INSTALL_ROE

if [[ "$INSTALL_ROE" =~ ^[YySs]$ ]]; then
    echo
    echo -e "${BLUE}$(msg '--- Resurrection of Evil Expansion Installation ---' '--- Instalação da Expansão Resurrection of Evil ---')${NC}"
    echo
    
    # Create d3xp directory
    mkdir -p "$D3XP_DIR"
    
    msg "Please provide the location of Resurrection of Evil .pk4 files:" \
        "Por favor, forneça a localização dos arquivos .pk4 do Resurrection of Evil:"
    msg "Enter the full path (directory or .deb file):" \
        "Digite o caminho completo (diretório ou arquivo .deb):"
    read -e -p "> " ROE_PATH
    
    if [ -z "$ROE_PATH" ]; then
        error_exit "No path provided." \
                   "Nenhum caminho fornecido."
    fi
    
    # Expand tilde to home directory
    ROE_PATH="${ROE_PATH/#\~/$HOME}"
    
    if [ -d "$ROE_PATH" ]; then
        copy_pk4_from_dir "$ROE_PATH" "$D3XP_DIR"
    elif [ -f "$ROE_PATH" ] && [[ "$ROE_PATH" == *.deb ]]; then
        extract_pk4_from_deb "$ROE_PATH" "$D3XP_DIR"
    else
        error_exit "Invalid path. Must be a directory or a .deb file." \
                   "Caminho inválido. Deve ser um diretório ou arquivo .deb."
    fi
    
    echo
    echo -e "${GREEN}✓ $(msg 'Resurrection of Evil expansion installed successfully!' 'Expansão Resurrection of Evil instalada com sucesso!')${NC}"
    
    # Download and install d3le.so mod for the expansion
    install_d3le_mod
fi

# Create launcher scripts and desktop entries
echo
create_launchers
echo
create_desktop_entries

# Final message
echo
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}$(msg 'Installation completed successfully!' 'Instalação concluída com sucesso!')${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo
msg "Now you can play using the following commands:" \
    "Agora você pode jogar usando os seguintes comandos:"
echo -e "  ${GREEN}doom3${NC} - $(msg 'Classic Doom 3' 'Doom 3 Clássico')"
echo -e "  ${GREEN}doom3-d3xp${NC} - $(msg 'Resurrection of Evil' 'Resurrection of Evil')"
echo
msg "Or launch from your application menu:" \
    "Ou iniciar pelo menu de aplicações:"
echo -e "  • Doom 3"
echo -e "  • Doom 3 Resurrection of Evil"
echo
msg "Game files installed in:" \
    "Arquivos do jogo instalados em:"
echo -e "  ${BLUE}$DHEWM3_DIR${NC}"
echo

# Cleanup temporary directories (just in case trap didn't fire)
cleanup_temp_dirs
