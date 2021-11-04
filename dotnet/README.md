# WIS API Integration Samples

API Documentation: https://api.services.wassa.io/doc/

WIS (wassa Innovation Services) API is used to interface a client information system, an application, a webapp, a mobile app etc. with the WIS platform following the HTTP protocol.

This project contains a `WIS` class. WIS class is used to call the WIS API. You can get the public methods parameters descriptions on the API documentation.

This project also contains a `Samples.cs` file, showing how to use the `WIS` class.

## Install dependencies

Install .NET, Windows and Linux.

```
sudo snap install dotnet-sdk --classic
```

<sub>Interacting with snapd is not yet supported on darwin. This command has been left available for documentation purposes only.</sub>

On Mac, do not use snap :

```
sudo brew install dotnet-sdk
```

or follow this to install manually : https://docs.microsoft.com/fr-fr/dotnet/core/install/macos#install-alongside-visual-studio-code

## Edit clientId/secretId

Edit `Sample.cs`, find and replace `YOUR_CLIENT_ID_HERE` with the clientId provided by Wassa.

Edit `Sample.cs`, find and replace `YOUR_SECRET_ID_HERE` with the secretId provided by Wassa.

If you do not have clientId nor secretId, please contact us through our website https://services.wassa.io/

## images directory

images directory contains sample images, on which the demo will work.

## Run the sample

Run the sample code /!\ This will use your account to run some service samples /!\

```
 dotnet run -p Sample/sample.csproj
```

You might be invite to trust some certificates :

``` 
dotnet dev-certs https --trust
```

This will write some log in the console, it can be statuses or results.

You can look at `Sample/Sample.cs` to understand how WIS methods are used.

You can also get some informations in the `WIS/models/responses` files.

## WIS class, how it works

The WIS class contains methods that use the WIS API.

You must create a WIS object by providing clientId and secretId to the constructor.

Most of the services have a ServiceCreateJob method to create the job service. The methods return a job id that you can provide to a ServiceGetJobStatus method.

The ServiceGetJobStatus methods are methods to get a created job status (and result/error if the job is ended).

You can look how `Sample.cs` implements this.
