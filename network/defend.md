## 网站防御
* CSRF(Cross—Site Request Forgery), 跨站点请求伪造。

    防御CSRF，关键在于在请求中放入黑客所不能伪造的信息，并且该信息不存在于 cookie 之中。

    防御策略:

    * 验证 HTTP Referer 字段
    * 在请求地址中添加 token 并验证
    * 在 HTTP 头中自定义属性并验证。
    
* XSS，也称CSS(Cross SiteScript), 跨站脚本攻击
    
    防御策略：

    * 完善过滤体系，只允许输入合法值
    * html encode，存储时encode，展示时转化成文本内容显示