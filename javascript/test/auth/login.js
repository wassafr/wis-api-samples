import { login } from "../../samples/auth/login.js";
import dotenv from 'dotenv';
dotenv.config();

const test = async () => {
  try {
    // Login
    await login(
      process.env.CLIENT_ID, // YOUR CLIENT ID
      process.env.SECRET_ID // YOUR SECRET ID
    );
  } catch (e) {
    console.log(e?.message);
  }
};

test();
