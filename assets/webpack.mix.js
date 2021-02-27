const mix = require('laravel-mix');
const path = require('path');
const tailwindcss = require('tailwindcss');
const HardSourceWebpackPlugin = require('hard-source-webpack-plugin');
require('laravel-mix-purgecss');
require('laravel-mix-eslint');

const plugins = process.env.NODE_ENV === 'development' ? 
  [new HardSourceWebpackPlugin({ info: { level: 'warn' } })] 
  : [];

mix.setPublicPath('../priv/static')
  .js('js/app.js', 'js/app.js')
  .eslint()
  .extract(Object.keys(require('./package.json').dependencies))
  .sass('css/app.scss', 'css/app.css')
  .version()
  .copyDirectory('./static', '../priv/static')
  .webpackConfig({
    resolve: {
      extensions: ['.vue', '.js'],
      alias: {
        '@': path.resolve(__dirname, 'js')
      }
    },
    stats: 'minimal',
    plugins
  })
  .options({
    clearConsole: false,
    processCssUrls: false,
    postCss: [tailwindcss('./tailwind.config.js')]
  })
  .disableNotifications();
