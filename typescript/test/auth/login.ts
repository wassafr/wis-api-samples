import { login } from "../../samples/auth/login";
import dotenv from "dotenv";
dotenv.config();

const test = async () => {
  try {
    // Login
    await login(
      process.env.CLIENT_ID as string, // YOUR CLIENT ID
      process.env.SECRET_ID as string // YOUR SECRET ID
    );
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
