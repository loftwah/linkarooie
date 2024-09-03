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
        application: 'app/javascript/entrypoints/application.js'
      }
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        includePaths: [
          path.resolve(__dirname, 'node_modules'),
          path.resolve(__dirname, 'app/assets/stylesheets')
        ],
        // Remove the additionalData line that was causing the circular import
      },
    },
  },
  assetsInclude: ['**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.svg', '**/*.eot', '**/*.ttf', '**/*.woff', '**/*.woff2']
});