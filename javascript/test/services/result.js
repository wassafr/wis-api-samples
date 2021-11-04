import { login } from "../../samples/auth/login.js";
import { getResultFile } from "../../samples/services/result.js";
import dotenv from 'dotenv';
dotenv.config();

const test = async () => {
  try {
    // Get auth token
    const tryLogin = await login(
      process.env.CLIENT_ID , // YOUR CLIENT ID
      process.env.SECRET_ID // YOUR SECRET ID
    );
    const token = tryLogin.token;

    // Get result file
    const data = await getResultFile(
      token,
      "" // A FILENAME GENERATED BY ANY OTHER ROUTE
    );
  } catch (e) {
    console.log(e?.message);
  }
};

test();