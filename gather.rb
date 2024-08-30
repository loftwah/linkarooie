#!/usr/bin/env ruby

require 'optparse'
require 'open3'

# Default output method and content
output_method = 'stdout'
output_content = ""

# Detect the operating system
os_type = RbConfig::CONFIG['host_os']

# Determine the clipboard command based on the OS
clipboard_command = case os_type
                    when /darwin/
                      'pbcopy'
                    when /linux/
                      'xclip -selection clipboard'
                    else
                      puts "Unsupported OS type: #{os_type}"
                      exit 1
                    end

# Check if required commands are available
def check_dependency(command, install_instructions)
  unless system("command -v #{command} > /dev/null")
    puts "#{command} is not installed. Please install it using:"
    puts install_instructions
    exit 1
  end
end

# Check for necessary dependencies
check_dependency('tree', "sudo apt install tree") if os_type =~ /linux/
check_dependency('xclip', "sudo apt install xclip") if os_type =~ /linux/ && clipboard_command == 'xclip -selection clipboard'

# Usage message
def usage
  puts "Usage: #{$0} [-o output_method] [-f output_file]"
  puts "  -o, --output         Output method: stdout, clipboard, or file (default: stdout)"
  puts "  -f, --file           Output file path (required if output method is file)"
  exit 1
end

# Parse command-line arguments
options = {}
OptionParser.new do |opts|
  opts.on('-o', '--output OUTPUT', 'Output method') { |o| options[:output] = o }
  opts.on('-f', '--file FILE', 'Output file path') { |f| options[:file] = f }
  opts.on('-h', '--help', 'Show help') { usage }
end.parse!

output_method = options[:output] if options[:output]
output_file = options[:file]

# Function to output content based on selected output method
def output(content)
  $output_content ||= ""
  $output_content += "#{content}\n"
end

# Function to finalize output
def finalize_output(output_method, output_file, clipboard_command)
  case output_method
  when 'stdout'
    puts $output_content
  when 'clipboard'
    IO.popen(clipboard_command, 'w') { |clipboard| clipboard.write($output_content) }
  when 'file'
    File.write(output_file, $output_content)
  else
    puts 'Invalid output method'
    exit 1
  end
end

# Check if file output is specified but no file is given
if output_method == 'file' && output_file.nil?
  puts 'Error: Output file must be specified when using file output method.'
  usage
end

# Start the script output
output "=== Directory Structure and File Contents ===\n"

# Functions for tasks
def show_tree(dir)
  if system('command -v tree > /dev/null')
    output "Tree for #{dir}:\n"
    output `tree #{dir}`
  else
    # Fallback: List directories recursively if 'tree' is not available
    output "Directory listing for #{dir} (fallback):\n"
    output Dir.glob("#{dir}/**/*").map { |f| File.directory?(f) ? "#{f}/" : f }.join("\n")
  end
end

def show_file_content(file)
  output "Contents of #{file}:\n"
  output File.read(file)
end

# Main tasks
show_tree 'app'
show_tree 'db'

output "=== Contents of Ruby Files in db/ ===\n"
Dir.glob('db/*.rb').each do |file|
  output "File: #{file}\n"
  output File.read(file)
end

show_tree 'config'

output "=== Config Files ===\n"
show_file_content 'config/database.yml'

output "=== Contents of Ruby Files in config/environments/ ===\n"
Dir.glob('config/environments/*.rb').each do |file|
  output "File: #{file}\n"
  output File.read(file)
end

show_file_content 'config/routes.rb'
show_file_content 'config/tailwind.config.js'

show_tree 'terraform'

output "=== Terraform Files ===\n"
Dir.glob('terraform/**/*.tf').each do |file|
  output "Processing file: #{file}\n"
  output File.read(file)
end

output "=== App Directory Files (Ruby and HTML ERB) ===\n"
Dir.glob('app/**/*.{rb,html.erb}').each do |file|
  output "Processing file: #{file}\n"
  output File.read(file)
end

output "=== GitHub Workflow Files ===\n"
Dir.glob('.github/workflows/*.yml').each do |file|
  output "File: #{file}\n"
  output File.read(file)
end

show_tree 'bin'

output "=== Spec Directory Files (Ruby) ===\n"
Dir.glob('spec/**/*.rb').each do |file|
  output "File: #{file}\n"
  output File.read(file)
end

output "=== Public Directory (One Level Deep) ===\n"
output `tree -L 1 public` if system('command -v tree > /dev/null')

output "=== Rake Files in lib/tasks/ ===\n"
Dir.glob('lib/tasks/*.rake').each do |file|
  output "File: #{file}\n"
  output File.read(file)
end

output "=== Other Configurations and Files ===\n"
['Procfile.dev', 'Gemfile', 'docker-compose.prod.yml', 'Dockerfile', '.ruby-version', 'package.json'].each do |file|
  show_file_content file
end

output "=== Vite Configuration Files ===\n"
Dir.glob('vite.config.*').each do |file|
  output "File: #{file}\n"
  output File.read(file)
end

['.gitignore', '.dockerignore'].each do |file|
  show_file_content file
end

output "=== Generated env.example from .env ===\n"
output `sed 's/=.*/=/' .env`

# End of script
output "=== End of Output ===\n"

# Finalize output
finalize_output(output_method, output_file, clipboard_command)
