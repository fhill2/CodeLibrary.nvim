local config = {
  display = {
    non_interactive = false,
    open_fn = nil,
    open_cmd = '65vnew [packer]',
    working_sym = '⟳',
    error_sym = '✗',
    done_sym = '✓',
    removed_sym = '-',
    moved_sym = '→',
    header_sym = '━',
    header_lines = 2,
    title = 'downloading codelibrary',
    show_all_info = true,
    keybindings = {quit = 'q', toggle_info = '<CR>', diff = 'd', prompt_revert = 'r'}
  },
  install_dir = '/home/f1/code-library/cl'
}


return config
