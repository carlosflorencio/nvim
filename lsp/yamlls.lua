---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      -- manually linking schemas because github workflow schema is
      -- broken in schemastore
      -- https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['https://json.schemastore.org/pre-commit-config.json'] = '/.pre-commit-config.*',
        ['https://json.schemastore.org/swagger-2.0.json'] = '**/swagger.yaml',
        ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/configmap.json'] = '**/config-maps/**/*.yaml',
        ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/job.json'] = 'job.yml',
        ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/pod.json'] = 'pod.yml',
        ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose*.yml',
        ['https://json.schemastore.org/commitlintrc.json'] = '.commitlintrc.yml',
      },
    },
  },
}
