return {
	{
		"microsoft/vscode-js-debug",
		version = "1.x",
		-- if build command fails, you may need to run manually as sudo
		build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
	},
}
