---
layout: page
title: how to modify this project
---

这个文档对应的项目目录是：

```text
/home/shecannotsee/Desktop/shecannotsee.github.io
```

线上仓库与页面分别是：

- 仓库：<https://github.com/shecannotsee/shecannotsee.github.io>
- 页面：<https://shecannotsee.github.io>

## 现在这个站点是怎么组织的

这次改版以后，首页不再依赖 `_data/menu.yml` 渲染，而是分成两类内容来源：

1. 固定信息：放在 `_data/site_profile.yml`
2. 文章内容：放在 `_posts/` 目录

也就是说：

- 你要改首页文案、导航、项目列表、联系方式：改 `_data/site_profile.yml`
- 你要改“关于我”页面：改 `about_me.md`
- 你要新增文章：在 `_posts/` 里新增 Markdown 文件
- 你要改样式：改 `assets/css/main.scss`
- 你要改首页结构：改 `_layouts/home.html`

## 最常改的文件

### 1. 修改站点基础信息

文件：`_config.yml`

这里控制：

- 站点标题 `title`
- 作者 `author`
- 邮箱 `email`
- 站点地址 `url`
- 站点描述 `description`

如果你以后换域名，最先要改的就是这里的 `url`。

## 2. 修改首页固定内容

文件：`_data/site_profile.yml`

这个文件控制：

- 顶部导航：`navigation`
- 首页首屏：`hero`
- 当前关注点：`status`
- 个人简介卡片：`highlights`
- 项目列表：`projects`
- 联系方式和维护入口：`contacts`

例如，你想增加一个导航项：

```yaml
navigation:
  - title: /home
    url: /
  - title: /archive
    url: /archive.html
  - title: /new-page
    url: /new_page.html
```

例如，你想新增一个项目：

```yaml
projects:
  title: Selected Projects
  items:
    - name: sheBase64
      status: stable experiment
      description: 用来试验项目结构、构建方式和测试组织的基础项目。
      url: https://github.com/shecannotsee/sheBase64
    - name: newProject
      status: in progress
      description: 这里写这个项目的简介。
      url: https://github.com/shecannotsee/newProject
```

## 3. 修改“关于我”页面

文件：`about_me.md`

这是独立页面，使用 `page` 布局。你直接改正文内容即可。

如果你想增加更多独立页面，也可以照着它新建一个 Markdown 文件：

```md
---
layout: page
title: my new page
---

这里写正文
```

然后再去 `_data/site_profile.yml` 里的 `navigation` 加一个入口。

## 4. 新增文章并让首页自动显示

文件目录：`_posts/`

文章文件名必须符合 Jekyll 规则：

```text
YYYY-MM-DD-title.md
```

例如：

```text
2026-03-30-my_new_post.md
```

文章头部至少这样写：

```md
---
layout: post
categories: blog
title: 我的新文章
---
```

说明：

- `layout: post` 表示这是文章页
- `categories: blog` 会让它进入首页的 Blog 区域
- 如果你写的是库相关内容，可以用 `categories: lib`
- 新文章会自动出现在首页的 `Latest Posts` 区域

如果一篇文章既想出现在总列表，也想打分类，可以这样写：

```md
---
layout: post
title: 某篇文章
categories:
  - blog
  - cpp
---
```

## 5. 修改首页和全站样式

文件：`assets/css/main.scss`

这里已经集中定义了：

- 颜色变量
- 首页卡片布局
- 导航样式
- 文章页样式
- 代码块样式
- 手机端适配

如果你只想改颜色，优先修改文件开头的 `:root` 变量。

## 6. 修改首页结构

文件：`_layouts/home.html`

这个文件控制首页模块顺序，比如：

- 首屏 Hero
- About
- Projects
- Latest Posts
- 分类文章区
- 联系方式

如果你要新增一个新的首页模块，通常做法是：

1. 先在 `_data/site_profile.yml` 增加对应数据
2. 再在 `_layouts/home.html` 增加对应的 HTML/Liquid 模板

## 7. 本地预览

在项目目录 `/home/shecannotsee/Desktop/shecannotsee.github.io` 下执行：

```bash
bundle exec jekyll serve
```

然后打开：

```text
http://127.0.0.1:4000
```

如果只是检查能否构建，也可以执行：

```bash
bundle exec jekyll build
```

## 8. 发布方式

这是 GitHub Pages 仓库，通常只要把修改推到默认分支，GitHub 就会自动重新构建页面。

一个常见流程是：

```bash
git status
git add .
git commit -m "feat: refresh homepage design"
git push
```

## 9. 这次改版里最关键的文件

如果你以后要继续维护，优先记住这几个：

- `_data/site_profile.yml`
- `_layouts/home.html`
- `assets/css/main.scss`
- `about_me.md`
- `_posts/`
- `_config.yml`

只改文案时，优先不要碰布局文件；只改内容时，大多数情况下只需要改数据文件和文章文件。
