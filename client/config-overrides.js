module.exports = {
  devServer: function (configFunction) {
    return function (proxy, allowedHost) {
      const config = configFunction(proxy, allowedHost);

      const api = process.env.FINANCES_API_HOST;
      config.proxy = Object.assign(config.proxy || {}, {
        "/graphql": {
          target: api,
          secure: false,
          changeOrigin: true,
        },
        "/graphiql": {
          target: api,
          secure: false,
          changeOrigin: true,
        },
        "/assets": {
          target: api,
          secure: false,
          changeOrigin: true,
        },
      });

      return config;
    };
  },
};
