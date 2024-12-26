-- Troubleshooting commands
-- :DapSetLogLevel TRACE
--

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},

      ensure_installed = {
        'delve',
      },
    }

    vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<Leader>dr', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<Leader>dt', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>dl', function()
      dap.repl.open()
    end, { desc = 'Debug: Open REPL' })
    vim.keymap.set('n', '<Leader>ds', function()
      dap.run_last()
    end, { desc = 'Debug: Run Last' })

    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏩',
          step_over = '⏭',
          step_out = '⏎',
          step_back = '⏪',
          run_last = '⏮',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      force_buffers = true,
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.25,
            },
            {
              id = 'breakpoints',
              size = 0.25,
            },
            {
              id = 'stacks',
              size = 0.25,
            },
            {
              id = 'watches',
              size = 0.25,
            },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            {
              id = 'repl',
              size = 0.5,
            },
            {
              id = 'console',
              size = 0.5,
            },
          },
          position = 'bottom',
          size = 10,
        },
      },
    }

    vim.keymap.set('n', '<Leader>dn', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<Leader>do', function()
      dapui.open()
    end, { desc = 'Debug: Open Debug UI' })
    vim.keymap.set('n', '<Leader>de', function()
      dapui.close()
    end, { desc = 'Debug: Close Debug UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- dap.listeners.after.event_breakpoint['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      dap_configurations = {
        {
          type = 'go',
          name = 'Attach remote',
          mode = 'remote',
          request = 'attach',
        },
      },
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
