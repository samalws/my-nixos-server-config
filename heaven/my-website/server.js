// npm install node-static

const http = require("http")
const nodeStatic = require("node-static");

function main() {
	const files = new(nodeStatic.Server)("../samalws.com-3/");
	const htServer = http.createServer((req,res) => files.serve(req,res)).listen(445);
}

main()
