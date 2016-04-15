# Setup Environment

## Development

```
$ brew install mysql
$ ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
$ mysql.server start
```

```
$ mysql -u root
> CREATE DATABASE aniradime_development DEFAULT CHARACTER SET utf8;
> CREATE DATABASE aniradime_test DEFAULT CHARACTER SET utf8;
> GRANT ALL PRIVILEGES ON aniradime_development.* TO aniradime@localhost IDENTIFIED BY 'aniradi.me';
> GRANT ALL PRIVILEGES ON aniradime_test.* TO aniradime@localhost IDENTIFIED BY 'aniradi.me';
```

## Production

Sakura VPS 標準インストール（CentOS 6）の初期状態からのセットアップ方法です。

* Environment: production
* IP Address 153.126.131.49
* User: apps

## Create user account

ルートユーザーで ssh ログインします。

```
$ ssh root@153.126.131.49
```

言語設定を日本語化します。

```
# vim /etc/sysconfig/i18n
```

```
LANG="ja_JP.UTF-8"
LC_CTYPE="ja_JP.UTF-8"
SYSFONT="latarcyrheb-sun16"
```

一般ユーザー apps を追加し、ルート権限で作業できるようにします。

```
# useradd apps
# passwd apps
# usermod -G wheel apps
# visudo
```

コメントアウトされている部分を解除します。

```
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL) ALL
```

以降、すべての作業は一般ユーザーでログインした状態のホームディレクトリ /home/apps で作業を行います。

```
# exit
$ ssh apps@153.126.131.49
```

ホームディレクトリのパーミッションを 701 に変更します。パスワードから鍵認証に切り替えます。

```
$ chmod 701 /home/apps/
$ mkdir .ssh
$ chmod 700 .ssh/
$ exit
```

作業用マシンの公開鍵を送ります。パスワードなしで apps ユーザーでログインできるようになります。

```
$ scp ~/.ssh/id_rsa.pub apps@153.126.131.49:~/.ssh/authorized_keys
$ ssh apps@153.126.131.49
```

ルートユーザーでログインできないように、パスワードによるログインを禁止します。

```
$ sudo sed -i.bk 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
$ sudo sed -i.bk2 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
$ sudo /usr/sbin/sshd -t
$ sudo service sshd restart
```

## Installation Firewall

公開するポートを設定します。設定ファイルはこの README.md と同ディレクトリにある iptables を貼り付けます。

```
$ sudo vim /etc/sysconfig/iptables
$ sudo service iptables start
```

## Add deploy key to GitHub repo

GitHub に公開鍵を登録して、レポジトリをクローンします。

```
$ ssh-keygen -t rsa -b 4096 -C "rakuishi@gmail.com"
$ cat .ssh/id_rsa.pub
$ git clone git@github.com:rakuishi/aniradi.me.git aniradi.me
```

## yum install

Ruby, Ruby on Rails, MySQL に必要なパッケージをインストールします。

```
$ sudo yum clean all
$ sudo yum update
$ sudo yum install gcc gcc-c++ autoconf make wget git zlib-devel openssl-devel libyaml-devel readline-devel libxml2-devel libxslt-devel libffi-devel mysql mysql-devel mysql-server nodejs
```

設定ファイルはこの README.md と同ディレクトリにある my.cnf を貼り付けます。

```
$ sudo vim /etc/my.cnf
$ sudo /etc/rc.d/init.d/mysqld start
$ sudo chkconfig mysqld on
```

```
$ mysql -u root
> GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'XXXXXXXXXXXXXXXXXXXXXXXX';
> CREATE DATABASE aniradime_production DEFAULT CHARACTER SET utf8;
> GRANT ALL PRIVILEGES ON aniradime_production.* TO aniradime@localhost IDENTIFIED BY 'XXXXXXXXXXXXXXXXXXXXXXXX';
```

## Installation Ruby with RVM

Ruby Version Manager（RVM）をインストールし、RVM を使用するユーザーを `rvm` グループに追加して、反映するために一度ログアウトします。

```
$ sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ \curl -L https://get.rvm.io | sudo bash -s stable
$ sudo usermod -a -G rvm apps
$ exit
```

rvm.sh によってパスを通した後に、Ruby 2.2.3 をインストールします。

```
$ source /etc/profile.d/rvm.sh
$ rvm install 2.2.3
$ gem install bundler
```

ドキュメントをインストールしないように設定します。

```
$ echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
```

Ruby on Rails を付属の WEBrick で動かします。

```
$ cd aniradi.me
$ ./bin/bundle install --path vendor/bundle
```

application.yml を作成し、`SECRET_KEY_BASE` と `ANIRADIME_DATABASE_PASSWORD` に適切な値を指定します。

```
$ ./bin/bundle exec rake secret
$ cp config/application.yml.example config/application.yml
$ vim config/application.yml
```

データベースのマイグレーションを行います。開発環境は production を指定しています。

```
$ ./bin/rake db:migrate RAILS_ENV=production
$ ./bin/rake db:seed RAILS_ENV=production
$ ./bin/rails s -b 0.0.0.0 -p 3000 -e production
```

[http://153.126.131.49:3000/](http://153.126.131.49:3000/) から Ruby on Rails の起動が確認できます。

## Unicorn

config/unicorn.rb で指定している /var/run/unicorn/ の権限を与えます。

```
$ gem install unicorn-rails
$ sudo mkdir /var/run/unicorn
$ sudo chmod 777 /var/run/unicorn/
$ unicorn_rails -c /home/apps/aniradi.me/config/unicorn.rb -E production -D
$ ps aux | grep unicorn
```

## Nginx

Nginx をインストールし、起動と、サーバーが再起動した時に、自動で立ち上がるように設定します。[http://153.126.131.49/](http://153.126.131.49/) から Nginx の起動が確認できます。

```
$ sudo yum install nginx
$ sudo service nginx start
$ sudo chkconfig nginx on
```

次に実行されているプロセス `unicorn_rails` を見るように Nginx の設定を変えます。設定ファイルはこの README.md と同ディレクトリにある nginx.default.conf を貼り付けます。

```
$ sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
$ sudo vim /etc/nginx/conf.d/default.conf
$ sudo /etc/init.d/nginx configtest
$ sudo service nginx reload
```

[http://153.126.131.49/](http://153.126.131.49/) から Ruby on Rails の起動が確認できます。

## Create init.d script

この状態だとサーバーを再起動 `sudo reboot` した時に、`unicorn_rails` プロセスが自動で起動されません。自動で起動するように、スクリプトを作成します。設定ファイルはこの README.md と同ディレクトリにある unicorn を貼り付けます。

```
$ sudo vim /etc/init.d/unicorn
$ sudo chmod 755 /etc/init.d/unicorn
$ sudo chkconfig unicorn on
```

起動スクリプトから一般ユーザー apps が、`unicorn_rails` プロセスを立ち上げる都合上、root ユーザーは tty 無しの `sudo` を許可するようにします。

```
$ sudo visudo
```

`Defaults:root !requiretty` を書き加えます。

```
#
# Disable "ssh hostname sudo <cmd>", because it will show the password in clear.
#         You have to run "ssh -t hostname sudo <cmd>".
#
Defaults    requiretty
Defaults:root !requiretty
```

再起動して Ruby on Rails の起動を確認します。

```
$ sudo reboot
```

表示されていたら成功です。
