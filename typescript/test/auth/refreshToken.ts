import { login } from "../../samples/auth/login";
import { refreshToken } from "../../samples/auth/refreshToken";
import dotenv from "dotenv";
dotenv.config();

const test = async () => {
  try {
    // Get auth token & refresh token
    const tryLogin = await login(
      process.env.CLIENT_ID as string, // YOUR CLIENT ID
      process.env.SECRET_ID as string // YOUR SECRET ID
    );
    const token = tryLogin.token as string;
    const refresh = tryLogin.refreshToken as string;

    // Refresh token
    await refreshToken(token, refresh);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
