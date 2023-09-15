### Setting up Linkarooie: A Step-by-Step Guide

#### Prerequisites

* Ubuntu 22.04 installed
* sudo access

#### Update Package Index

1. Open your terminal and run the following command to update your package list:

   ```bash
   sudo apt-get update
   ```

#### Install Common Dependencies

2. Install basic dependencies required for setting up Ruby and other packages:

   ```bash
   sudo apt-get install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev -y
   ```

#### Install rbenv and ruby-build

3. Execute the following command to download and install rbenv:

   ```bash
   curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash -
   ```

4. Add rbenv to your PATH by adding these lines to your `~/.bashrc`:

   ```bash
   export PATH="$HOME/.rbenv/bin:$PATH"
   eval "$(rbenv init -)"
   ```

5. Source your `.bashrc`:

   ```bash
   source ~/.bashrc
   ```

6. Install `ruby-build` as an rbenv plugin:

   ```bash
   git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
   ```

   > **Note** I didn't need this on Ubuntu 22.04 on AWS. I'm not sure if it's because I already had it installed or if it's because it's already included in the rbenv installer. This has been an issue for me before.

#### Install Ruby 3.2.2

7. Now install Ruby 3.2.2 with rbenv:

   ```bash
   rbenv install 3.2.2
   ```

8. Set it as the global Ruby version:

   ```bash
   rbenv global 3.2.2
   ```

#### Install NodeJS and Yarn

9. Add nodesource repository for NodeJS:

   ```bash
   curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
   ```

10. Install NodeJS and Yarn:

    ```bash
    sudo apt-get install nodejs yarn -y
    ```

#### Install SQLite3

11. Install SQLite3 from the Ubuntu repositories:

    ```bash
    sudo apt-get install sqlite3 libsqlite3-dev -y
    ```

#### Set up the Linkarooie project

12. Clone your Linkarooie repository:

    ```bash
    git clone https://github.com/loftwah/linkarooie.git
    ```

13. Navigate to the project directory:

    ```bash
    cd linkarooie
    ```

14. Install project dependencies:

    ```bash
    bundle install
    yarn install
    ```

15. Create and migrate the SQLite3 database:

    ```bash
    rails db:create db:migrate db:seed
    ```

16. Precompile assets:

    ```bash
    rails assets:precompile
    ```

17. Start the Rails server:

    ```bash
    rails s
    ```

18. Visit <http://<your-ip:3000> to see your Linkarooie dashboard in action.