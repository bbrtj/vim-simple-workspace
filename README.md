# Simple Workspace

A simple vim layer to mksession with multiple named workspaces.

Using this plugin you can save and restore named vim sessions (later referred to as workspaces) with simple commands globally. Some of the features are:

* Save and load workspaces with the name you pick
* List all available workspaces
* Autosave workspaces (on switching to another one / closing workspace / closing vim)

## Usage

### Configuration

* `g:simplews_root` - by default it is set to `~/.vim/workspaces/`. Plugin will try to create path under this variable on loading. This should be changed on systems where default value is not a valid path. Make sure to include a directory separator at the end
* `g:simplews_short_commands` - when set to 1 will trigger creation of short aliases for significant commands (will override `W` `E` `F`)
* `g:simplews_autosave` - when set to 1 will cause workspaces to be saved on closing or closing vim
* `g:simplews_autoload` - when set to workspace's name will cause it to be loaded on starting vim. Warning: this currently does not work well with opening files via command line argument for vim and will cause all these files to close

### Commands

* `SWWrite [ {name} ]` - Writes a new session file under {name} and opens it. If no {name} is specified then saves the currently open workspace
* `SWRead[!] {name}` - Closes the current buffers and opens workspace {name}. Stops if some buffers are modified. With !bang, closes all the buffers without saving
* `SWClose[!]` - Closes the current buffers and current workspace. !Bang behavior same as in `SWRead`
* `SWDelete[!]` - Closes the current buffers and deletes the current workspace. !Bang behavior same as in `SWRead`
* `SWShow[!]` - Shows the currently open workspace's name. With !bang, shows the full path to session file
* `SWList` - Shows the list of available workspaces. This is a list of all vim files in workspaces root directory

### Short commands

With `g:simplews_short_commands` set to 1 new command aliases are defined:

* `W [ {name} ]` - alias for SWWrite
* `E[!] {name}` - alias for SWRead
* `F[!]` - alias for SWShow

### Explaination

When you open a workspace the plugin will set its state and future commands will use that state as current workspace. This allows you to simply call `SWWrite` to save a workspace you're working in without specifying its name.

When you close a workspace all of its buffers will be unloaded with `bufdo bw!`, which also means that all your windows but the last one will be closed. Unsaved changes in buffers will cause closing workspace to fail before wiping out any buffer. Bang in commands which close workspaces will force vim to close them without saving.

To create a new workspace use `SWWrite` with name argument. This will close the previous workspace (if any was open) without deleting its buffers.

If you choose to use autosave be careful when closing vim. If you use `q` instead of `qa` then the last state before using `qa` will be saved, which might not be what you want. Without autosave you can use the plugin to create a base for each of your projects and then quickly swap between them, using some temporary workspaces if neccessary.

Autoload if set can get in your way often, but it might be helpful if you use vim more like IDE and less like text editor.

## Mksession compatibility

This plugin uses raw `Mksession!` to store workspaces' data, and as a consequence shares all it's limitations.

For example, `Mksession` currently cannot save state of NERDTree window and therefore shows an empty window in its place after loading. If this or any other incompatibility is a problem for you, consider using another plugin or work around it by setting up commands to close plugin's window before saving a workspace (and, with autosave, autocmd to close plugin windows on `VimLeavePre`)

## Author and license

Author: Bartosz Jarzyna "brtastic" <brtastic.dev@gmail.com>

License: MIT
