const http = require("http")

function main() {
	const redirServer = http.createServer((req,res) => {
		res.writeHead(301, {location: "https://"+req.headers.host+req.url })
		res.end()
	})
	redirServer.listen(80,() => {})
}

main()
