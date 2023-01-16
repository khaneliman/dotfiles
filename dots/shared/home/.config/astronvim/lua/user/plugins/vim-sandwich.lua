return {
	"machakann/vim-sandwich",
	keys = {
		"sa", -- Press sa{motion/textobject}{addition}. For example, a key sequence saiw( makes foo to (foo).
		"sd", -- Press sdb or sd{deletion}. For example, key sequences sdb or sd( makes (foo) to foo. sdb searches a set of surrounding automatically.
		"sr", -- Press srb{addition} or sr{deletion}{addition}. For example, key sequences srb" or sr(" makes (foo) to "foo".
	},
}
