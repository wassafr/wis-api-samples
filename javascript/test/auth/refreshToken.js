import { login } from "../../samples/auth/login.js";
import { refreshToken } from "../../samples/auth/refreshToken.js";
import dotenv from 'dotenv';
dotenv.config();

const test = async () => {
  try {
    // Get auth token & refresh token
    const tryLogin = await login(
      process.env.CLIENT_ID, // YOUR CLIENT ID
      process.env.SECRET_ID // YOUR SECRET ID
    );
    const token = tryLogin.token;
    const refresh = tryLogin.refreshToken;

    // Refresh token
    await refreshToken(token, refresh);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
