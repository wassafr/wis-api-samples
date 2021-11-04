import { login } from "../../samples/auth/login.js";
import { logout } from "../../samples/auth/logout.js";
import dotenv from 'dotenv';
dotenv.config();

const test = async () => {
  try {
    // Get auth token
    const tryLogin = await login(
      process.env.CLIENT_ID, // YOUR CLIENT ID
      process.env.SECRET_ID // YOUR SECRET ID
    );
    const token = tryLogin?.token;

    // Logout
    await logout(token);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
