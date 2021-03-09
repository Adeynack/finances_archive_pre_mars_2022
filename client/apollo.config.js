module.exports = {
  client: {
    service: {
      name: "Finances",
      localSchemaFile: "./schema.json",
    },
    include: ["src/queries/*.ts"],
    exclude: ["node_modues/*"],
    tagName: "gql",
  },
};
