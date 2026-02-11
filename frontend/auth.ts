import NextAuth from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";

export const { handlers, signIn, signOut, auth } = NextAuth({
  session: { strategy: "jwt" },

  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },

      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) return null;

        // Replace this with your backend login endpoint
        const res = await fetch(`${process.env.BACKEND_URL}/api/auth/login/`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            email: credentials.email,
            password: credentials.password,
          }),
        });

        if (!res.ok) return null;

        // Expected:
        // { access, refresh, user: { pk, email, first_name, last_name } }
        const data = await res.json();
        if (!data?.access || !data?.refresh || !data?.user?.pk) return null;

        // Must return a "user" object; we attach tokens so callbacks can persist them.
        return {
          id: data.user.pk,
          name: `${data.user.first_name || ""} ${data.user.last_name || ""}`.trim(),
          email: data.user.email,

          access: data.access,
          refresh: data.refresh,
          backendUser: data.user,
        };
      },
    }),
  ],

  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.access = user.access;
        token.refresh = user.refresh;
        token.user = user.backendUser;
      }
      return token;
    },

    async session({ session, token }) {
      session.access = token.access;
      session.refresh = token.refresh;
      session.user = {
        ...session.user,
        ...(token.user || {}),
      };
      return session;
    },
  },
});
