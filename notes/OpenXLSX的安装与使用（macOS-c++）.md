首先是OpenXLSX的主页
https://github.com/troldal/OpenXLSX
git colne下来
然后

```bash
#在目录OpenXLSX下，pwd出来是../OpenXLSX/
mkdir build
cd build
cmake ..
#......
cmake --build . --target OpenXLSX --config Release
#......
#然后使用install安装
make install
#......
#接下来可以去/usr/local/目录下查看include和lib下是否有对应的文件
```
接下来进行代码测试
*makefile*
```bash
test:
	g++ -std=c++17 demo.cpp -o main \
		-I/usr/local/include/OpenXLSX \
		-lOpenXLSX
```
demo,cpp

```cpp
#include <OpenXLSX.hpp>

using namespace OpenXLSX;

int main() {

    XLDocument doc;
    doc.create("Spreadsheet.xlsx");
    auto wks = doc.workbook().worksheet("Sheet1");
    wks.cell("A1").value() = "你好!";//因为作者在readme中有说该库对编码格式支持不够完整，故用来测试，详细可以看github上的README
    doc.save();
    return 0;
}
```

案例完成。