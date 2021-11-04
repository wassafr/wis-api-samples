# WIS API Integration Samples / typescript

Sample codes to test WIS Api with typescript

## Installation

In the ./typescript folder, use the package manager yarn to install the dependencies.

```bash
yarn
```

Create a .env file in ./typescript folder containing

    CLIENT_ID="YOUR WIS CLIENT ID"
    SECRET_ID="YOUR WIS SECRET ID"

## Usage

You can find integration examples in the "samples" folder.
Tests using these integration codes are located in the "test" folder.

From ./typescript, use ts-node with the service to test.

For example, to test anonymization service, use : 

```bash
npx ts-node ./test/services/anonymization.ts
```