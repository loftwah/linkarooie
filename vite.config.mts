import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import path from 'path';

export default defineConfig({
  plugins: [
    RubyPlugin(),
  ],
  build: {
    rollupOptions: {
      input: {
        application: 'app/javascript/entrypoints/application.js' // Path to your main JS entry point
      }
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        includePaths: [
          path.resolve(__dirname, 'node_modules'), // Ensure Vite looks in node_modules for styles
          path.resolve(__dirname, 'app/assets/stylesheets') // Include your stylesheets directory
        ],
      },
    },
  },
  assetsInclude: ['**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.svg'] // Include any other assets you want to be processed
});
