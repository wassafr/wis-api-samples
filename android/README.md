# WIS API Integration Samples

API Documentation: https://api.services.wassa.io/doc/

WIS (wassa Innovation Services) API is used to interface a client information system, an application, a webapp, a mobile app etc. with the WIS platform following the HTTP protocol.

This project contains a `WisExampleClient` class. WisExampleClient class is used to call the WIS API. You can get the public methods parameters descriptions on the API documentation.

This project also contains a `WisInstrumentedTest` file, showing how to use the `WisExampleClient` class.

## Edit clientId/secretId

Edit `WisInstrumentedTest`, find and replace `YOUR_CLIENT_ID_HERE` with the clientId provided by Wassa.

Edit `WisInstrumentedTest`, find and replace `YOUR_SECRET_ID_HERE` with the secretId provided by Wassa.

If you do not have clientId nor secretId, please contact us through our website https://services.wassa.io/

## Run the sample

Run the sample code /!\ This will use your account to run some service samples /!\

This will write some log in the console, it can be statuses or results.

You can look at `WisInstrumentedTest` to understand how WIS methods are used.

You can also get some informations in the `models/responses` files.

## WIS class, how it works

The WisExampleClient class contains methods that use the WIS API.

You must create a WisExampleClient object by providing clientId and secretId to the constructor.

Most of the services have a ServiceCreateJob method to create the job service. The methods return a job id that you can provide to a ServiceGetJobStatus method.

The ServiceGetJobStatus methods are methods to get a created job status (and result/error if the job is ended).

You can look how `WisInstrumentedTest` implements this.