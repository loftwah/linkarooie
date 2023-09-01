# Loftwah's Custom Dashboard

This is a custom dashboard for my personal use.

## Usage

Start up your Docker services (this assumes you've navigated to the directory containing your docker-compose.yml):

`docker compose up`

This starts up the services defined in docker-compose.yml. You might want to run this command in a separate terminal window because it will occupy your terminal with logs.

Open a new terminal window and create the database:

`docker compose run web rails db:create`

Run the database migrations:

`docker compose run web rails db:migrate`

(Optional) If you have seed data, run:

`docker compose run web rails db:seed`
