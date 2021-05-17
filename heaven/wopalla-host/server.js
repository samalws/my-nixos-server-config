// npm install node-static

const http = require("http")
const nodeStatic = require("node-static");

function main() {
	const files = new(nodeStatic.Server)("../wopalla.com/");
	const htServer = http.createServer((req,res) => files.serve(req,res)).listen(446);
}

main()
