# WIS API Integration Samples

## Objectives

WIS (wassa Innovation Services) API is used to interface a client information system, an application, a webapp, a mobile app etc. with the WIS platform following the HTTP protocol.

[(REST)](https://en.wikipedia.org/wiki/Representational_state_transfer) (Representational State Transfer) or RESTful is a style of architecture used to build applications (Web, Intranet, Web Service) by using endpoints ( endpoints urls) and referencing resources to be exploited according to the verbs of the HTTP protocol (GET, POST, PUT, DELETE etc ...).

In this repository, you will find WIS API integration examples for 8 languages (javascript, typescript, PHP, python, Swift, Kotlin, C#, .NET).

## Installation

Please follow instructions for each language in its corresponding folder

## Run the tests

Please follow instructions for each language in its corresponding folder

## Principles

Our APIs contain predictable resource-oriented URLs, that accept request bodies encoded in JSON format, that return encoded responses JSON and that use standard HTTP responses codes (200, 404, etc.), with a HTTP authentication using headers and HTTP verbs (GET, POST, etc.).

'Client' applications that use the WIS API can enrich/enhance their Information System with data and processes provided and developed by WIS in a secure and very flexible way.

## Prerequisites

Before you start, you should have received an email with a clientId and a secretId, this two ids will be needed to connect and use the API.
If you did not receive it, please contact Wis Support

## Documentation

[WIS Api documentation](https://api.services.wassa.io/doc/)

## Other ressources

[WIS web site](https://services.wassa.io/) \
[General API doc](https://services.wassa.io/api/global-documentation/) \
[Contact Support](mailto:support.service@wassa.io)

# How it works ?

## Authentication

Authentication is made with the login route, with a clientId and a secretId as parameters, it will return a token that will be needed as a parameter for all other routes and services.
Login route does not use any authorization. (Auth Type : No Auth)
All other routes use a Bearer Token. (Authorization type : Bearer Token)

## Allowed to use services

Once authenticated, you might or might not be allowed to use an innovation services routes, depending on your registration and pricing plan. If your are not you will receive an Authentication Error 401.

## Jobs

Running jobs : Most of API are not synchronous and may take some time. Jobs could be prioritized depending on your pricing plan or server load. Jobs could take few minutes.
Routes are working by pair, the first (POST) will start the job, the second (GET) will retrieve job status.

For example, status could be pending (status : sent) indicating that the job is not started yet. Finally, once the status is known and is a success (status : succeeded), the result could be a treated image. In that case, you will need to call a dedicated route to finally get it. (GET /innovation-service/result/{fileName})
