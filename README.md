# studious-rotary-phone-docker
Dockerfile for studious-rotary-phone

Base project https://github.com/pmop/studious-rotary-phone

## Building

`docker build --tag appname`

## Running
First, provide required environment variables in a `env.list` file. You can start from [env-example.list](https://github.com/pmop/studious-rotary-phone-docker/blob/master/env-example.list), this file will guide you through the minimal environment variables needed to successfully run this application. [More info about this application environment variables here](https://github.com/pmop/studious-rotary-phone#environment-variables).

`docker run --env-file ./env.list --publish 3000:3000 appname`

[Endpoints here](https://github.com/pmop/studious-rotary-phone#endpoints).
