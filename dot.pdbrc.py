import pdb

class Config(pdb.DefaultConfig):
    sticky_by_default = True
    disable_pytest_capturing = True

    def __init__(self):

        try:
            from pygments.formatters import terminal
        except ImportError:
            pass
        else:
            self.colorscheme = terminal.TERMINAL_COLORS.copy()
            self.colorscheme.update({
                terminal.Keyword:            ('darkred',     'red'),
                terminal.Number:             ('darkyellow',  'yellow'),
                terminal.String:             ('brown',       'green'),
                terminal.Name.Function:      ('darkgreen',   'brown'),
                terminal.Name.Namespace:     ('teal',        'turquoise'),
                })
