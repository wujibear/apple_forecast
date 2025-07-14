/// <reference types="vitest" />
import { reactRouter } from '@react-router/dev/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';

export default defineConfig(({ command, mode }) => {
  const isTest = mode === 'test';

  return {
    plugins: [
      tailwindcss(),
      ...(isTest ? [] : [reactRouter()]),
      tsconfigPaths(),
    ],
    test: {
      globals: true,
      environment: 'jsdom',
      setupFiles: ['./app/test/setup.ts'],
      css: true,
    },
  };
});
