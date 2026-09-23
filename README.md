# Timstagram
A personal photo blogging site inspired by one we've all heard of before.

## Requirements

* Ruby 3.4 (see `.ruby-version`; Rails 8 needs 3.2+)
* libvips — used by Active Storage to build image variants (`brew install vips`)
* Node — used by the asset pipeline for CoffeeScript and Terser

## Getting started

```sh
bundle install
bin/rails db:setup
bin/rails server
```

## Upgrading from the Paperclip version

Uploads moved from Paperclip to Active Storage. If you have existing images
under `public/system`, attach them before the Paperclip columns are dropped:

```sh
bin/rails db:migrate VERSION=20260923202242   # create the Active Storage tables
bin/rake paperclip:migrate_to_active_storage  # copy public/system into Active Storage
bin/rails db:migrate                          # drop the Paperclip columns
```
