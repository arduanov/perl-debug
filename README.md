Введение
====
Этот репозиторий содержит примеры конфигурации для запуска Docker контейнера с perl сервисом и настройкой дебаггера.

Директории проекта:

* [docker-app](docker-app) - докер контейнеры perl и nginx
* [docker-uwsgi](docker-uwsgi) - докер контейнеры uwsgi и nginx
* [lib](lib) - код запускаемого сервиса

Подготовка
=========

Запуск docker compose
---------------------
* Написать [Dockerfile](docker-app/Dockerfile) для запуска Perl сервиса
* Написать [docker-compose.yml](docker-app/docker-compose.yml) для запуска Perl сервиса
* Запустить докер контейнеры из директории с файлом [docker-compose.yml](docker-app/docker-compose.yml)
    ```bash
    cd docker-app
    docker compose up --build
    ```
* Запущенный сервис будет доступен по адресу http://localhost

Perl модули из Docker контейнера в Jetbrains IDE
--------------
* Установить любую Jetbrains IDE, есть абсолютно бесплатная [Jetbrains Community Edition](https://www.jetbrains.com/idea/download/)
* Установить плагин Perl в Jetbrains IDE
  * Settings > Plugins > Perl ([скрин](doc/images/001_perl_plugin.png))
* Настроить интерпретатор Perl
  * Settings > Languages & Frameworks > Perl5 ([скрин](doc/images/002_perl_config.png))
* Выбрать интерпретатор в докер контейнере
  * Docker > Add System Perl ([скрин](doc/images/002_perl_config.png))
* Выбрать докер контейнер ([скрин](doc/images/003_perl_docker_container.png))
  * Выбрать путь к перл бинарнику ([скрин](doc/images/004_perl_path.png))
    * Это либо `/usr/local/bin/perl`, либо `/usr/bin/perl`
* IDE начнет индексацию perl модулей в докер контейнере
* При обновлении зависимостей в докере - необходимо переиндексировать перл либы в IDE
  * Tools > Perl5 > Refresh Interpreter Information ([скрин](doc/images/005_perl_refresh.png))
* Теперь в Jetbrains IDE есть все Perl модули

Настройка дебаггера
=========

PSGI / Plack
--------
* В [Dockerfile](docker-app/Dockerfile) добавить команду установки дебаггера Camelcadedb
  ```dockerfile
  RUN \
    cpanm Devel::Camelcadedb \
    && rm -rf /root/.cpanm
  ```
* Прописать загрузку модуля Camelcadedb в параметре `command` в `Dockerfile`:
    * Для Server::PSGI `command: [ "perl", "-d:Camelcadedb", "/opt/app/docker-app/app/app.pl" ]`
    * Для Plack `command: [ "plackup", "-p", "3000", "-M","Devel::Camelcadedb" , "/opt/app/docker-app/app/app-plack.pl"]`
* Прописать энвы в [docker-compose.yml](docker-app/docker-compose.yml)
  ```
  environment:
    PERL5LIB: /opt/app/lib
    PERL5_DEBUG_AUTOSTART: ${DEBUG-0}
    PERL5_DEBUG_ROLE: client
    PERL5_DEBUG_HOST: host.docker.internal
    PERL5_DEBUG_PORT: 40000
  ```

* Настроить IDE для дебага
  * Открыть [docker restart app.run.xml](docker-app/.run/docker%20restart%20app.run.xml) и импортировать настройки ([скрин 1](doc/images/006_docker_conf.png), [скрин 2](doc/images/007_docker_conf_settings.png))
  * Открыть [Perl debug app.run.xml](docker-app/.run/Perl%20debug%20app.run.xml) и импортировать настройки ([скрин 1](doc/images/008_perl_debug_xml.png), [скрин 2](doc/images/009_perl_debug_settings.png))
* Выбрать конфигурацию `Perl debug app` ([скрин](doc/images/010_select_debug.png))
* Запустить докер контейнеры из директории с файлом [docker-compose.yml](docker-app/docker-compose.yml)
    ```bash
    cd docker-app
    docker compose up
    ```
* Запустить дебаггер ([скрин](doc/images/011_run_debug.png))

uWSGI
-----
* В [Dockerfile](docker-uwsgi/Dockerfile) добавить команду установки дебаггера Camelcadedb и Plack::Middleware::Camelcadedb
  ```dockerfile
  RUN cpanm Devel::Camelcadedb \
    Plack::Middleware::Camelcadedb \
    && rm -rf /root/.cpanm
  ```
* Прописать энвы в [docker-compose.yml](docker-uwsgi/docker-compose.yml)
  ```
  environment:
    PERL5LIB: /opt/app/lib
    PERL5_DEBUG_HOST: "host.docker.internal"
    PERL5_DEBUG_PORT: 40000
  ```
* Настроить IDE для дебага
  * Открыть [Perl debug uwsgi.run.xml](docker-uwsgi/.run/Perl%20debug%20uwsgi.run.xml) и импортировать настройки ([скрин 1](doc/images/020_uwsgi_debug.png), [скрин 2](doc/images/021_uwsgi_conf.png))
* Выбрать конфигурацию `Perl debug uwsgi` ([скрин](doc/images/012_select_uwsgi.png))
* Запустить докер контейнеры из директории с файлом [docker-compose.yml](docker-app/docker-compose.yml)
    ```bash
    cd docker-app
    docker compose up
    ```
* Запустить дебаггер ([скрин](doc/images/013_run_uwsgi_debug.png))

Работа с дебаггером
=========
* Убедиться что дебаггер запущен
* Поставить брейкпонт в [Base.pm](lib/App/Base.pm) ([скрин](doc/images/030_set_breakpoint.png))
* Открыть в браузере http://localhost
* Окно IDE станет активным и выполнение кода остановится на брейкпойнте ([скрин](doc/images/031_breakpoint_active.png))
* Для продолжения работы кода есть несколько вариантов:
  * Resume Program - перейти к следующему брейкпойнту ([скрин](doc/images/032_debug_resume.png))
  * Step Over - перейти к следующей строке ([скрин](doc/images/033_debug_step_over.png))
  * Step Into - перейти к коду вызываемой функции ([скрин](doc/images/034_debug_step_into.png))