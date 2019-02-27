## Koa VS Express
* Koa由Express团队开发。
* 中间件方面
	1. Koa更侧重于中间件的功能性。
	2. 实现完全不同
* Express内置了完整的中间件套件。Koa比较轻量，可以根据自己的需要`include`具体的模块	
* Express扩展了NodeJs的`req`和`res`对象，Koa则完全地使用上下文对象`ctx`(`ctx.request`和`ctx.response`)替换了两者。
* Express使用Callbacks实现异步，Koa通过NodeJs关键字`async/await`实现异步。
##### Callback方式:
```
function myFunction(params, callback){
	//make async call here
	asyncCall(params, function(res) {
		callback(res);
	})
}

myFunction(myParams, function(data){
  //do something with 'data' here
})
```
##### 关键字async/await:
```
async myFunction(){
	try	{
		let res = await asyncCall();
		return res;
	}
	catch(err){
		console.log("Error: " + err);
	}
}

let result = await myFunction();
```