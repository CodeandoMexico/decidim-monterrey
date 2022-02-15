# Manual de instalación

Decidim Monterrey es un proyecto basado en la plataforma [Decidim](github.com/decidim/decidim). Esta plataforma está implementada sobre Rails, un framework de desarrollo web para el lenguaje Ruby.

En este manual se describe a a grandes rasgos, de dos maneras diferentes, el proceso de instalación de Decidim Monterrey. Este manual asume que el proyecto se instalará en una máquina Linux con sistema operativo Debian. El proceso es parecido en otras distribuciones de Linux.

## Modo 1: imágenes Docker

El proyecto tiene configurada una GitHub Action para construir bajo demanda una imagen de Docker a partir del código fuente. Esta imagen, una vez construida, se publica en el [repositorio de paquetes](https://github.com/orgs/CodeandoMexico/packages) de Codeando México.

La imagen contiene todas las dependencias necesarias para ejecutar el proyecto, a excepción de la base de datos (Postgres).

Los requisitos para poder ejecutar el proyecto en un servidor en la nube son:

1. [Instalar Docker y Docker Compose](#instalación-de-docker-y-docker-compose) en la máquina virtual o servidor.
2. Copiar el fichero `docker-compose-production.yml` a la máquina destino.
3. Crear un fichero `.env` en la misma carpeta que `docker-compose-production.yml` con las siguientes variables de entorno

```
RAILS_ENV=production
FORCE_SSL=no
SECRET_KEY_BASE={SECRET_KEY_BASE}
RAILS_LOG_TO_STDOUT=false
BUNDLE_WITHOUT=development:test
RAILS_SERVE_STATIC_FILES=false
DATABASE_URL=postgres://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE_NAME}
SMTP_ADDRESS={SMTP_HOST}
SMTP_DOMAIN={SMTP_DOMAIN}
SMTP_PORT={SMTP_PORT}
SMTP_USERNAME={SMTP_USER}
SMTP_PASSWORD={SMTP_PASSWORD}
```

4. Ejecutar `docker-compose -f docker-compose-production.yml up -d --remove-orphans` para levantar la aplicación
5. Ejecutar `docker-compose -f docker-compose-production.yml down` para detener la aplicación

El fichero `docker-compose-production.yml` descarga la imagen de Docker desde GitHub, lee las variables de entorno y levanta la aplicación de manera automática.

Para la subida de imágenes, crear una carpeta en $HOME/decidim-uploads. Esta carpeta se monta como un volumen en el contenedor de Docker de manera que no desaparece aunque se elimine la imagen y los contenedores de Docker.

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

`> sudo apt update`

Instalamos las dependencias necesarias

`> sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common`

Añadimos la clave GPG de Docker, sirve para validar la autoría e integridad del paquete

`> curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -`

Añadimos el repositorio de Docker

`> sudo add-apt-repository `\
   `"deb [arch=amd64] https://download.docker.com/linux/debian `\
   `$(lsb_release -cs) `\
   `stable"`

`> deb [arch=amd64] https://download.docker.com/linux/debian buster stable`

Actualizamos el gestor de paquetes

`> sudo apt update`

Instalamos Docker

`> sudo apt -y install docker-ce docker-ce-cli containerd.io`

Configuramos Docker como servicio del sistema

`> sudo systemctl enable --now docker`

Añadimos el usuario al grupo docker para no ejecutar con privilegios root

`> sudo usermod -aG docker $USER`
`> newgrp docker`

Instalamos Docker Compose

`> sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

Cambiamos los permisos de ejecución

`> sudo chmod +x /usr/local/bin/docker-compose`


