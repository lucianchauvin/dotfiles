config.load_autoconfig()
config.source('gruvbox.py')
c.editor.command = ['alacritty', '-e', 'nvim', '{file}', '-c', 'normal {line}G{column0}l']
c.fonts.default_size = "11pt"
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access"
config.bind("<Escape>", "clear-messages")
