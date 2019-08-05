### 解决下载中文文件名乱码(Content-Disposition)
解决办法：
```
String fileName = "转移线索错误报告-20190731113352.xlsx";
// 使用 utf-8 对文件名 进行 encode
String encodedFileName = URLEncoder.encode(fileName, "utf-8");
String disposition = "attachment;filename=" + encodedFileName;

HttpHeaders headers = new HttpHeaders();
headers.add(HttpHeaders.CONTENT_DISPOSITION, disposition);
```