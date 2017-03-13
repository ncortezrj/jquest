// Handles static asset integration - like sass and images
// Note: You must restart bin/webpack-watcher for changes to take effect

const ExtractTextPlugin = require('extract-text-webpack-plugin')
const process = require('process')
const sharedConfig = require('./shared.js')
const { devServer } = require('../../package.json')

const production = process.env.NODE_ENV === 'production'
const hotServerAddr = `http://${devServer.host}:${devServer.port}/`

module.exports = {
  module: {
    rules: [
      {
        test: /\.coffee(.erb)?$/,
        loader: "coffee-loader"
      },
      {
        test: /\.js(.erb)?$/,
        exclude: /node_modules/,
        loader: [
          'ng-annotate-loader',
          'babel-loader'
        ]
      },
      {
        test: /\.scss?$/,
        loader: [
          'style-loader',
          'css-loader',
          'sass-loader',
          'import-glob-loader'
        ]
      },
      {
        test: /\.(jpeg|jpg|png|gif|svg|eot|svg|ttf|woff|woff2)$/i,
        use: [{
          loader: 'file-loader',
          options: {
            publicPath: devServer.enabled ? hotServerAddr : `/${sharedConfig.distDir}/`,
            name: production ? '[name]-[hash].[ext]' : '[name].[ext]'
          }
        }]
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin(
      production ? '[name]-[hash].css' : '[name].css'
    )
  ]
}
