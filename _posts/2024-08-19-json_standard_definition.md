---
layout: post
categories: blog
---

RFC8259：https://datatracker.ietf.org/doc/html/rfc8259

# json: 简介

1. json(javascript object notation)可以表示四种primitive types: strings, numbers, booleans and null, 和两种structured types:objects and arrays(这两个概念来自 JavaScript 的约定)。
2. strings是由零个或多个unicode字符组成的序列。
3. object是**零个或多个**name/value的**无序集合**; 其中name是strings; value是strings, numbers、booleans、null、objects或arrays。
4. array是**零个或多个**value的**有序序列**。



# json:语法和结构

## 基本语法

```
ws = *(
    %x20 /  ; Space, 空格
    %x09 /  ; Horizontal tab, 水平制表符, \t
    %x0A /  ; Line feed or New line, 换行键, \n
    %x0D    ; Carriage return, 回车键, \r
)

json-text = ws value ws ; value见后续解释

begin-array     = ws %x5B ws  ; [ left square bracket, 中括号-左

end-array       = ws %x5D ws  ; ] right square bracket, 中括号-右

begin-object    = ws %x7B ws  ; { left curly bracket, 大括号-左

end-object      = ws %x7D ws  ; } right curly bracket, 大括号-右

name-separator  = ws %x3A ws  ; : colon, 冒号

value-separator = ws %x2C ws  ; , comma, 逗号
```



## 构成

所有的json-text均由value构成

### value

1. value必须是object, array, string, number, 或者是下列字面意思的true, false和null之一构成。

2. 虽然RFC8259并没有明确说明, 但是根据以下描述意味着json文本(也就是一个json文件的内容)只能是一个单一的json值, 这个json值可以是一个objec, array, strings, numbers, booleans and null, 但只能有一个顶级结构。

   > RFC 8259 的第2节明确指出: 
   >
   > A JSON text is a serialized value. Note that certain previous specifications of JSON constrained a JSON text to be an object or an array. Implementations that generate only objects or arrays where a JSON value is expected will be interoperable in the sense that all implementations will accept these as conforming JSON texts. However, this specification allows any JSON value.
   >
   > 翻译如下:
   >
   > JSON 文本是一个序列化的值。请注意，以前的某些 JSON 规范将 JSON 文本限制为对象或数组。如果在需要 JSON 值的地方仅生成对象或数组的实现是可互操作的，因为所有实现都会接受这些作为符合 JSON 规范的文本。然而，这个规范允许任何 JSON 值。

3. 对于json文件来说, 单个的value也是合法的, 所以以下的单个json文件都是合法的:
   object.json, 仅object:

   ```json
   { "name": "value" }
   ```

   array.json, 仅array:

   ```json
   [ "value1", "value2", "value3" ]
   ```

   string.json, 仅string:

   ```json
   "Just a string"
   ```

   number.json, 仅number:

   ```json
   123456
   ```

   boolean.json, 仅boolean:

   ```json
   true
   ```

   null.json, 仅null

   ```json
   null
   ```

语法规则如下

```
false = %x66.61.6c.73.65   ; false

null  = %x6e.75.6c.6c      ; null

true  = %x74.72.75.65      ; true

value = false / null / true / object / array / number / string ; object, array, number, string见后续解释
```



### string

1. string以引号开头和结尾; 所有Unicode字符都可以放在引号内, 但必须转义的字符除外: 引号, 反斜线和控制字符(U+0000 到 U+001F)。
2. 任何字符都可以被转义。如果该字符位于基本多语言平面(U+0000 到 U+FFFF)中, 则它可以表示为一个六字符序列: 一个反斜线, 后跟小写字母u, 再后跟四个编码该字符的十六进制数字。十六进制字母 A 到 F 可以是大写或小写。因此, 例如, 仅包含单个反斜线字符的字符串可以表示为"\u005C"。
3. 一些流行字符的两个字符序列转义表示。因此, 例如, 仅包含单个反斜线字符的字符串可以更紧凑地表示为"\\"。
4. 为了转义不在基本多语言平面中的扩展字符, 该字符被表示为 12 个字符的序列, 对UTF-16代理项对进行编码。因此, 例如, 仅包含G clef (U+1D11E) 的字符串可以表示为"\uD834\uDD1E"。

