Linda Hue
=========
controll [Philips's hue](http://www.meethue.com) with [RocketIO::Linda](https://github.com/shokai/sinatra-rocketio-linda)

* https://github.com/shokai/linda-hue
* watch tuple ["hue", "on"] and turn on all hue
* watch tuple ["hue", "off"] and turn off all hue
* watch tuple ["hue", "random"] and set random HSB value.

<img src="http://gyazo.com/bd7c937a43d3c272aa0dfa46f76d6282.gif">


Dependencies
------------
- hue
- Ruby 1.8.7 ~ 2.0.0
- [LindaBase](https://github.com/shokai/linda-base)


Install Dependencies
--------------------

Install Rubygems

    % gem install bundler foreman
    % bundle install


Run
---

set ENV var "LINDA_BASE", "LINDA_SPACE" and "ARDUINO"

    % export LINDA_BASE=http://linda.example.com
    % export LINDA_SPACE=test
    % bundle exec ruby linda-hue.rb


oneline

    % LINDA_BASE=http://linda.example.com LINDA_SPACE=test  bundle exec ruby linda-hue.rb


Install as Service
------------------

for launchd (Mac OSX)

    % sudo foreman export launchd /Library/LaunchDaemons/ --app linda-hue -u `whoami`
    % sudo launchctl load -w /Library/LaunchDaemons/linda-hue-main-1.plist


for upstart (Ubuntu)

    % sudo foreman export upstart /etc/init/ --app linda-hue -d `pwd` -u `whoami`
    % sudo service linda-hue start
