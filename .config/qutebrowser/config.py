config.load_autoconfig()
config.source('gruvbox.py')
c.editor.command = ['alacritty', '-e', 'nvim', '{file}', '-c', 'normal {line}G{column0}l']
config.bind("<Escape>", "clear-messages")
