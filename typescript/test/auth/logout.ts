import { login } from "../../samples/auth/login";
import { logout } from "../../samples/auth/logout";
import dotenv from "dotenv";
dotenv.config();

const test = async () => {
  try {
    // Get auth token
    const tryLogin = await login(
      process.env.CLIENT_ID as string, // YOUR CLIENT ID
      process.env.SECRET_ID as string // YOUR SECRET ID
    );
    const token = tryLogin.token as string;

    // Logout
    await logout(token);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
