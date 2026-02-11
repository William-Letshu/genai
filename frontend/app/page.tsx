"use client";

import { signIn, signOut, useSession } from "next-auth/react";
import { useState } from "react";

export default function Home() {
  const { data: session, status } = useSession();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    const res = await signIn("credentials", {
      email,
      password,
      redirect: false,
    });

    if (!res?.ok) {
      setError("Invalid email or password");
    }
  };

  return (
    <main style={{ padding: 24, maxWidth: 420 }}>
      <h1>Welcome to genai solution</h1>

      {status === "loading" && <p>Loading...</p>}

      {status === "unauthenticated" && (
        <form onSubmit={handleSubmit} style={{ marginTop: 16 }}>
          <div style={{ marginBottom: 12 }}>
            <label>Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              style={{ width: "100%" }}
            />
          </div>

          <div style={{ marginBottom: 12 }}>
            <label>Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              style={{ width: "100%" }}
            />
          </div>

          {error && <p style={{ color: "red" }}>{error}</p>}

          <button type="submit">Sign in</button>
        </form>
      )}

      {status === "authenticated" && (
        <div style={{ marginTop: 16 }}>
          <p><strong>Signed in</strong></p>

          <pre>{JSON.stringify(session, null, 2)}</pre>

          <button onClick={() => signOut({ redirect: false })}>
            Sign out
          </button>
        </div>
      )}
    </main>
  );
}
