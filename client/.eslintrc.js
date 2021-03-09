module.exports = {
  env: {
    browser: true,
    es6: true,
  },
  ignorePatterns: ["node_modules/"],
  parser: "@typescript-eslint/parser",
  extends: [
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:prettier/recommended",
  ],
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: "module",
  },
  plugins: [
    "react",
    "@typescript-eslint",
    "react-hooks",
    "graphql",
    "prettier",
  ],
  rules: {
    "no-console": "warn",
    "arrow-parens": ["error", "as-needed"],
    "@typescript-eslint/explicit-function-return-type": [
      "error",
      {
        allowExpressions: true,
      },
    ],
    "react/display-name": 0,
    "react/prop-types": 0,
    "react/no-unescaped-entities": 0,
    "react-hooks/rules-of-hooks": "error", // Checks rules of Hooks
    "graphql/template-strings": [
      "error",
      {
        env: "apollo",
        schemaJson: require("./schema.json"),
      },
    ],
  },
  settings: {
    react: {
      version: "detect", // Tells eslint-plugin-react to automatically detect the version of React to use
    },
  },
};
