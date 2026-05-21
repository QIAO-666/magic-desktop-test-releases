# Magic Desktop Test Releases

这个仓库用于分发 Magic 桌面端内测安装包和 OTA 测试清单。

当前定位是内测阶段：

- 安装包都是测试包，不代表正式发布版本。
- 暂不强制处理 macOS notarization / Windows code signing。
- macOS 与 Windows 的版本号暂时允许不统一，正式发布前再统一。
- 仓库可以公开，但不放源码、密钥、服务端配置和用户数据。

## 最新 macOS 测试包

当前测试版本：`0.4.18`

Release Tag：`v0.4.18-mac-test.1`

Release 页面：

- https://github.com/QIAO-666/magic-desktop-test-releases/releases/tag/v0.4.18-mac-test.1

预计资产：

- `Magic-0.4.18-arm64.dmg`
- `Magic-0.4.18-intel.dmg`

## 给 AI Agent 的安装规则

AI Agent 不需要解析自然语言 README 来判断最新版本，优先读取机器可读清单：

- `manifests/latest-mac.json`

推荐流程：

1. 读取 `manifests/latest-mac.json`。
2. 根据本机架构选择 `macos.latest.installers.arm64` 或 `macos.latest.installers.intel`。
3. 下载对应 DMG 到临时目录。
4. 校验 `sha256` 和 `size`。
5. 退出正在运行的 `Magic.app`。
6. 挂载 DMG。
7. 将 `Magic.app` 复制到 `/Applications/Magic.app`，覆盖旧版本。
8. 卸载 DMG。
9. 打开 `/Applications/Magic.app`。

README 只作为人类说明和兜底说明，不作为自动升级协议本身。

## 仓库结构

```text
README.md
manifests/
  latest-mac.json
  latest-windows.json
docs/
  ota-test-flow.md
  ai-agent-install.md
releases/
  v0.4.18-mac-test.1.md
scripts/
  install-latest-mac.sh
```

## 后续接入桌面端 OTA

内测阶段可以先做一个简化版更新器：

- 启动后检查 `manifests/latest-mac.json`。
- 发现远程版本高于当前版本后提示用户下载。
- 下载完成后提示重启安装。
- 安装失败时保留旧版本，不删除用户数据。

正式版再补齐签名、公证、灰度、回滚和多平台统一版本策略。
