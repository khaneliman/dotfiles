return {
	"goolord/alpha-nvim",
	opts = function(_, opts)
		-- customize the dashboard header
		opts.section.header.val = {
			"                                                       ",
			"                                                       ",
			"                                                       ",
			" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
			" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
			" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
			" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
			" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
			" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
			"                                                       ",
			"                                                       ",
			"                                                       ",
			"                                                       ",
		}
		opts.section.buttons.val = {
			astronvim.alpha_button("LDR f f", "  Find File  "),
			astronvim.alpha_button("LDR f o", "  Recents  "),
			astronvim.alpha_button("LDR f p", "P  Projects  "),
			astronvim.alpha_button("LDR f n", "  New File  "),
			astronvim.alpha_button("LDR S l", "  Last Session  "),
		}

		return opts
	end,
}
