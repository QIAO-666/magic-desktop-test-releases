# AI Agent 安装说明

AI Agent 应该读取 manifest，而不是从 README 文本中猜测最新版本。

## macOS

manifest：

```text
https://raw.githubusercontent.com/QIAO-666/magic-desktop-test-releases/main/manifests/latest-mac.json
```

安装步骤：

1. 读取 manifest。
2. 比较 `macos.latest.version` 与本地版本。
3. 下载 `macos.latest.installer.url`。
4. 校验 `sha256` 和 `size`。
5. 退出本地 `Magic.app`。
6. 挂载 DMG。
7. 复制 DMG 内的 `Magic.app` 到 `/Applications/Magic.app`。
8. 卸载 DMG。
9. 打开 `/Applications/Magic.app`。

## 失败处理

- 下载失败：重试，最多 3 次。
- 哈希不一致：删除下载文件，不安装。
- 挂载失败：删除下载文件，不安装。
- 复制失败：保留旧版本，提示人工处理。
- 启动失败：提示人工处理，不删除用户数据。

## 禁止事项

- 不要上传或读取用户数据。
- 不要修改服务端配置。
- 不要删除本地历史记录、词库、设备绑定缓存。
- 不要把 README 当成唯一协议。
