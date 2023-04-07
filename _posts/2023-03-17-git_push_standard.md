---
layout: post
---
## git提交规范

- **feat**：（feature）提交新的功能
- **fix**：解决了bug
- **docs**：（documentation）修改的是文档相关的内容
- **style**：格式修改，没有修改代码逻辑，比如格式化、换行等
- **refactor**：重构代码，既没有新增功能，也没有修复bug，比如提取某段代码为一个方法、重构某个功能
- **perf**：性能、体验优化等，记忆：performance性能
- **test**：新增test用例或修改现有测试用例
- **chore**：构建过程或辅助工具的变动，非src和test的修改，比如构建流程, 依赖管理等



## 添加子模块

```bash
# 进入项目后
mkdir third_party
# 在third_party目录下添加子模块googletest 即可
git submodule add https://github.com/google/googletest ./third_party/googletest

# 若从其他地方clone项目下来第三方库未加载则使用以下命令来加载第三方库
git submodule update --init
```



## 代码里注释规范

**TODO**：英语翻译为待办事项，备忘录。如果代码中有该标识，说明在标识处有功能代码待编写，待实现的功能在说明中会简略说明。

**FIXME**：可以拆成短语，fix me ，意为修理我。如果代码中有该标识，说明标识处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。

**XXX**：如果代码中有该标识，说明标识处代码虽然实现了功能，但是实现的方法有待商榷，希望将来能改进，要改进的地方会在说明中简略说明。

**HACK**：英语翻译为砍。如果代码中有该标识，说明标识处代码我们需要根据自己的需求去调整程序代码。



## 使用ssh git的问题解决

当使用 `sudo git pull` 命令时，Git 将使用 root 用户的身份来执行该命令。这可能会导致 SSH 密钥不匹配的问题，因为您的 SSH 密钥是使用您的普通用户帐户生成的，而不是 root 用户帐户。

因此，如果您在普通用户帐户下已经成功配置了 SSH 密钥，并且使用 `sudo git pull` 命令时遇到了 "Permission denied (publickey)" 错误，则可能是因为 root 用户无法访问您的 SSH 密钥文件。

为了解决这个问题，您可以尝试在不使用 `sudo` 的情况下执行 `git pull` 命令。如果这不可行，您可以将您的 SSH 密钥文件复制到 root 用户的家目录中，然后使用 `sudo` 命令运行 `git pull`。

具体来说，您可以执行以下步骤：

1. 使用以下命令将 SSH 密钥文件复制到 root 用户的家目录中：

   ```
   bashCopy codesudo cp ~/.ssh/id_rsa /root/.ssh/
   sudo cp ~/.ssh/id_rsa.pub /root/.ssh/
   ```

2. 确保 root 用户拥有 `.ssh` 文件夹和密钥文件的适当权限：

   ```
   bashCopy codesudo chown -R root:root /root/.ssh
   sudo chmod 700 /root/.ssh
   sudo chmod 600 /root/.ssh/id_rsa
   sudo chmod 644 /root/.ssh/id_rsa.pub
   ```

3. 然后使用以下命令来进行 `git pull` 操作：

   ```
   Copy code
   sudo git pull
   ```

这样就可以使用 `sudo git pull` 命令来拉取代码，并且 root 用户也可以正确访问您的 SSH 密钥文件了。