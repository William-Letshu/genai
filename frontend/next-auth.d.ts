import "next-auth";
import "next-auth/jwt";

type BackendUser = {
  pk: string;
  first_name: string;
  last_name: string;
};

declare module "next-auth" {
  interface DefaultSession {
    access?: string;
    refresh?: string;
    user: DefaultSession["user"] & Partial<BackendUser>;
  }

  interface User {
    access?: string;
    refresh?: string;
    backendUser?: {
      pk: string;
      email: string;
      first_name: string;
      last_name: string;
    };
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    access?: string;
    refresh?: string;
    user?: {
      pk: string;
      email: string;
      first_name: string;
      last_name: string;
    };
  }
}
