#!/bin/bash

# Default output method
output_method="stdout"
output_content=""

# Detect the operating system
os_type="$(uname -s)"

# Determine the clipboard command based on the OS
if [[ "$os_type" == "Darwin" ]]; then
    clipboard_command="pbcopy"
elif [[ "$os_type" == "Linux" ]]; then
    clipboard_command="xclip -selection clipboard"
    # Check if xclip is installed
    if ! command -v xclip &> /dev/null; then
        echo "xclip is not installed. Please install it using: sudo apt install xclip"
        exit 1
    fi
else
    echo "Unsupported OS type: $os_type"
    exit 1
fi

# Usage message
usage() {
    echo "Usage: $0 [-o output_method] [-f output_file]"
    echo "  -o, --output         Output method: stdout, clipboard, or file (default: stdout)"
    echo "  -f, --file           Output file path (required if output method is file)"
    exit 1
}

# Parse command-line arguments
while [[ "$1" != "" ]]; do
    case $1 in
        -o | --output )        shift
                               output_method=$1
                               ;;
        -f | --file )          shift
                               output_file=$1
                               ;;
        -h | --help )          usage
                               exit
                               ;;
        * )                    usage
                               exit 1
    esac
    shift
done

# Function to output content based on selected output method
output() {
    local content="$1"
    output_content+="$content\n"
}

# Function to finalize output
finalize_output() {
    case $output_method in
        "stdout")     echo -e "$output_content" ;;
        "clipboard")  echo -e "$output_content" | $clipboard_command ;; # Use appropriate clipboard command
        "file")       echo -e "$output_content" > "$output_file" ;;
        *)            echo "Invalid output method"; exit 1 ;;
    esac
}

# Check if file output is specified but no file is given
if [[ $output_method == "file" && -z $output_file ]]; then
    echo "Error: Output file must be specified when using file output method."
    usage
fi

# Start the script output
output "=== Directory Structure and File Contents ===\n"

# Functions for tasks
show_tree() {
    local dir="$1"
    output "Tree for $dir:\n"
    output "$(tree "$dir")\n"
}

show_file_content() {
    local file="$1"
    output "Contents of $file:\n"
    output "$(cat "$file")\n"
}

# Main tasks
show_tree "app"
show_tree "db"

output "=== Contents of Ruby Files in db/ ===\n"
for file in db/*.rb; do
    output "File: $file\n"
    output "$(cat "$file")\n"
done

show_tree "config"

output "=== Config Files ===\n"
show_file_content "config/database.yml"

output "=== Contents of Ruby Files in config/environments/ ===\n"
for file in config/environments/*.rb; do
    output "File: $file\n"
    output "$(cat "$file")\n"
done

show_file_content "config/routes.rb"
show_file_content "config/tailwind.config.js"

show_tree "terraform"

output "=== Terraform Files ===\n"
find ./terraform -type f -name "*.tf" -exec sh -c 'echo "Processing file: $1"; cat "$1"' _ {} \; | while read -r line; do output "$line\n"; done

output "=== App Directory Files (Ruby and HTML ERB) ===\n"
find ./app -type f \( -name "*.rb" -o -name "*.html.erb" \) -exec sh -c 'echo "Processing file: $1"; cat "$1"' _ {} \; | while read -r line; do output "$line\n"; done

output "=== GitHub Workflow Files ===\n"
for file in .github/workflows/*.yml; do
    output "File: $file\n"
    output "$(cat "$file")\n"
done

show_tree "bin"

output "=== Spec Directory Files (Ruby) ===\n"
find spec -type f -name "*.rb" -exec sh -c 'for file; do echo "$file"; cat "$file"; done' _ {} + | while read -r line; do output "$line\n"; done

output "=== Public Directory (One Level Deep) ===\n"
output "$(tree -L 1 public)\n"

output "=== Rake Files in lib/tasks/ ===\n"
for file in lib/tasks/*.rake; do
    output "File: $file\n"
    output "$(cat "$file")\n"
done

output "=== Other Configurations and Files ===\n"
show_file_content "Procfile.dev"
show_file_content "Gemfile"
show_file_content "docker-compose.prod.yml"
show_file_content "Dockerfile"
show_file_content ".ruby-version"
show_file_content "package.json"

output "=== Vite Configuration Files ===\n"
for file in vite.config.*; do
    output "File: $file\n"
    output "$(cat "$file")\n"
done

show_file_content ".gitignore"
show_file_content ".dockerignore"

output "=== Generated env.example from .env ===\n"
output "$(sed 's/=.*/=/' .env)\n"

# End of script
output "=== End of Output ===\n"

# Finalize output
finalize_output
