return {
	-- tools
	{
		"mason-org/mason.nvim",
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
	},
	{
		"mason-org/mason-lspconfig.nvim",
	},
	-- lsp servers
	{
		"neovim/nvim-lspconfig",
				opts = {
			inlay_hints = { enabled = true },
			servers = {
				cssls = {
					-- cmd = { "vscode-css-language-server", "--stdio" },
					-- filetypes = { "css", "scss", "less" },
					-- init_options = {
					-- 	completion = {
					-- 		triggerPropertyValueCompletion = true,
					-- 		completePropertyWithSemicolon = true,
					-- 	},
					-- 	validation = {
					-- 		lint = {
					-- 			compatibleVendorPrefixes = "ignore",
					-- 			vendorPrefix = "warning",
					-- 			duplicateProperties = "warning",
					-- 			emptyRules = "warning",
					-- 			importStatement = "warning",
					-- 			boxModel = "warning",
					-- 			universalSelector = "warning",
					-- 			zeroUnits = "warning",
					-- 			fontFaceProperties = "warning",
					-- 			hexColorLength = "error",
					-- 			argumentsInColorFunction = "error",
					-- 			unknownProperties = "warning",
					-- 			ieHack = "warning",
					-- 			unknownAtRules = "warning",
					-- 			propertyIgnoredDueToDisplay = "warning",
					-- 			badApplyScan = "error",
					-- 		},
					-- 	},
					-- },
					-- root_dir = [[root_pattern(".git")]],
				},
				eslint = {
					enabled = false,
					filetypes = { "javascript", "typescript", "vue" },
					settings = {
						format = false, -- Disable ESLint formatting
					},
					on_attach = function(client, _)
						client.server_capabilities.documentFormattingProvider = false
					end,
					-- cmd = { "vscode-eslint-language-server", "--stdio" },
					-- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
					-- settings = {
					-- 	codeAction = {
					-- 		disableRuleComment = {
					-- 			enable = true,
					-- 			location = "separateLine",
					-- 		},
					-- 		showDocumentation = {
					-- 			enable = true,
					-- 		},
					-- 	},
					-- 	codeActionOnSave = {
					-- 		enable = false,
					-- 		mode = "all",
					-- 	},
					-- 	format = true,
					-- 	nodePath = nil,
					-- 	onIgnoredFiles = "off",
					-- 	packageManager = "npm",
					-- 	quiet = false,
					-- 	rulesCustomizations = {},
					-- 	run = "onType",
					-- 	useESLintClass = false,
					-- 	validate = "on",
					-- 	workingDirectory = {
					-- 		mode = "location",
					-- 	},
					-- },
				},

				volar = {
					enabled = true,
					filetypes = { "vue", "typescript", "javascript" },
					root_dir = [[root_pattern(".git")]],
					-- cmd = { "vue-language-server", "--stdio" },
					-- filetypes = { "vue", "javascript", "typescript" },
					-- init_options = {
					-- 	typescript = {
					-- 		tsdk = "path/to/node_modules/typescript/lib",
					-- 	},
					-- },
					-- root_dir = [[root_pattern("package.json")]],
				},
				vtsls = {
					enabled = true,
					filetypes = { "typescript", "javascript", "vue" },
					root_dir = [[root_pattern(".git")]],
					-- cmd = { "vtsls", "--stdio" },
					-- filetypes = { "typescript", "javascript", "vue" },
					-- root_dir = [[root_pattern("package.json")]],
				},
				tsserver = {
					enabled = false,
					root_dir = [[root_pattern(".git")]],
					-- cmd = { "typescript-language-server", "--stdio" },
					-- filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
					-- root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]],
				},

				gopls = {
					root_dir = [[root_pattern("go.work", "go.mod", ".git")]],
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								ST1003 = false,
							},
							staticcheck = true,
							gofumpt = true,
							hints = {
								parameterNames = false,
								rangeVariableTypes = false,
								assignVariableTypes = false,
								compositeLiteralTypes = false,
							},
						},
					},
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
        ["*"] = {
					keys = {
						{
							"gd",
							function()
								require("telescope.builtin").lsp_definitions({ reuse_win = false })
							end,
							desc = "Goto Definition (Telescope)",
						},
					},
				},
		},
	},
}
