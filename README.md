# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    3.1.1

Requirements

- Ruby >= 3.1.1
- Rails >= 7.2
- PostgreSQL
- Redis (for background jobs with Sidekiq)

# Clone the repository

# run in console
git clone https://github.com/Nageshwardahare/diatoz_task.git

cd diatoz_task

bundle install

rails assets:precompile

# setup database.yml file (user_name and password)

rails db:create

rails db:migrate

rails db:seed     ( This will create a default admin user)

bundle exec sidekiq

rails server



