# Nower Server

> Nower is a platform that allows mobile users to find promotions that several stores near to them
  may offer. Those promotions are presented according to the users interests and wishes and the
  particularity is that they would expire in a short period or even run out of stock really fast.
  That is so because the idea is to offer access to exclusive promos.

**Nower server** handles the interactions between both clients (Mobile and web applications), deals
with the use cases and stores the information regarding users, promos and redemptions.

It has a simple REST HTTP API so that it can be used with ease.

## Table of contents

  * [Dependencies](#dependencies)
  * [Setup](#setup)
  * [How to get Nower up and running](#how-to-get-nower-up-and-running)
  * [API Documentation](#api-documentation)

## Dependencies

Nower server is powered by great tech. Make sure these are present in your server box:

- [Ruby]\* 2.3.1+
- [Rails]\* 5.0.0+
- [PostgreSQL] 9.3

To install PostgreSQL you should execute the following command:

```ssh
$ apt-get install postgresql-9.3 postgresql-contrib-9.3 libpq-dev
```

\* Recommended to install with [RVM](https://rvm.io/).

## Setup

Make sure you have a PostgreSQL role named ``nower`` with ``CREATEDB`` and ``SUPERUSER``\*
attributes, and to match the database configuration in ``config/database.yml``, where all database
settings are found.

> By default, on a development environment (RAILS_ENV = development), Nower
expects a PostgreSQL
role called ``nower``, with ``CREATEDB``, ``SUPERUSER`` and ``LOGIN`` attributes, with
``nower`` for password.

\* ``SUPERUSER`` attribute is required because primary keys are auto-generated uuids, which will
require the installation of a PostgreSQL module that can only be installed with the ``SUPERUSER``
attribute.

You can create and configure the default, development user role by running
```sh
$ psql -h localhost -U postgres
```
or
```sh
$ sudo su - postgres
$ psql
```
You'll be prompted for role postgres' password, then
```sh
$ CREATE ROLE nower WITH SUPERUSER CREATEDB LOGIN;
$ \password nower
```
Enter the desired password you want to set for ``nower`` role. By default it is
expected to be ``nower``. If you set a different one, be sure to modify
``config/database.yml``.

Once the database role is configured, run

```sh
$ gem install bundler
$ bundle
$ rake db:create
$ rake db:migrate
```

The above commands will, respectively:

- Install [Bundler]
- Install Nower's dependencies.
- Create the database
- Create all tables and columns

## How to get Nower up and running

*Inside Nower's core folder:*

```sh
$ rails s -b 0.0.0.0
```
You'll see Puma's output indicating the port the server is running on, as well
as the amount of workers it's running. This configuration can be found in
Nower's ``config`` folder, in ``puma.rb``, where you can edit it.

## API Documentation

> **IMPORTANT**
> ----
> In order to parse YAML files to a proper JSON swagger documentation you would need to have a
> decent* version of [Node]** and the [multi-file-swagger] module globally installed.
>
> \* The task is working with node v7.10.0, some previous versions would work properly.\
> \** Recommended to install with [NVM](https://rvm.io/).
>
> ```
> $ npm install -g multi-file-swagger
> ```



Nower parses a YAML file with the [Swagger] documentation and uses [swagger-ui] to display it.
The `.yml` file is located at `app/doc/swagger.yml`, and running the rask:

```
$ rake nower:doc
```

Will parse it to a `.json` file which is used by the swagger-ui located in the root public folder.\
**NOTE:** The `swagger.yml` file contains some references to different `.yml` files, the node's
`multi-file-swagger` will resolve those references and build a single output `.json` file.

Then, use the `/` path to open Swagger.

A good alternative to write documentation efficiently is to run guard, which is installed for the
development environment, it will listen for the `.yml` file changes and parse it to `.json`
automatically.

```
$ bundle exec guard
```

**NOTE**: In order to test the endpoints through Swagger you must access the application using the
`api` subdomain. That is, you can create a local alias like: `api.local.nower.co` pointing to
`localhost`, and then use `http://api.local.nower.co:3000` to open Swagger.

[Ruby]:https://rvm.io/
[Rails]:http://rubyonrails.org/
[PostgreSQL]:http://www.postgresql.org/download/
[Bundler]:http://bundler.io/
[Swagger]:http://swagger.io/
[swagger-ui]:http://swagger.io/swagger-ui/
[Node]:https://nodejs.org/es/
[multi-file-swagger]:https://www.npmjs.com/package/multi-file-swagger
[NVM]:https://github.com/creationix/nvm
