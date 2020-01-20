#!/bin/bash
function start(){
	echo "------------------------"
	echo "*    服务器优化工具    *"
	echo "------------------------"
	echo "1.常规安全设置请输入'1'"
	echo "2.常规依赖包安装请输入'2'"
	echo "3.常规环境包安装请输入'3'"
	echo "4.疑难问题解决请输入'4'"
	echo "5.退出请输入'0'"
	echo "------------------------"
	read -p "请输入数字：" num
	case $num in
		1)
			security
		;;
		2)
			dependency
		;;
		3)
			environment
		;;
		4)
			problem
		;;
	esac
}
function security(){
	echo "------------------------"
	echo "*      常规安全设置    *"
	echo "------------------------"
	echo "1.开启防火墙'1'"
	echo "2.关闭防火墙'2'"
	echo "3.重启防火墙'3'"
	echo "4.查看防火墙'4'"
	echo "5.开启SElinux'5'"
	echo "6.关闭SElinux'6'"
	echo "7.开启端口'7'"
	echo "8.关闭端口'8'"
	echo "9.查看已开放端口列表'9'"
	echo "*.退出'0'"
	echo "*.返回上一页'p'"
	echo "------------------------"
	
	function startFirewill(){
		echo "------开启防火墙------"
		systemctl start firewalld
	}
	function stopFirewill(){
		echo "------关闭防火墙------"
		systemctl stop firewalld
		systemctl disable firewalld
	}
	function restartFirewill(){
		echo "------重启防火墙------"
		service firewalld restart
	}
	function lookFirewill(){
		echo "------查看防火墙------"
		systemctl status firewalld
	}
	function startSElinu(){
		echo "------开启SElinux------"
		sed -i '/SELINUX/s/disabled/enforcing/' /etc/selinux/config
		echo "开启成功，请重新启动服务器"
	}
	function stopSElinux(){
		echo "------关闭SElinux------"
		sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
		echo "关闭成功，请重新启动服务器"
	}
	function startPort(){
		echo "------开启Tcp端口------"
		read -p "请输入您要开通的端口号，每个端口必须以分号结尾,'示例：8001;':" startPortNum
		i=1
		while((1==1))
		do
				split=`echo $startPortNum|cut -d ";" -f$i`
				if [[ "$split" != "" ]]
				then
					((i++))
					firewall-cmd --zone=public --add-port=$split/tcp --permanent
					firewall-cmd --reload
					echo "已开通$split/tcp端口"
				else
					break
				fi
		done
	}
	function stopPort(){
		echo "------关闭Tcp端口------"
		read -p "请输入您要关闭的端口号，每个必须以分号结尾,'示例：8001;':" stopPortNum2
		y=1
		while((1==1))
		do
			split2=`echo $stopPortNum2|cut -d ";" -f$y`
			if [[ "$split2" != "" ]]
			then
				((y++))
				firewall-cmd --zone=public --remove-port=$split2/tcp --permanent
				firewall-cmd --reload
				echo "已关闭$split2/tcp端口"
			else 
				break
			fi
		done
	}
	function lookPort(){
		echo "------查看已开放端口------"
		firewall-cmd --zone=public --list-ports
	}
	read -p "请输入数字：" num2
	case $num2 in
		1)
			startFirewill
		;;
		2)
			stopFirewill
		;;
		3)
			restartFirewill
		;;
		4)
			lookFirewill
		;;
		5)
			startSElinu
		;;
		6)
			stopSElinux
		;;
		7)
			startPort
		;;
		8)
			stopPort
		;;
		9)
			lookPort
		;;
		p)
			start
		;;
	esac
}
function dependency(){
	echo "------------------------"
	echo "*     常规依赖包安装   *"
	echo "------------------------"
	echo "1.安装基础常用命令'1'"
	echo "*.退出'0'"
	echo "*.返回上一页'p'"
	echo "------------------------"
	
	function OftenDos(){
	yum install wget net-tools screen lsof tcpdump nc mtr openssl-devel vim bash-completion lrzsz nmap telnet tree zip unzip
	echo "-------------------------------------------------------------------------------------------------------------------"
	echo "已安装wget|net-tools|screen|lsof|tcpdump|nc|mtr|openssl-devel|vim|bash-completion|lrzsz|nmap|telnet|tree|zip|unzip|"
	echo "-------------------------------------------------------------------------------------------------------------------"
	}
	read -p "请输入数字：" num3
	case $num3 in
	1)
		OftenDos
	;;
	p)
		start
	;;
	esac
}