语法规则如下

```
quotation-mark = %x22      ; "

escape = %x5C              ; \  表示转义字符

unescaped = ; 非转义字符
            %x20-21 /   ; 表示从空格( ，U+0020)到感叹号( !，U+0021)
            %x23-5B /   ; 表示从井号( #，U+0023)到左方括号( [，U+005B)
            %x5D-10FFFF ; 表示从右方括号( ]，U+005D)到U+10FFFF的Unicode代码点

char = unescaped / ; 未转义字符
       escape (    ; 转义字符
           %x22 /          ; "    quotation mark  U+0022  用于在字符串中插入双引号
           %x5C /          ; \    reverse solidus U+005C  用于在字符串中插入反斜杠
           %x2F /          ; /    solidus         U+002F
           %x62 /          ; b    backspace       U+0008
           %x66 /          ; f    form feed       U+000C
           %x6E /          ; n    line feed       U+000A
           %x72 /          ; r    carriage return U+000D
           %x74 /          ; t    tab             U+0009
           %x75 4HEXDIG )  ; uXXXX                U+XXXX  表示一个 Unicode 字符，其中 XXXX 是四位十六进制数，用于表示该字符的 Unicode 代码点

string = quotation-mark *char quotation-mark ; 
```

关于字符补充内容详见标题字符补充。



### number

1. 数字使用十进制, 它包含一个整数, 该整数可以带有可选的减号作为前缀, 其后可以是分数部分和/或指数部分。
2. 不允许使用前导零。
3. 若要添加小数部分, 则小数点后跟一位或多位数字。
4. 指数部分以大写或小写字母 E 开头, 后面可能跟有加号或减号。 E和可选符号后跟一位或多位数字。
5. 不允许使用以下语法无法表示的数值, 例如Infinity和NaN。
6. json规范允许不同的实现(即处理json的软件或库)对接受的数字的范围和精度设置限制。
7. json实现通常依赖IEEE-754双精度浮点数(double precision), 如果不超出其能力范围, 不同的实现可以很好地互操作。
8. 对于整数, 在`-(2^53)+1`到`(2^53)-1`之间的数值是完全可互操作的，所有实现都会对这些数字的值达成一致。

语法规则如下

```
minus = %x2D               ; -  负号
plus = %x2B                ; +  正号

zero = %x30                ; 0
digit1-9 = %x31-39         ; 1-9  数字1-9的表示

decimal-point = %x2E       ; .  小数点

e = %x65 / %x45            ; e/E 用来表示指数

int = zero / ( digit1-9 *DIGIT )        ;  整数部分的定义

frac = decimal-point 1*DIGIT             ; 小数部分的定义

exp = e [ minus / plus ] 1*DIGIT         ; 指数部分的定义

number = [ minus ] int [ frac ] [ exp ]  ;  数值的总体定义
```



### array

- 没有要求数组中的值必须相同类型

语法规则如下

```
begin-array     = ws %x5B ws  ; [ left square bracket
value-separator = ws %x2C ws  ; , comma
end-array       = ws %x5D ws  ; ] right square bracket

array = begin-array [ value *( value-separator value ) ] end-array
```



### object

1. object中的name**应该**是唯一的, 虽然这是**推荐的最佳实践**, 但并不是强制要求。如果json object中的所有name都是唯一的, 那么**不同的软件**实现之间在处理该object时能够**达成一致**, 确保互操作性, 这意味着接收该对象的所有软件都能正确识别每个键对应的值。如果对象中**存在重复的name**, 那么不同软件的**处理方式可能会不同**, 导致行为不可预测。例如: 有的软件只会返回最后一个name/value; 有的软件会报告错误或无法解析这个对象; 也有的软件会返回所有的键值对, 包括重复的键名。
2. 如果一个实现**不依赖对象成员的顺序**(**最佳实践**), 那么它在不同的实现之间就能够保持互操作性, 也就是说它不会受到这些顺序差异的影响。但是实现仍然可以保持对象中键值对的顺序。

