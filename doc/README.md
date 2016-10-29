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

Amazon EC2 - Amazon Linux AMI 2016.09 の初期状態からのセットアップ方法です。

* Environment: production
* User: ec2-user

## yum

Git, Ruby, Ruby on Rails, MySQL に必要なパッケージをインストールします。

```
$ sudo yum update
$ sudo yum install gcc gcc-c++ autoconf make wget git zlib-devel openssl-devel libyaml-devel readline-devel libxml2-devel libxslt-devel libffi-devel mysql mysql-devel mysql-server nodejs
```

## Time Zone

```
$ sudo vi /etc/sysconfig/clock 
$ cat /etc/sysconfig/clock 
ZONE="Asia/Tokyo"
UTC=false
```

## Password

`sudo` コマンドを使用する前にパスワード入力を求めるように変更します。

```
$ sudo passwd ec2-user
$ sudo visudo -f /etc/sudoers.d/cloud-init
ec2-user ALL = NOPASSWD: ALL
ec2-user ALL=(ALL) ALL
```

## Add deploy key to GitHub repo

GitHub に公開鍵を登録して、レポジトリをクローンします。

```
$ ssh-keygen -t rsa -b 4096 -C "rakuishi@gmail.com"
$ cat .ssh/id_rsa.pub
$ git clone git@github.com:rakuishi/aniradime.git aniradime
```

## Installation MySQL

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
$ sudo usermod -a -G rvm ec2-user
$ exit
```

rvm.sh によってパスを通した後に、Ruby 2.2.3 をインストールします。

```
$ source /etc/profile.d/rvm.sh
$ rvm install 2.2.3
$ gem install bundler
```

ドキュメントをインストールしないように設定し、プロジェクトで使われている Gem をインストールします。

```
$ echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
$ cd aniradime
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

http://[Public IP]:3000/ から Ruby on Rails の起動が確認できます。

## Unicorn

config/unicorn.rb で指定している /var/run/unicorn/ の権限を与えます。

```
$ cd ../
$ gem install unicorn-rails
$ sudo mkdir /var/run/unicorn
$ sudo chmod 777 /var/run/unicorn/
$ unicorn_rails -c /home/ec2-user/aniradime/config/unicorn.rb -E production -D
$ ps aux | grep unicorn
```

## Nginx

Nginx をインストールし、起動と、サーバーが再起動した時に、自動で立ち上がるように設定します。http://[Public IP]/ から Nginx の起動が確認できます。

```
$ sudo yum install nginx
$ sudo service nginx start
$ sudo chkconfig nginx on
```

次に実行されているプロセス `unicorn_rails` を見るように Nginx の設定を変えます。設定ファイルはこの README.md と同ディレクトリにある nginx.default.conf を貼り付けます。

```
$ sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk
$ sudo vim /etc/nginx/nginx.conf
$ sudo /etc/init.d/nginx configtest
$ sudo service nginx reload
```

http://[Public IP]/ から Ruby on Rails の起動が確認できます。

## Create init.d script

この状態だとサーバーを再起動 `sudo reboot` した時に、`unicorn_rails` プロセスが自動で起動されません。自動で起動するように、スクリプトをシンボリックリンクで結び付けます。

```
$ sudo ln -s /home/ec2-user/aniradime/aniradime /etc/init.d/aniradime
$ sudo chkconfig aniradime on
```
