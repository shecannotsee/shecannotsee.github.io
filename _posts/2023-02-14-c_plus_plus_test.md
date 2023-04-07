---
layout: post
markdown: kramdow
---
## gtest

Google Test是Google开源的一个C++单元测试框架。以下是Google Test的一些主要功能和函数：

1. 断言：Google Test提供了一组断言函数，例如`EXPECT_EQ`、`ASSERT_NE`等，用于测试代码的期望输出。
2. 测试用例：使用Google Test可以定义测试用例，测试用例是一组断言，每个断言测试一个独立的功能。
3. 测试套件：测试用例可以分组为测试套件，以便更好地管理测试用例。
4. 参数化测试：Google Test支持参数化测试，可以使用一组数据集进行多次测试。
5. 测试回调：Google Test允许在测试前后添加回调函数，以便在测试运行前进行预处理和后处理。

以下是一些常用的Google Test函数：

- `TEST(test_suite_name, test_name)`：定义一个测试用例。
- `TEST_F(fixture_name, test_name)`：定义一个使用公共测试数据的测试用例。
- `TYPED_TEST(test_suite_name, test_name)`：定义一个类型参数化测试用例。
- `TYPED_TEST_SUITE(suite_name, type_list)`：定义一个类型参数化测试套件。
- `INSTANTIATE_TYPED_TEST_SUITE_P(suffix, suite_name, type_list)`：生成一个类型参数化测试套件的实

## Google Benchmark

Google Benchmark是Google开源的一个C++性能基准测试库。以下是Google Benchmark的一些主要功能和函数：

1. 性能基准：Google Benchmark允许测量代码的性能，如运行时间、内存使用等。
2. 基准点：Google Benchmark使用基准点（benchmark point）来测量性能，一个基准点是一个单独的性能测试。
3. 基准套件：Google Benchmark支持基准套件，基准套件是一组相关的基准点。
4. 报告：Google Benchmark生成一份详细的测试报告，报告中包含每个基准点的性能数据。
5. 参数化基准：Google Benchmark支持参数化基准，可以使用多组参数数据测试基准。

以下是一些常用的Google Benchmark函数：

- `BENCHMARK(benchmark_name)`：定义一个基准点。
- `BENCHMARK_CAPTURE(benchmark_name, benchmark_params)`：定义一个携带参数的基准点。
- `BENCHMARK_MAIN()`：定义一个`main`函数，并运行所有基准点。
- `BENCHMARK_ADVANCED(benchmark_name)`：定义一个高级基准点，允许控制基准点的运行参数。
- `BENCHMARK_REGISTER_F(fixture_name, benchmark_name)`：定义一个使用公共测试数据的基准点。