const mix = require('laravel-mix');
const path = require('path');
const tailwindcss = require('tailwindcss');
require('laravel-mix-purgecss');
require('laravel-mix-eslint');

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
    }
  })
  .options({
    clearConsole: false,
    processCssUrls: false,
    postCss: [tailwindcss('./tailwind.config.js')]
  })
  .purgeCss({
    enabled: mix.inProduction(),
    content: ["../**/*.html.eex", "../**/views/**/*.ex", "./js/**/*.js"],
    defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
  });
