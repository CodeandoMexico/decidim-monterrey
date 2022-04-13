# Manual de instalación

Decidim Monterrey es un proyecto basado en la plataforma [Decidim](github.com/decidim/decidim). Esta plataforma está implementada con Rails, un framework de desarrollo web para el lenguaje Ruby.

En este manual se describe a a grandes rasgos, de dos maneras diferentes, el proceso de instalación de Decidim Monterrey. Este manual asume que el proyecto se instalará en una máquina Linux con sistema operativo Debian. El proceso es parecido en otras distribuciones de Linux.

## Modo 1: imágenes Docker

Este proyecto tiene una GitHub Action que construye de manera automática una imagen de Docker a partir del código fuente cada vez que se hace push a la rama principal (main). Esta imagen, una vez construida, se publica en el [repositorio de paquetes](https://github.com/orgs/CodeandoMexico/packages) de Codeando México.

La imagen contiene todas las dependencias necesarias para ejecutar el proyecto, a excepción de la base de datos (Postgres).

Los requisitos para poder ejecutar el proyecto en un servidor en la nube son:

1. [Instalar Docker y Docker Compose](#instalación-de-docker-y-docker-compose) en la máquina virtual o servidor.
2. Copiar el fichero `docker-compose-production.yml` a la máquina destino.
3. Renombrar `docker-compose-production.yml` a `docker-compose.yml`
4. Crear un fichero `.env` en la misma carpeta que `docker-compose.yml` con las siguientes variables de entorno

```
RAILS_ENV=production
FORCE_SSL=no
SECRET_KEY_BASE={SECRET_KEY_BASE}
RAILS_LOG_TO_STDOUT=false
RAILS_SERVE_STATIC_FILES=true
DATABASE_URL=postgres://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE_NAME}
SMTP_ADDRESS={SMTP_HOST}
SMTP_DOMAIN={SMTP_DOMAIN}
SMTP_PORT={SMTP_PORT}
SMTP_USERNAME={SMTP_USER}
SMTP_PASSWORD={SMTP_PASSWORD}
```

5. Ejecutar `docker-compose up -d --remove-orphans` para levantar la aplicación
6. Ejecutar `docker-compose down` para detener la aplicación

El fichero `docker-compose.yml` descarga la imagen de Docker desde GitHub, lee las variables de entorno y levanta la aplicación de manera automática.

Algunos módulos de Decidim requieren de una carpeta en el servidor para la subida de imágenes. Crear la carpeta en $HOME/decidim-uploads. Esta carpeta se monta como un volumen en el contenedor de Docker de manera que no desaparece aunque se elimine la imagen y los contenedores de Docker.

Antes de correr Decidim Monterrey por primera vez es necesario realizar algunas operaciones con la base de datos:

1. Crear la base de datos
```
docker-compose run decidim rake db:create
```
2. Crear las tablas necesarias para Decidim. Esto se realiza corriendo las migraciones de rails.
```
docker-compose run decidim rake db:migrate
```
3. Decidim Monterrey necesita datos de distritos, sectores y colonias para poder funcionar correctamente.
```
docker-compose run decidim rake db:seed
```
Esto se puede combinar en un solo comando
```
docker-compose run decidim rake db:create db:migrate db:seed
```
## Modo 2: Instalación manual

### Instalación de las dependencias del proyecto

#### Rbenv y Ruby

Dependencias previas

```
> sudo apt update
> sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev \
        autoconf bison build-essential libyaml-dev \
        libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
```

Instalar rbenv y ruby-build

```
> curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -
```

En caso de bash

```
> echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
> echo 'eval "$(rbenv init -)"' >> ~/.bashrc
> source ~/.bashrc
```

En caso de zsh

```
> echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
> echo 'eval "$(rbenv init -)"' >> ~/.zshrc
> source ~/.zshrc
```

Instalar Ruby, específicamente la versión 2.7.5

```
> rbenv install 2.7.5
```

Verificar la instalación de Ruby

```
> ruby -v
```

#### Dependencias de Rails y Decidim

Git, Imagemagik, Node.js (16.x), Yarn, Bundler

```
apt-get update && apt-get upgrade -y
apt-get install -y git imagemagick wget
apt-get clean
curl -sL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
apt-get clean
npm install -g yarn
gem install bundler
```

### Clonar el proyecto, instalar dependencias y precompilar assets

Clonar este proyecto a una carpeta en el servidor. Se recomienda $HOME/decidim-monterrey.

Cambiarse a la carpeta del proyecto

```
> cd $HOME/decidim-monterrey
```

Instalar las gemas

```
> bundle check || bundle install --jobs=4
```

Instalar las dependencias de Node.js

```
> yarn install
```

Precompilar assets

```
> bundle exec rails assets:precompile
```


### Base de datos

La base de datos ya debe estar configurada con las variables de entorno en el fichero `.env`.

### Procesos en background

Decidim necesita ejecutar dos procesos en background para el envío de emails, la actualización de estadísticas y las tablas de datos abiertos.

Crear un fichero de shell con permisos de ejecución con el siguiente contenido para lanzar los procesos.

```
#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e

if [ -f /decidim/tmp/pids/delayed_job.pid ]; then
  rm /decidim/tmp/pids/delayed_job.pid
fi
bundle exec bin/delayed_job start

if [ -f /decidim/tmp/pids/clockwork.pid ]; then
  rm /decidim/tmp/pids/clockwork.pid
fi
# bundle exec clockwork config/clockwork.rb
```

### Levantar el proyecto Rails

Levantarlo como proceso en background para que no se muera al salirnos de la consola.

```
> bin/rails s -b 0.0.0.0 &
```

## Instalación de Docker y Docker Compose

La página oficial de Docker contiene la información necesaria para [instalar el proyecto](https://docs.docker.com/engine/install/), pero para facilitar la instalación estos serían los pasos necesarios en una máquina con Linux Debian:

Actualizamos el gestor de paquetes
```
> sudo apt update
```

Instalamos las dependencias necesarias
```
> sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
```
Añadimos la clave GPG de Docker, sirve para validar la autoría e integridad del paquete
```
> curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```
Añadimos el repositorio de Docker
```
> sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

> deb [arch=amd64] https://download.docker.com/linux/debian buster stable
```

Actualizamos el gestor de paquetes
```
> sudo apt update
```
Instalamos Docker
```
> sudo apt -y install docker-ce docker-ce-cli containerd.io
```
Configuramos Docker como servicio del sistema
```
> sudo systemctl enable --now docker
```
Añadimos el usuario al grupo docker para no ejecutar con privilegios root
```
> sudo usermod -aG docker $USER

> newgrp docker
```

Instalamos Docker Compose
```
> sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Cambiamos los permisos de ejecución
```
> sudo chmod +x /usr/local/bin/docker-compose
```


