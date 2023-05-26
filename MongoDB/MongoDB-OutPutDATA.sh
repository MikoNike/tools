#!/bin/bash

MongoDB 查询数据并导出

1. 编写JS脚本查询并导出 "JSON" 以及 "CSV" 数据

2. JS脚本编写

	第一行是查询MongoDB集合的查询条件
	第二行是循环读取并输出查询条件
	一个js脚本里面可以包含一个库里面 多个合集的查询条件
	遇到类似的情况可以让研发编写并提供JS脚本 或者我们自己编写

		var c = db.playerCollection0.find({"_id":31001});
		while(c.hasNext()) {
			printjson(c.next());
		}

		var d = db.playerCollection0.find({"_id":21301});
		while(d.hasNext()) {
			printjson(d.next());
		}

		var e = db.barCollection.find({"_id":31001});
		while(e.hasNext()) {
			printjson(e.next());
		}

		var f = db.barCollection.find({"_id":21301});
		while(f.hasNext()) {
			printjson(f.next());
		}
        
3. 如何使用 JS脚本查询并导出JSON或者CSV数据
	demo：
		mongo IP:端口/数据库名称 --username root —password --authenticationDatabase admin  ./query.js > result.json
		mongo IP:端口/数据库名称 --username root —password --authenticationDatabase admin  ./query.js > result.CSV
	例子：
		mongo 127.0.0.1:27017/time_game_1 --username root —password --authenticationDatabase admin  ./query.js > result.json
