return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"typescript-language-server",
				"css-lsp",
				"gopls",
			})
		end,
		version = "1.11.0",
	},
	{ "williamboman/mason-lspconfig.nvim", version = "1.32.0" },
	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = {
				"gd",
				function()
					-- DO NOT RESUSE WINDOW
					require("telescope.builtin").lsp_definitions({ reuse_win = false })
				end,
				desc = "Goto Definition",
				has = "definition",
			}
		end,
		opts = {
			inlay_hints = { enabled = true },
			servers = {
				cssls = {},
				eslint = {
					filetypes = { "javascript", "typescript", "vue" },
					settings = {
						format = false, -- Disable ESLint formatting
					},
					on_attach = function(client, _)
						client.server_capabilities.documentFormattingProvider = false
					end,
				},

				volar = {
					filetypes = { "vue", "typescript", "javascript" },
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					settings = {
						vue = {
							telemetry = { enabled = false },
							format = {
								enabled = true,
								options = {
									tabSize = 4,
									useTabs = false,
								},
							},
						},
					},
				},
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
				tsserver = {
					filetypes = { "typescript", "javascript" },
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
					on_attach = function(client, bufnr)
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						if bufname:match("%.vue$") then
							client.stop() -- Disable tsserver in Vue files
						end
					end,
				},
				html = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					-- enabled = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									-- "--log-level=trace",
								},
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "4",
									continuation_indent_size = "4",
								},
							},
						},
					},
				},
			},
		},
	},
}
