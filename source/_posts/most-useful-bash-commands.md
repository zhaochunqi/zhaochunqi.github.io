title: 实用 Linux 命令
date: 2015-02-26 02:47:38
tags: [linux,mac,terminal,]
---

介绍几个常用的 Linux 命令行技巧命令，以期提高工作效率。

<!--more-->

1. `$ sudo !!`

	以root用户来运行上一次的命令。【“!!”获取上一次运行的命令】

2. `$ python -m SimpleHTTPServer`

	将当前的目录树挂载到http://$HOSTNAME:8000/ 

3. `$ ^foo^bar`

	运行上一次的命令但是将 foo 替换为 bar

4. `$ <space>command`

	执行命令，但不在history中记录，可用来hack。

5. `$ ctrl-x e`

	迅速打开一个编辑器，用来写复杂的命令。按住`ctrl`然后分别按x，e

6. `$ 'ALT+.' or '<ESC> .'`

	把最近使用的命令放到终端。（我自己使用的）`ALT+.`不成功。

7. `$ curl ifconfig.me`

	获取到外网IP地址

	`curl ifconfig.me/ip -> IP Adress`

	`curl ifconfig.me/host -> Remote Host`

	`curl ifconfig.me/ua ->User Agen`t

	`curl ifconfig.me/port -> Port`

	`thanks to http://ifconfig.me/`


8. `$ time read (ctrl-d to stop) `

	一个非常简单的停表，输入任何按键停止。

9. `$ ssh -t reachable_host ssh unreachable_host`

	通过中间主机建立SSH联系。
	unreachable 主机不能通过本地直接连接，但可以通过reachable主机连接，这个命令为 unreachable 主机通过隐藏连接连接到   reachable 主机