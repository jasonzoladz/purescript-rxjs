'use strict';

// var PurescriptWebpackPlugin = require('purescript-webpack-plugin');

var src = ['bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs'];



var modulesDirectories = [
  'node_modules',
  'bower_components'
];

var config
  = { entry: './src/entry'
    , output: {
               filename: 'app.js'
              }
    , bundle: true
    , module: { loaders: [ { test: /\.purs$/
                           , loader: 'purs-loader'
                           } ] }
    , resolve: { modulesDirectories: modulesDirectories, extensions: [ '', '.js', '.purs'] }

    , devServer: { historyApiFallback: false,
                   headers: { "Access-Control-Allow-Origin": "*" }
                 }
    }
    ;

module.exports = config;
