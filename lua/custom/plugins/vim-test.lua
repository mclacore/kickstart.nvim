return {
  'vim-test/vim-test',
  config = function()
    vim.g['test#strategy'] = 'vimux'
  end,
  cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast' },
  keys = {
    { 'n', '<leader>tn', '<cmd>TestNearest<cr>' },
    { 'n', '<leader>tf', '<cmd>TestFile<cr>' },
    { 'n', '<leader>ts', '<cmd>TestSuite<cr>' },
    { 'n', '<leader>tl', '<cmd>TestLast<cr>' },
  },
}
