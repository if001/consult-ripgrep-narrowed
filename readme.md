# readme

Two-step narrowing search with [ripgrep](https://github.com/BurntSushi/ripgrep) and [Consult](https://github.com/minad/consult) for Emacs.

You will be prompted:

- First keyword (A): Used to collect files (rg -l A)
- Second keyword (B): Used to search interactively within those files
- Directory: Root directory for the search

This behaves similarly to consult-ripgrep, but restricted to files matching keyword A


このパッケージは、`ripgrep` と `consult` を利用して、2段階の絞り込み検索を実現します。
1. キーワードA：まずこのキーワードで ripgrep -l を使って、マッチするファイルだけを絞り込みます。
2. キーワードB：絞り込まれたファイルの中から、このキーワードで再検索します。
3. ディレクトリ：検索を開始するルートディレクトリを指定します。

---

## 🔧 Requirements

- Emacs 30.1
- [`consult`](https://github.com/minad/consult)
- [ripgrep CLI](https://github.com/BurntSushi/ripgrep) (`rg` must be in your `$PATH`)

---

## 📦 Installation

Clone this repository and load it via `use-package` or `load-file`.

### Example (with use-package)

```elisp
(use-package consult-ripgrep-narrowed
  :load-path "~/path/to/consult-ripgrep-narrowed"
  :commands (consult-ripgrep-narrowed))
