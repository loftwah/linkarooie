import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import StimulusHMR from 'vite-plugin-stimulus-hmr';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
  ],
  build: {
    rollupOptions: {
      input: {
        application: 'app/javascript/entrypoints/application.js'
      }
    }
  },
  assetsInclude: ['app/javascript/**/*.{png,jpg,jpeg,svg}'], // Only process assets in JS folder
  server: {
    watch: {
      ignored: ['public/avatars/**/*', 'public/banners/**/*'] // Ignore dynamic avatar and banner folders
    }
  }
});