function environment(){
	echo "------------------------"
	echo "*     常规环境包安装   *"
	echo "------------------------"
	echo "1.安装java'1'"
	echo "2.安装tomcat'2'"
	echo "3.安装nginx'3'"
	echo "4.安装mysql'4'"
	echo "*.退出'0'"
	echo "*.返回上一页'p'"
	echo "------------------------"
	
	function java(){
		echo "java还未开放"
	}
	
	function tomcat(){
		main_path=/usr/local/tomcat
		install_name=apache-tomcat-9.0.30.tar.gz
		env_fun()
		{
		echo "---检测本机环境----"
		username=`ps -ef|grep apache-tomcat |grep -v grep`
		if [[ -z $username ]]; then
			echo "tomcat不存在"
			return 10
		else
			echo "tomcat存在"
			return 12
		fi
		}
		install_fun(){
		echo "建立tomcat文件夹"
		mkdir -p $main_path
		cd $main_path
		echo "正在下载。请稍等..."
		wget https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz
		echo "正在解压，请稍等..."
		tar -zxvf $install_name
		echo "安装完成"
		rm $main_path/apache-tomcat-9.0.30.tar.gz
		echo "rm tar packet over"
		cd apache-tomcat-9.0.30/bin
		sh startup.sh
		firewall-cmd --zone=public --add-port=8080/tcp --permanent
		firewall-cmd --reload
		}
		main(){
		echo "***安装tomcat***"
		sleep 1
		env_fun
		re=$?
		if [ 10 -eq $re ] ;then
			install_fun
		else
			echo "tomcat已存在，不需要安装"
		fi
		}
		main
		exit 0
	}
	
	function nginx(){
	echo "nginx还未开放"
	}
	
	function mysql(){
	echo "nginx还未开放"
	}
	
	read -p "请输入数字：" num4
	case $num4 in
	1)
		java
	;;
	2)
		tomcat
	;;
	3)
		nginx
	;;
	4)
		mysql
	;;
	p)
		start
	;;
	esac
}

function problem(){
	echo "-------------------------------------------------"
	echo "*               linux疑难问题解决               *"
	echo "-------------------------------------------------"
	echo "1.解决更换yum源显示wget: 无法解析主机地址？'1'"
	echo "2.解决使用ipaddr无法找到IPv4地址？'2'"
	echo "3.解决centos中文显示乱码？'3'"
	echo "*.退出'0'"
	echo "*.返回上一页'p'"
	echo "-------------------------------------------------"
	
	function DNS(){
		echo 'nameserver 223.5.5.5'>>/etc/resolv.conf 
	}
	
	function ifconfig(){
		sed -i 's|onboot=no|onboot=yes|' /etc/sysconfig/network-scripts/ifcfg-ens33
		service network start 
	}
	
	function zh_CN(){
		yum list kde*chinese
		yum install kde-l10n-Chinese.noarch
		if [ ! -f "/etc/sysconfig/i18n" ];then
			touch /etc/sysconfig/i18n
			echo 'LANG="zh_CN.UTF-8"'>>/etc/sysconfig/i18n
			echo 'LC_ALL="zh_CN.UTF-8"'>>/etc/sysconfig/i18n
		else
			sed -i '/LANG="zh_CN.UTF-8/d' /etc/sysconfig/i18n
			sed -i '/LC_ALL="zh_CN.UTF-8/d' /etc/sysconfig/i18n
			echo 'LANG="zh_CN.UTF-8"'>>/etc/sysconfig/i18n
			echo 'LC_ALL="zh_CN.UTF-8"'>>/etc/sysconfig/i18n
		fi
		sed -i '/LANG="zh_CN.UTF-8/d' /etc/locale.conf
		echo 'LANG="zh_CN.UTF-8"'>>/etc/locale.conf
		source /etc/locale.conf
		source /etc/sysconfig/i18n
	}
	
	read -p "请输入数字：" num5
	case $num5 in
	1)
		DNS
	;;
	2)
		ifconfig
	;;
	3)
		zh_CN
	;;
	p)
		start
	;;
esac
}


case $1 in
	start)
		start
	;;
esac




