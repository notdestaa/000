#!/bin/bash

# Exit on error
set -e

# Create project folder
mkdir -p dfs-demo-app
cd dfs-demo-app

# Init new Next.js + Tailwind project
npm init -y
npm install next@14 react react-dom \
  lucide-react class-variance-authority tailwind-variants @radix-ui/react-icons \
  tailwindcss postcss autoprefixer typescript

# Generate Tailwind config files
npx tailwindcss init -p

# Overwrite package.json
cat > package.json <<'EOF'
{
  "name": "dfs-demo-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "14.1.0",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "lucide-react": "^0.344.0",
    "class-variance-authority": "^0.7.0",
    "tailwind-variants": "^0.1.20",
    "@radix-ui/react-icons": "^1.3.0"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31",
    "tailwindcss": "^3.3.3",
    "typescript": "^5.3.3"
  }
}
EOF

# tsconfig for alias
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["*"]
    },
    "jsx": "preserve",
    "module": "esnext",
    "moduleResolution": "node",
    "strict": false,
    "skipLibCheck": true,
    "noEmit": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF

# Tailwind config
cat > tailwind.config.js <<'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# PostCSS config
cat > postcss.config.js <<'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# App files
mkdir -p app components/ui lib

cat > app/layout.tsx <<'EOF'
import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "DFS Demo App",
  description: "A simple DFS-style player pick demo app",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-blue-50 text-black">{children}</body>
    </html>
  );
}
EOF

cat > app/globals.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  font-family: sans-serif;
}
EOF

cat > app/page.tsx <<'EOF'
"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

const players = [
  { id: 1, name: "LeBron James", sport: "NBA" },
  { id: 2, name: "Patrick Mahomes", sport: "NFL" },
  { id: 3, name: "Lionel Messi", sport: "Soccer" },
  { id: 4, name: "Shohei Ohtani", sport: "MLB" },
];

export default function Page() {
  const [query, setQuery] = useState("");
  const filteredPlayers = players.filter((p) =>
    p.name.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <main className="min-h-screen bg-blue-50 p-6 flex flex-col items-center gap-6">
      <h1 className="text-3xl font-bold text-black">DFS Demo App</h1>
      <Card className="w-full max-w-md">
        <h2 className="text-xl font-semibold mb-4">Pick a Player</h2>
        <Input
          placeholder="Search player..."
          className="mb-4"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        <div className="flex flex-col gap-3">
          {filteredPlayers.map((player) => (
            <Card key={player.id} className="p-3 flex justify-between items-center">
              <span>{player.name} ({player.sport})</span>
              <div className="flex gap-2">
                <Button>More</Button>
                <Button className="bg-blue-500 hover:bg-blue-700">Less</Button>
              </div>
            </Card>
          ))}
        </div>
      </Card>
    </main>
  );
}
EOF

# UI components
cat > components/ui/button.tsx <<'EOF'
import * as React from "react";
import { cn } from "@/lib/utils";

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {}

export function Button({ className, ...props }: ButtonProps) {
  return (
    <button
      className={cn(
        "inline-flex items-center justify-center rounded-lg bg-black text-white px-4 py-2 text-sm font-medium hover:bg-blue-600 transition",
        className
      )}
      {...props}
    />
  );
}
EOF

cat > components/ui/card.tsx <<'EOF'
import * as React from "react";
import { cn } from "@/lib/utils";

export function Card({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "rounded-2xl border bg-white shadow-md p-4",
        className
      )}
      {...props}
    />
  );
}
EOF

cat > components/ui/input.tsx <<'EOF'
import * as React from "react";
import { cn } from "@/lib/utils";

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {}

export function Input({ className, ...props }: InputProps) {
  return (
    <input
      className={cn(
        "flex h-10 w-full rounded-lg border px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500",
        className
      )}
      {...props}
    />
  );
}
EOF

# utils
cat > lib/utils.ts <<'EOF'
export function cn(...inputs: (string | undefined)[]) {
  return inputs.filter(Boolean).join(" ");
}
EOF

# Install dependencies
npm install

# Create full zip (with node_modules)
cd ..
zip -r dfs-demo-app-complete-with-node_modules.zip dfs-demo-app
