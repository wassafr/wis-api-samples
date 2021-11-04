# WIS API Integration Samples

API Documentation: https://api.services.wassa.io/doc/

WIS (wassa Innovation Services) API is used to interface a client information system, an application, a webapp, a mobile app etc. with the WIS platform following the HTTP protocol.

This project contains a `WisService` class. WisService class is used to call the WIS API. You can get the public methods parameters descriptions on the API documentation.

This project also contains test files, showing how to use the class `WisService`.


## Edit clientId/secretId

Edit `AuthenticationRequests.swift`, find and replace `client_id` with the clientId provided by Wassa.

Edit `AuthenticationRequests.swift`, find and replace `secret_id` with the secretId provided by Wassa.

If you do not have clientId nor secretId, please contact us through our website https://services.wassa.io/

## Images assets

Assets folder contains sample images, on which the demo will work.

## Run the sample

Run the tests from the test section in xcode (top left)
You can also run the tests from the tests class themselves : 
- `AuthenticationTests.swift`
- `OtherRequestsTests.swift`
- `IdentityTests.swift`

⚠️⚠️ Be careful to run the test to `login` before to launch the rest of the tests.
⚠️⚠️ Do not `logout` before you run the rest of the tests, if so it will invalidate the current token used and you will see unauthorized errors (401).


## WIS, how it works

Most of the services have a ServiceCreateJob method to create the job service. The methods return a job id that you can provide to a ServiceGetJobStatus method.

The ServiceGetJobStatus methods are methods to get a created job status (and result/error if the job is ended).
