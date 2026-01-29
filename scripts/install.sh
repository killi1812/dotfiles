#!/bin/zsh

INPUT_FILE="deps.sh"

if [ "$EUID" -eq 0 ]; then
  echo "Error: Please do not run this script as root/sudo."
  echo "Yay handles privilege elevation internally."
  exit 1
fi

if ! command -v yay &> /dev/null; then
    echo "Error: yay is not installed on this system."
    echo "Please install yay first (https://github.com/Jguer/yay)."
    exit 1
fi

echo "Reading dependencies from $INPUT_FILE..."

# 3. Read the file, stripping comments and empty lines
# - sed 's/#.*//': Removes comments (text after #)
# - xargs: Trims whitespace and converts newlines to spaces
PACKAGES=$(sed 's/#.*//' "$INPUT_FILE" | xargs)

if [ -z "$PACKAGES" ]; then
    echo "Error: No packages found in $INPUT_FILE."
    exit 1
fi

# 4. Install
echo "--------------------------------------"
echo "Targets: $PACKAGES"
echo "--------------------------------------"

yay -S --needed --noconfirm --norebuild --noredownload --noremovemake $PACKAGES

if [ $? -eq 0 ]; then
    echo "✅ Success! All dependencies installed."
else
    echo "❌ Installation failed."
    exit 1
fi
