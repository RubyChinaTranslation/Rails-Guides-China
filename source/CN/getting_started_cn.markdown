## Rails 初上手指南

這份文件涵蓋了如何上手使用 Ruby on Rails。閱讀之後您應該可以熟悉：

* 安裝 Rails，建立一個新的 Rails 應用程式，並連結到資料庫
* Rails 的架構
* MVC (Model, View Controller) 基本原理以及 RESTful 設計
* 如何快速產生可以運作的 Rails 應用程式

endprologue.



WARNING. This Guide is based on Rails 3.1. Some of the code shown here will not
work in earlier versions of Rails.

WARNING: The Edge version of this guide is currently being re-worked. Please excuse us while we re-arrange the place.

### 前提條件

這份指南的目標是為了幫助初學者從頭開始學習 Rails 應用程式，而不需要有任何 Rails 經驗。不過要能夠讀的懂，還是需要一些前提：
This guide is designed for beginners who want to get started with a Rails
application from scratch. It does not assume that you have any prior experience
with Rails. However, to get the most out of it, you need to have some
prerequisites installed:

* The "Ruby":http://www.ruby-lang.org/en/downloads language version 1.8.7 or higher
#### 前提條件
To install Rails, use the +gem install+ command provided by RubyGems:

<shell>
# gem install rails
</shell>

TIP. If you're working on Windows, you can quickly install Ruby and Rails with "Rails Installer":http://railsinstaller.org.

To verify that you have everything installed correctly, you should be able to run the following:

<shell>
$ rails --version
</shell>

If it says something like "Rails 3.2.2" you are ready to continue.

