node.default['auto-patch']['disable'] = false
node.default['auto-patch']['hour'] = 3
node.default['auto-patch']['minute'] = 0
node.default['auto-patch']['monthly'] = 'first sunday'
node.default['auto-patch']['reboot'] = false
node.default['auto-patch']['splay'] = 120
node.default['auto-patch']['weekly'] = "saturday"

node.default['auto-patch']['prep']['clean'] = true
node.default['auto-patch']['prep']['disable'] = true
node.default['auto-patch']['prep']['hour'] = 2
node.default['auto-patch']['prep']['minute'] = 0
node.default['auto-patch']['prep']['monthly'] = 'first sunday'
node.default['auto-patch']['prep']['splay'] = 1800
node.default['auto-patch']['prep']['weekly'] = nil
node.default['auto-patch']['prep']['update_updater'] = true

include_recipe 'auto-patch::default'
