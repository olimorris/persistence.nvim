pcall(vim.fn.system, "rm -rf tests/git_branch_data")

local session_dir = vim.fn.getcwd() .. "/tests/git_branch_data/"
require("persisted").setup({
  dir = session_dir,
  use_git_branch = true,
})

describe("Git Branching", function()
  it("creates a session", function()
    vim.fn.system("mkdir tests/git_branch_data")
    vim.fn.system("cd tests/git_branch_data && git init")

    assert.equals(vim.fn.system("ls tests/git_branch_data | wc -l"), "0\n")

    vim.cmd(":e tests/stubs/test_git_branching.txt")
    vim.cmd(":w tests/git_branch_data/test_git_branching.txt")

    require("persisted").save()
    assert.equals(vim.fn.system("ls tests/git_branch_data | wc -l"), "2\n")
  end)

  it("ensures the session has the branch name in", function()
    -- Workout what the name should be
    local pattern = "/"
    local name = vim.fn.getcwd():gsub(pattern, "%%") .. "_main.vim"
    local session = vim.fn.glob(session_dir .. "*.vim", true, true)[1]

    session:gsub(session_dir .. "/", "")
    assert.equals(session, vim.fn.getcwd() .. "/tests/git_branch_data/" .. name)
    -- assert.equals(sessions[1]:gsub(pattern, "%%"), name)
  end)
end)