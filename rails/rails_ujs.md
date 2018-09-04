## rails_ujs探索
rails-ujs前身是jquery_ujs, rails-ujs在Rails5.1.0之后就移入到Rails中了
`actionview-5.1.6/lib/assets/compiled/rails-ujs.js`
以下只针对`link_to`的`remote: true`进行源码解读，探究如何实现异步js请求的
### 1. [link_to](http://edgeapi.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to)
根据Rails文档可知:

```
<%= link_to "an article", @article, remote: true %>
```
which generates
```
<a href="/articles/1" data-remote="true">an article</a>
```
### 2. 主要js代码
#### 第一处
```
// 定义了一些用于获取相关元素的选择器变量
var context = this;
  (function() {
    (function() {
      this.Rails = {
        linkClickSelector: 'a[data-confirm], a[data-method], a[data-remote]:not([disabled]), a[data-disable-with], a[data-disable]',
        buttonClickSelector: {
          selector: 'button[data-remote]:not([form]), button[data-confirm]:not([form])',
          exclude: 'form button'
        },
        ... //此处有省略
      };
    }).call(this);
  }).call(context);

  var Rails = context.Rails;
```
#### 第二处
```
(function() {
  var AcceptHeaders, CSRFProtection, createXHR, fire, prepareOptions, processResponse;
  CSRFProtection = Rails.CSRFProtection, fire = Rails.fire;
  // 定义AcceptHeaders
  AcceptHeaders = {
    '*': '*/*',
    text: 'text/plain',
    html: 'text/html',
    xml: 'application/xml, text/xml',
    json: 'application/json, text/javascript',
    script: 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript'
  };
  ... //此处有省略
})
```
#### 第三处
```
// 绑定click事件
1. delegate(document, Rails.linkClickSelector, 'click', handleDisabledElement);
2. delegate(document, Rails.linkClickSelector, 'click', handleConfirm);
3. delegate(document, Rails.linkClickSelector, 'click', handleMetaClick);
4. delegate(document, Rails.linkClickSelector, 'click', disableElement);
5. delegate(document, Rails.linkClickSelector, 'click', handleRemote); # 我们关注下这一行
6. delegate(document, Rails.linkClickSelector, 'click', handleMethod);

// 再看下delegate的实现, 可以看出方法实现了各种绑定事件, 触发点击时执行handler, 即 handleRemote
Rails.delegate = function(element, selector, eventType, handler) {
		// 第5行传入的参数对应为element = document, selector = Rails.linkClickSelector, eventType = 'click', handler = handleRemote
        return element.addEventListener(eventType, function(e) {
          var target;
          target = e.target;
          ... //此处有省略
          if (target instanceof Element && handler.call(target, e) === false) {
            e.preventDefault();
            return e.stopPropagation();
          }
        });
      };
```
#### 最后一处
```
Rails.handleRemote = function(e) {
	... //此处有省略
	if (!isRemote(element)) {
          return true;
    }
    ... //此处有省略
	dataType = element.getAttribute('data-type') || 'script';
	if (matches(element, Rails.formSubmitSelector)) {
		...
	} else if (matches(element, Rails.buttonClickSelector) || matches(element, Rails.inputChangeSelector)) {
		...
	} else {
      // 获取元素的method, href, params
	  method = element.getAttribute('data-method');
      url = Rails.href(element);
      data = element.getAttribute('data-params');
	}
	ajax({
          type: method || 'GET',
          url: url,
          data: data,
          dataType: dataType, // dataType为'script'
          beforeSend: function(xhr, options) {
            if (fire(element, 'ajax:beforeSend', [xhr, options])) {
              return fire(element, 'ajax:send', [xhr]);
            } else {
              fire(element, 'ajax:stopped');
              return false;
            }
          },
          ... //此处有省略
       })   
}
```
#### 至此就能解开我们一开始的疑惑了
