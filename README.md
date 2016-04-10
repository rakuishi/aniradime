# aniradi.me

## ローカル環境

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

## License

> Copyright 2016 aniradi.me
> 
> Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
> 
> http://www.apache.org/licenses/LICENSE-2.0
> 
> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
