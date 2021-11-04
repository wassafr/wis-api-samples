# API-INTEGRATION-SAMPLES / javascript

Sample codes to test WIS Api with javascript & Axios

## Installation

Use the package manager yarn to install it in ./javascript

```bash
yarn
```

Create a .env file in ./javascript containing
```bash
CLIENT_ID="YOUR WIS CLIENT ID"
SECRET_ID="YOUR WIS SECRET ID"
```

## Usage

From ./javascript use node with the service to test.
For example, to test anonymization service, use : 

```bash
node ./test/services/anonymization.ts
```