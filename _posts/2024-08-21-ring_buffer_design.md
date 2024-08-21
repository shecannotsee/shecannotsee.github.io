---
layout: post
categories: blog
---



# RING BUFFER

## 设计

- 使用固定长度数组加上头尾指针(实现是下标)来处理环形队列
- header永远表示第一个可以读取的数据单元(可读)
- tail永远表示可以写入的数据单元(可写)
- 但是为了处理初始的状态(此时header和tail重合), 需要一个额外的empty来表示ring buffer是否为空。



## 推理

### 实践过程

1. **初始化状态**: 首先申请一个固定大小(10)的数组这里称为data, data.size()是10, 如下显示

   ```
     empty: true
     index:   0   1   2   3   4   5   6   7   8   9   
   element: {00}{00}{00}{00}{00}{00}{00}{00}{00}{00}
    header:   |
      tail:   |
   
   element: {},size:0
   ```

2. 添加元素01

   ```
     empty: false
     index:   0   1   2   3   4   5   6   7   8   9   
   element: {01}{00}{00}{00}{00}{00}{00}{00}{00}{00}
    header:   |
      tail:       |
      
   element: {1},size:1
   ```

   步骤如下: 添加元素; 移动tail; 检查tail

3. **taile末尾边界添加元素**: 一直添加数据(2,3,4,5,6,7,8,9), 直到数组的末尾, 如下

   ```
     empty: false
     index:   0   1   2   3   4   5   6   7   8   9   
   element: {01}{02}{03}{04}{05}{06}{07}{08}{09}{00}
    header:   |
      tail:                                       |
      
      
   element: {1,2,3,4,5,6,7,8,9},size:9
   ```

   此时在index-9插入元素10
   步骤如下: 添加元素; 移动tail(因为index-10所以移动到index-0); 检查tail(tail和header重合, 所以header从index-0移动到index-1)

   ```
     empty: false
     index:   0   1   2   3   4   5   6   7   8   9   
   element: {01}{02}{03}{04}{05}{06}{07}{08}{09}{10}
    header:       |
      tail:   |
      
   element: {2,3,4,5,6,7,8,9,10},size:9
   ```

   此时发现实际的buffer大小就只有9了, 所以在**最开始申请buffer大小的时候多申请一个元素单元较好**

4. **header末尾边界添加元素**: 一直添加数据(11,12,13,14,15,16,17,18), 直到数组的末尾, 如下

   ```
     empty: false
     index:   0   1   2   3   4   5   6   7   8   9   
   element: {11}{12}{13}{14}{15}{16}{17}{18}{09}{10}
    header:                                       |
      tail:                                   |
   
   element: {10,11,12,13,14,15,16,17,18},size:9
   ```

   此时在index-9插入元素19
   步骤如下: 添加元素; 移动tail(没有月结); 检查tail(tail和header重合, 所以需要移动header, 移动header时发现到处于边界, header从index-9移动到index-0)

   ```
     empty: false
     index:   0   1   2   3   4   5   6   7   8   9   
   element: {11}{12}{13}{14}{15}{16}{17}{18}{19}{10}
    header:   |                                    
      tail:                                       |
      
   element: {11,12,13,14,15,16,17,18,19},size:9
   ```

5. 接下来可以从步骤3开始进行循环了, 推理结束

### 总结要点

1. 初始化状态可以参考时间过程中的step1
2. 在申请buffer大小时需要预留一个元素单位来进行写操作
3. 可以总是按照以下步骤进行操作: (1)添加元素; (2)移动tail; (3)移动tail后检查是否越界; (4)检查tail是否和header重合; (5)重合则移动header; (6)移动header后检查是否越界;
4. 对于越界操作, 则将index扭转到0即可



