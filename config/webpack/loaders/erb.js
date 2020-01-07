module.exports = {
  test: /\.erb$/,
  enforce: 'pre',
  include: [
    path.resolve(__dirname, 'app/views/advertisements'),
    path.resolve(__dirname, 'app/javascript/advertisements'),
  ],
  exclude: [path.resolve(__dirname, 'node_modules')],
  use: [
    {
      loader: 'rails-erb-loader',
      options: {
        runner:
          (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
      }
    }
  ]
}
