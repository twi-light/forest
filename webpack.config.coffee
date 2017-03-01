path = require 'path'
webpack = require 'webpack'

DEBUG = /webpack-dev-server/.test "#{process.argv}"

Package = require './package.json'
module.exports = {
  context: path.join __dirname, 'src'
  entry:
    "#{Package.name}": "./#{Package.name}.coffee"
  performance:
    hints: if DEBUG then false
  resolve:
    extensions: [ '.worker.coffee', '.coffee', '.styl', '.js', '.json', '.svg']
    modules: [
      path.resolve __dirname, 'src'
      'node_modules'
    ]
    alias:
      react: 'preact-compat'
      'react-dom': 'preact-compat'
  externals:
    'matter-js': 'Matter'
    'pixi.js': 'PIXI'
  output:
    path: path.join __dirname
    filename: "[name]#{if DEBUG then '' else '.min'}.js"
  devtool: if DEBUG then 'eval-source-map' else 'source-map'
  devServer:
    port: 80
    contentBase: path.join __dirname
  module:
    rules: [{
      test: /\.worker\.coffee$/
      use: ['worker-loader']
    }, {
      test: /\.svg$/
      use: ['svg-url-loader?noquotes']
    }, {
      test: /\.json$/
      use: ['json-loader']
    }, {
      test: /\.js$/
      use: [
        loader: 'babel-loader'
        options:
          babelrc: false
          presets: [[
            "env"
            targets: browsers: [
              "last 2 versions"
              "safari >= 7"
            ]
            modules: false
            loose: true
          ]]
      ]
    }, {
      test: /\.coffee$/
      use: [
        loader: 'babel-loader'
        options:
          babelrc: false
          presets: [[
            "env"
            targets: browsers: [
              "last 2 versions"
              "safari >= 7"
            ]
            modules: false
            loose: true
          ]]
          plugins: ['transform-runtime']
        'coffee-loader'
      ]
    }, {
      test: /\.styl$/
      use: [
        'style-loader?-minimize'
        loader: 'css-loader'
        options: minimize: no
        'stylus-loader'
      ]
    }]
  plugins: [
    new webpack.DefinePlugin {
      'DEBUG': !!DEBUG
      'process.env.NODE_ENV': JSON.stringify if DEBUG then 'development' else 'production'
    }
    new webpack.LoaderOptionsPlugin
      debug: !!DEBUG
      minimize: not DEBUG
    new webpack.NamedModulesPlugin
  ].concat if DEBUG then [
    new webpack.HotModuleReplacementPlugin
  ] else [
    new webpack.optimize.UglifyJsPlugin
  ]
}
