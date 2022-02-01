# Decidim Monterrey

Decidim es una plataforma de código libre para gestionar procesos de democracia participativa y gobierno abierto para ciudades y organizaciones.

Este repositorio es el código fuente de la instancia para el municipio de Monterrey en Nuevo León, México.

El código es una modificación del proyecto [Decidim](https://decidim.org).

## Requerimientos

1. Git 2.15+
2. PostgreSQL 12.7+
3. Ruby 2.7.5
4. NodeJS 16.9.x
5. Npm 7.21.x
6. ImageMagick
7. Chrome browser and chromedriver.

## Configurando Decidim en tu máquina para desarrollo

1. `gem install bundler`
2. `npm install -g yarn`
3. `bundle install`
4. `yarn install`
5. `bundle exec rails db:setup`
6. `bundle exec rails server`