语法规则如下

```json
begin-object    = ws %x7B ws  ; { left curly bracket
name-separator  = ws %x3A ws  ; : colon
end-object      = ws %x7D ws  ; } right curly bracket

member = string name-separator value
object = begin-object [ member *( value-separator member ) ] end-object
```



## 字符补充

1. 开放的系统之间交换 JSON 文本时, 必须使用 UTF-8 编码, 保证不同系统之间的数据兼容性。

2. **禁止添加 BOM**(Byte Order Mark): 在网络传输的json文本开头, 不允许添加字节顺序标记(BOM)。BOM 是一种用于指示文本文件的字节顺序的标记, 但json规范要求在传输json文本时不能使用BOM。

   > - 在Unicode编码中, BOM是一个可选的字符, 用于表示文本的字节顺序和编码格式。
   > - 对于UTF-16和UTF-32编码, BOM可以指示字节序(大端序或小端序)。
   > - 对于UTF-8编码, BOM 并不影响字节序, 因为 UTF-8 是字节顺序无关的编码。

3. **忽略 BOM**: 为了确保互操作性, 解析 JSON 文本的实现可以选择忽略 BOM 的存在, 而不是将其视为错误。

4. 当json中的字符串完全由有效的Unicode字符组成时, 不同的解析器可以一致地解释这些字符串。

5. 如果json中包含无法有效表示的字符(如未配对的 UTF-16 代理项), 处理这些字符的软件可能会表现出不可预测的行为, 甚至可能导致运行时错误。

6. 软件实现需要确保字符串比较的一致性。如果将字符串的文本表示转换为Unicode代码单元进行比较, 所有实现将一致地判断字符串的相等性。例如, `a\\b`和`a\u005Cb`, 实际上，这两个表示的字符串是相同的（`a\b`）

7. 避免将转义字符与原始字符形式混淆, 以确保比较操作的正确性。



## 解析器和生成器

1. **解析器的定义**：JSON 解析器将 JSON 文本转换为另一种表示形式。解析器必须能够接受所有符合 JSON 语法的文本。这意味着解析器必须正确处理所有符合 JSON 规范的输入。解析器可以限制接受的文本的大小、限制 JSON 对象和数组的最大嵌套深度、限制接受的数字的范围和精度、限制字符串的最大长度以及字符串中允许的字符类型
2. **扩展性**：解析器可以接受非标准的 JSON 格式或扩展。这允许解析器支持 JSON 规范之外的额外特性，但这不是必须的，也不应影响标准 JSON 的处理。
3. **生成器的定义**：JSON 生成器生成 JSON 文本。生成的文本必须严格符合 JSON 语法规范。这意味着生成器生成的 JSON 数据必须是有效的 JSON 格式，并符合 JSON 规范的所有要求。





## json sample

这是一个json object

```json
{
  "Image": {
      "Width":  800,
      "Height": 600,
      "Title":  "View from 15th Floor",
      "Thumbnail": {
          "Url":    "http://www.example.com/image/481989943",
          "Height": 125,
          "Width":  100
      },
      "Animated" : false,
      "IDs": [116, 943, 234, 38793]
    }
}
```

这是一个json array并且包含了两个元素object

```json
[
  {
     "precision": "zip",
     "Latitude":  37.7668,
     "Longitude": -122.3959,
     "Address":   "",
     "City":      "SAN FRANCISCO",
     "State":     "CA",
     "Zip":       "94107",
     "Country":   "US"
  },
  {
     "precision": "zip",
     "Latitude":  37.371991,
     "Longitude": -122.026020,
     "Address":   "",
     "City":      "SUNNYVALE",
     "State":     "CA",
     "Zip":       "94085",
     "Country":   "US"
  }
]
```

下列是三个只有value的json文本

第一个

```json
"Hello world!"
```

第二个

```json
42
```

第三个

```json
true
```

