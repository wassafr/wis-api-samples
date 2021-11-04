# Python3 WIS Implementation Examples

This folder contains implementation examples of the WIS (Wassa-Inovation-Services) [API](https://api.services.wassa.io/doc/).
This code is intended to be ready-to-use for generic purposes. 

Feel free to modify it if you have any peritcular needs.

## Install as a module

This code can be installed as a pyton module.

```sh
pip3 install .
```

Then you can use it anywhere

```python
import wis

token = wis.auth.login(...)
```

## Authentification

For security purpose, every function requires a `token`. 
A token can be acquired using the `wis.auth.login` function.
This function requires a **client_id** and a **secret_id**.

You can provide those values either by passing them to the login function

```python
token = wis.auth.login(client_id, secret_id)
```

or using env variables and passing no values to the login function

```sh
export WIS_CLIENT_ID="YOUR_CLIENT_ID"
export WIS_SECRET_ID="YOUR_SECRET_ID"
```

```python
token = wis.auth.login()
```

## Testing

All methods can be tested using python `pytest`.
For this you need to add some more requirements.

```sh
pip3 install -r requirements.txt
```

You also need to setup env variables

```sh
export WIS_CLIENT_ID="YOUR_CLIENT_ID"
export WIS_SECRET_ID="YOUR_SECRET_ID"
```

You can start auto-tests using 

```sh
python3 -m pytest test
```

Everything should be fine.