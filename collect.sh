#!/bin/bash
# collect_rails_info.sh - Custom collector for Linkarooie project

OUTPUT_FILE="rails_project_info.txt"

echo "Rails Project Configuration Info" > $OUTPUT_FILE
echo "Generated on $(date)" >> $OUTPUT_FILE
echo "------------------------------------" >> $OUTPUT_FILE

# Function to add section header
add_section() {
    echo "=== $1 ===" >> $OUTPUT_FILE
    if [ -f "$2" ]; then
        cat "$2" >> $OUTPUT_FILE
        echo "" >> $OUTPUT_FILE
        echo "------------------------------------" >> $OUTPUT_FILE
    fi
}

# Core Files
add_section "Gemfile" "Gemfile"
add_section "Gemfile.lock" "Gemfile.lock"
add_section "package.json" "package.json"
add_section "package-lock.json" "package-lock.json"

# Config Files
add_section "config/application.rb" "config/application.rb"
add_section "config/routes.rb" "config/routes.rb"
add_section "config/database.yml" "config/database.yml"
add_section "config/environments/development.rb" "config/environments/development.rb"
add_section "config/environments/production.rb" "config/environments/production.rb"
add_section "config/environments/test.rb" "config/environments/test.rb"

# All initializers
for f in config/initializers/*.rb; do
    add_section "$(basename $f)" "$f"
done

# Key Models
MODELS=(
    "app/models/achievement.rb"
    "app/models/achievement_view.rb"
    "app/models/application_record.rb"
    "app/models/daily_metric.rb"
    "app/models/link.rb"
    "app/models/link_click.rb"
    "app/models/page_view.rb"
    "app/models/user.rb"
    "app/models/waiting_list.rb"
)

for model in "${MODELS[@]}"; do
    add_section "$(basename $model)" "$model"
done

# Key Controllers
CONTROLLERS=(
    "app/controllers/application_controller.rb"
    "app/controllers/achievements_controller.rb"
    "app/controllers/analytics_controller.rb"
    "app/controllers/links_controller.rb"
    "app/controllers/pages_controller.rb"
    "app/controllers/users/registrations_controller.rb"
    "app/controllers/users_controller.rb"
    "app/controllers/waiting_lists_controller.rb"
)

for controller in "${CONTROLLERS[@]}"; do
    add_section "$(basename $controller)" "$controller"
done

# Services
add_section "digital_ocean_spaces_service.rb" "app/services/digital_ocean_spaces_service.rb"
add_section "open_graph_image_generator.rb" "app/services/open_graph_image_generator.rb"

# Jobs
JOBS=(
    "app/jobs/aggregate_metrics_job.rb"
    "app/jobs/application_job.rb"
    "app/jobs/backup_database_job.rb"
    "app/jobs/generate_open_graph_image_job.rb"
    "app/jobs/send_waiting_list_report_job.rb"
)

for job in "${JOBS[@]}"; do
    add_section "$(basename $job)" "$job"
done

# Middleware
add_section "page_view_tracker.rb" "app/middleware/page_view_tracker.rb"

# Important Configuration Files
add_section "vite.config.mts" "vite.config.mts"
add_section "tailwind.config.js" "config/tailwind.config.js"
add_section "Dockerfile" "Dockerfile"
add_section "docker-compose.prod.yml" "docker-compose.prod.yml"
add_section "docker-compose.test.yml" "docker-compose.test.yml"

# Version Information
echo "=== Version Information ===" >> $OUTPUT_FILE
echo "Ruby version: $(ruby -v)" >> $OUTPUT_FILE
echo "Rails version: $(rails -v)" >> $OUTPUT_FILE
echo "Node version: $(node -v)" >> $OUTPUT_FILE
echo "------------------------------------" >> $OUTPUT_FILE

echo "Collection complete! Check $OUTPUT_FILE for the gathered information."