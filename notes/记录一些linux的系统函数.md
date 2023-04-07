## 一、进程相关
**1.获取进程ID**


	#include	<sys/types.h>
	#include	<unistd.h>
	/*返回：调用者或其父进程的PID*/
	pid_t	getpid(void);
	pid_t	getppid(void);
描述：*每个进程都有一个唯一的正数（非零）进程ID（PID）。getpid函数返回调用进程的PID。getppid函数返回它的父进程的PID（创建调用进程的进程）。*
说明：getpid和getppid函数返回一个类型为pid_t的整数值，在Linux系统中pid_t在types.h中被定义为int。


**2.创建和终止进程**

	#include	<stdlib.h>
	/*该函数不返回*/
	void	exit(int status);
说明：exit函数以status退出状态来终止进程（另一种设置退出状态的方法是从主程序中返回一个整数值。）。



	#include	<sys/types.h>
	#include	<unistd.h>
	/*子进程返回0，父进程返回子进程的PID，如果出错，则返回-1*/
	pid_t	fork(void);
描述：*父进程通过调用fork函数创建一个新的运行的子进程。*
说明：子进程得到与父进程用户级虚拟地址空间相同的一份副本（但又是独立的），包括代码和数据段，堆，共享库以及用户栈。子进程还获得与父进程任何打开文件描述符相同的副本。父进程喝新建子进程最大的区别在于它们有不同的PID。



	#include	<sys/types.h>
	#include	<sys/wait.h>
	/*返回：如果成功，则为子进程的PID，如果WNOHANG，则为0，其他错误则为-1*/
	pid_t	waitpid(pid_t pid, int *statusp, int options);
描述：*一个进程可以通过调用waitpid函数来等待它的子进程终止或者停止。*
说明：==========待补充==========


	#include	<sys/types.h>
	#include	<sys/wait.h>
	/*返回：如果成功，则为子进程PID，如果出错，则为-1*/
	pid_t	wait(int* statusp);
描述：*wait函数是waitpid函数的简单版本。*
说明：调用wait(&status)等价于调用waitpid(-1,&status,0)。


**3.让进程休眠**

	#include	<unistd.h>
	/*返回：还要休眠的秒数*/
	unsigned	int	sleep(unsigned int secs);
描述：*sleep函数将一个进程挂起一段指定的时间。*
说明：如果请求的时间量已经到了，sleep返回0，否则返回还剩下的要休眠的秒数。

	#include	<unistd.h>
	/*总是返回1*/
	int	pause(void);
描述：*pause函数让调用的函数休眠，直到该进程收到一个信号*
==========待补充==========


**4.加载并运行程序**

	#include	<unistd.h>
	/*如果成功，则不返回，如果错误，则返回-1*/
	int	execve(const char* filename, const char* argv[], const char* envp[]);
描述：*execve函数在当前进程的上下文中加载并运行一个新程序。*
说明：execve函数加载并运行可执行目标文件filename，且带参数列表argv和环境变量列表envp。execve调用一次并且从不返回。



	#include	<stdlib.h>
	/*返回：若存在则为指向name的指针，若无匹配，则为NULL*/
	char*	getenv(const char* name);
	/*返回：无*/
	int	setenv(const char* name, const char* newvalue, int overwrite);
	/*返回：无*/
	void		unsetenv(const char* name);
描述：*Linux提供了几个函数来操作环境数组：*
说明：getenv函数在环境数组中搜索字符串“name=value”，如果找到了，它就返回一个指向value的指针，否则他就返回NULL。如果环境数组包含一个形如“name=oldvalue”的字符串，那么unsetenv会删除它，而setenv会用newvalue代替oldvalue，但是只有在overwrite非零时才会这样。如果name不存在，那么setenv就把“name=newvalue”添加到数组中。


**5.发送信号**

	#include	<unistd.h>
	/*返回：调用进程的进程组ID*/
	pid_t	getpgrp(void);
描述：*每个进程都只属于一个进程组，进程组是由一个正整数进程组ID来标识的。getpgrp函数返回当前进程的进程组ID。*


	#include	<unistd.h>
	/*返回：若成功则为0，错误则为-1*/
	int	setpgid(pid_t pid, pig_t pgid);
描述：*默认的，一个子进程和他的父进程属于一个进程组。一个进程可以通过使用setpgid函数来改变自己或者其他进程的进程组。*


	#include	<sys/types.h>
	#include	<signal.h>
	/*返回：若成功则为0，错误则为-1*/
	int	kill(pid_t pid, int sig);
描述：*进程通过调用kill函数发送信号给其他进程（包括它们自己）。*
==未完待续0x212==
## 二、系统级I/O
**1.打开和关闭文件**

	#include	<sys/types.h>
	#include	<sys/stat.h>
	#include	<fcntl.h>
	/*返回：若成功则为新文件描述符，若出错为-1*/
	int	open(char* filename, int flags, mode_t mode);
描述：*进程是通过调用open函数来打开一个已存在的文件或者创建一个新文件的。*
说明：
(1)open函数将filename转换为一个文件描述符，并且返回描述符数字，返回描述符总是在进程中当前没有打开的最小描述符。
(2)flag参数指明了进程打算如何访问这个文件：
- O_RDONLY表示只读；
- O_WRONLY表示只写；
- O_RDWR表示可读可写。

(3)flag参数可以提供一些额外的指示：
- O_CREAT表示如果文件不存在，就~~创建它的一个截断（空）的文件？？什么意思~~ ；
- O_TRUNC表示如果文件已经存在，就~~截断它？？什么意思~~ ；
- O_APPEND表示在每次操作前，设置文件位置到文件的结尾处。

`fd=open( "foo.txt", O_WRONLY|O_APPEND, 0);`表示打开一个已经存在的文件，并在后面添加一些数据。
(4)mode参数指定了新文件的访问权限：
- S_IRUSR表示只有拥有者能读这个文件；
- S_IWUSR表示只有拥有者能写这个文件；
- S_IXUSR表示只有拥有者能执行这个文件；
- S_IRGRP表示拥有者所在组的成员都能读这个文件；（拥有者所在组简称拥组）
- S_IWGRP表示拥有者所在组的成员都能写这个文件；
- S_IXGRP表示拥有者所在组的成员都能执行这个文件；
- S_IROTH表示任何人都能读这个文件；
- S_IWOTH表示任何人都能写这个文件；
- S_IXOTH表示任何人都能执行这个文件。

(5)作为上下文的一部分，每一个进程都有一个umask，它是通过调用umask函数来设置的。当进程通过带某个mode参数的open函数调用来==创建一个新文件==时，文件的访问权限被设置为mode&~umask。
`#define	DEF_MODE	S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTHS_IWOTH`拥有者能读，拥有者能写，拥组能读，拥组能写，所有人能读，所有人能写
`#defien	DEF_UMASK	S_IWGRP|S_IWOTH`拥组能写，任何人能够写
`umask(DEF_UMASK);`
`fd=open( "foo.txt", O_CREAT|O_TRUNC|O_WRONLY, DEF_MODE);`表示创建一个新文件，文件的拥有者有读写权限，而其他所有的用户都有读权限

	#include	<unistd.h>
	/*若成功则为0，出错则为-1*/
	int close(int fd);
描述：*进程通过调用close函数关闭一个打开的文件。*
说明：关闭一个已关闭的描述符会出错。

**2.读写文件**
	
	#include	<unistd.h>
	/*返回：若成功则为u读的字节数，若EOF则为0，若出错为-1*/
	ssize_t		read(int fd, void* buf, size_t n);
	/*返回：若成功则为写的字节数，若出错则为-1*/
	ssize_t		write(int fd, const void* buf, size_t n);
描述：*应用程序是通过调用read和write函数来执行输入和输出的。*
说明：
(1)read函数从描述符为fd的当前文件位置，复制最多n个字节到内存位置buf。返回值-1表示一个错误，而返回值0表示EOF（End Of File）。否则返回值表示的是实际传送的字节数量。
(2)write函数从内存位置buf复制至多n个字节到描述符fd的但钱文件位置。
(3)在x86-64系统种，size_t被定义为unsigned long，ssize_t被定义为long（有符号的大小）。这是因为出错时必须返回-1。

**3.读取文件元数据**

	#include	<unistd.h>
	#include	<sys/stat.h>
	/*返回：若成功则为0，出错则为-1*/
	int	stat(const char* filename, struct stat* buf);
	/*返回：若成功则为0，出错则为-1*/
	int	fstat(int fd, struct stat* buf);
	/*文件结构如下*/
	struct stat{
		dev_t				st_dev;		//Device
		ino_t				st_ino;		//inode
		/*S_ISREG这是一个普通文件吗？S_ISDIR这是一个目录文件吗？S_ISSOCK这是一个网络套接字吗？
		  这三个宏可以用来判断文件的类型
		  用法：if(S_ISREG(filename->st_mode) )*/
		mode_t				st_mode;	//Protection and file type
		nlinkt				st_nlink;	//Number of hard links链向此文件的连接数
		uid_t				st_uid;		//User ID of owner
		gid_t				st_gid;		//Group ID of owner
		dev_t				st_rdev;	//Device type (if inode device)
		off_t				st_size;	//Total size,in bytes=总大小,以字节为单位
		unsigned long		st_blksize;	//Block size for filesystem= I/O文件系统I/O的块大小
		unsigned long		st_blocks;	//Number of blocks allocated=文件所占块数
		time_t				st_atime;	//Time of last access=上一次被访问时间
		time_t				st_mtime;	//Time of last modification=上一次被修改时间
		time_t				st_ctime;	//Time of last change=上一次改变时间
	}
描述：*应用程序能够给通过调用stat和fstat函数，检索到关于文件的信息（又叫元数据）。*
说明：stat函数以一个文件名作为输入，并填写struct stat这个类型的结构体，里面有文件的具体信息。


**4.读取目录内容**

	#include	<sys/types.h>
	#include	<dirent.h>
	/*返回：若成功，则为处理的指针，出错则为NULL*/
	DIR*	opendir(const char* name);
描述：*应用程序可以用readdir系列函数来读取目录的内容。*
说明：函数opendir以路径名为参数，返回指向目录流（directory stream）的指针。流是对条目有序列表的抽象，在这里是指目录项的列表。

	#include	<dirent.h>
	/*返回：若成功，则为指向下一个目录项的指针，若没有更多目录项或出错，则为NULL*/
	struct dirent*	readdir(DIR* dirp);
	/*目录项的结构如下*/
	struct dirent{
		ino_t	d_ino;				//inode number
		char		d_name[256];	//Filename
	}
说明：每次对readdir的调用返回的都是指向流dirp中下一个目录项的指针，或者，如果没有更多目录项则返回NULL。


	#include	<dirent.h>
	/*返回：成功为0，错误为-1*/
	int	closedir(DIR* dirp);
描述：*函数closedir关闭流并释放其所有的资源*


**5.I/O重定向**

	#include	<unistd.h>
	/*返回：若成功则为非负的描述符，若出错则为-1*/
	int	dup2(int oldfd, int newfd);
描述：*使用dup2函数进行重定向*
说明：dup2复制描述符表表项oldfd到描述符表表项newfd，覆盖描述符表表项newfd以前的内容。如果newfd已经打开，dup2会在复制oldfd之前关闭newfd。
==注：系统函数使用起来虽然简单便捷，但是频繁的调用系统函数，会导致操作系统频繁的陷入内核状态，最终会影响效率。==
## 三、网络编程
**1.IP地址**

	/*ip地址的结构体，仅代表ipv4*/
	struct in_addr{
		uint32_t	s_addr;
	}
描述：*网络程序将ip地址存放在ip地址的结构体中。*
说明：
(1)一个ip地址就是一个32位无符号整数。例如128.2.194.242就是地址0x8002c2f2的点分十进制表示，二进制表示为10000000000000101100001011110010，也就是10000000(128).00000010(2).11000010(194).11110010(242)。
(2)在ip地址结构中存放的地址总是以（大端法）网络字节顺序存放的，即使主机字节顺序是小端法。

**2.IP格式相关**

	#include <arpa/inet.h>
	/*返回：按照网络字节顺序的值*/
	uint32_t	htonl(uint32_t hostlong);//32主机字节->网络字节
	uint16_t	htons(uint16_t hostshort);//16主机字节->网络字节
	/*返回：按照主机字节顺序的值*/
	uint32_t	ntohl(uint32_t netlong);//32网络字节->主机字节
	uint16_t	ntohs(uint16_t netshort);//16网络字节->主机字节
描述：*Unix提供了在网络和主机字节顺序间转换的函数。*
说明：
(1)htonl函数将32位整数由主机字节顺序转换位网络字节顺序
(2)htons函数将16位整数由主机字节顺序转换位网络字节顺序
(3)ntohl函数将32位整数从网络字节顺序转换为主机字节。
(4)ntohs函数将16位整数从网络字节顺序转换为主机字节。

**3.IP地址的转换**

	#include <arpa/inet.h>
	/*返回：成功返回1，若src为非法淀粉十进制地址则为0，若出错则为-1*/
	int inet_pton(AF_INET, const char* src, void* dst);//十进制串->二进制ip
	/*返回：若成功则指向点分十进制字符串的指针，若出错则为NULL*/
	const char* inet_ntop(AF_INET, const void* src, char* dst socklen_t size);//二进制ip->十进制串
描述：*应用程序使用inet_pton和inet_ntop函数来实现ip地址和点分十进制串之前的转换*
说明：
(1)inet_pton函数将一个点分十进制串转换为一个二进制的网络字节顺序的ip地址；
(2)inet_ntop函数将一个二进制的网络字节顺序的ip地址转换为它所对应的点分十进制表示；
(3)32位的IPv4地址：AF_INET，128位的IPv6地址：AF_INET6。（AF 是“Address Family”的简写，INET是“Inetnet”的简写）
	
**4.套接字地址结构**

	/*ip套接字地址结构*/
	struct sockaddr_in{
		uint16_t			sin_family;//对应的协议族，成员是AF_INET（IPv4）
		uint16_t			sin_port;//一个16位的端口（大端法）
		struct		in_addr	sin_addr;//一个32位的 ip地址（大端法）
		unsigned char		sin_zero[8];//填充大小
	}
	/*一般的套接字地址结构*/
	struct sockaddr{
		uint16_t		sa_family;//协议族
		char			sa_data[14];//地址数据
	}
描述：*从linux内核的角度来看，一个套接字就是通信的一个端点。从linux程序的角度来看，套接字就是一个有相应描述符的打开文件。*
说明：	_in后缀是internet的缩写，sockaddr_in表示互联网套接字。
	
**5.socket函数**

	#include	<sys/types.h>
	#include	<sys/socket.h>
	/*返回：成功则为非负描述符，出错则为-1*/
	int	socket(int domain, int type, int protocol);
描述：*客户端和服务端使用socket函数来创建一个套接字描述符。*
说明：
(1)domain是 IP 地址类型，常用的有 AF_INET （IPv4）和 AF_INET6（IPv6）。
(2)type 为数据传输方式/套接字类型，常用的有 SOCK_STREAM（流格式套接字/面向连接的套接字） 和 SOCK_DGRAM（数据报套接字/无连接的套接字）。
(3)protocol 表示传输协议，常用的有 IPPROTO_TCP 和 IPPTOTO_UDP，分别表示 TCP 传输协议和 UDP 传输协议。
(4)不过也可以用后续的getaddrinfo函数来自动生成这些参数，这样代码就与协议无关了。
(5)socket返回的描述符仅是不分打开的，还不能用于读写。如何完成打开套接字的工作，取决于我们是客户端还是服务端。

**6.connect函数**

	#include	<sys/socket.h>
	/*返回：成功则为0，出错则为-1*/
	int	connect(int clientfd, const struct sockaddr* addr, socklen_t addrlen);
描述：*客户端通过调用connect函数来建立和服务端的连接。*
说明：
(1)connect函数试图与套接字地址为addr的服务器建立一个连接，其中addrlen是sizeof(sockaddr_in)。connect函数会阻塞，一直到连接成功或者发生错误，如果成功，clientfd描述符现在就可以读写了，并且得到的连接是由套接字对（客户端ip地址：客户端临时ip，addr->sin_addr:addr->sin_port）。
(2)对于socket，最好的方法是用getaddrinfo来为connect提供参数。

**7.bind函数**

	#include	<sys/socket.h>
	/*返回：成功则为0，出错则为-1*/
	int	bind(int sockfd, const struct sockaddr* addr, socklen_t addrlen);
描述：*服务器用bind函数，listen函数和accept函数来和客户端建立连接。*
说明：bind告诉内核将addr中的==服务器套接字地址==和==套接字描述符sockfd==联系起来。
	
**8.listen函数**

	#include	<sys/socket.h>
	/*返回：成功则为0，出错则为-1*/
	int	listen(int sockfd, int backlog);
描述：*服务器调用listen函数告诉内核，描述符是被服务器而不是客户端使用的。*
说明：
(1)listen函数将sockfd从一个主动套接字转化为一个监听套接字，监听套接字可以接收来自客户端的连接请求；
(2)backlog参数暗示了内核在开始拒绝连接请求之前，队列中要排队的未完成的请求连接的数量。通常可以把他设置为一个较大的值（1024）。


**9.accept函数**

	#include	<sys/socket.h>
	/*返回：成功则为非负连接描述符，出错则为-1*/
	int	accept(int listenfd, struct sockaddr* addr, int* addrlen);
描述：*服务器通过调用accept函数来等待来自客户端的连接请求。*
说明：
(1)accept函数等待来自客户端的连接请求==到达==监听描述符listenfd，然后在addr填写客户端的套接字地址，并==返回一个已经连接的描述符==，这个描述符可以利用UnixI/O函数与客户端通信；
(2)监听描述符是客户端作为请求连接的一个端点，它通常被创建一次，并存在于服务器的整个生命周期；
(3)已连接描述符是客户端和服务端之间已经建立起来了的一个连接的端点。服务器每次接受连接请求时都会创建一次，它只存在于服务器为一个客户端服务的过程中。
(4)监听描述符和已连接描述符的区分，使我们可以建立并发服务器。

**10主机和服务的转换**
	
	#include <sys/types.h>
	#include <sys/socket.h>
	#include <netdb.h>
	/*返回：成功则为0，错误则为非零的错误代码*/
	int	getaddrinfo(const char* host, const char* service, const struct addrinfo* hints, struct addrinfo** result);
	/*无返回*/
	void	freeaddrinfo(struct addrinfo* result);
	/*返回：错误消息*/
	const char*	gai_strerror(int errcode);
描述：*linux提供了一些强大的函数实现二进制套接字地址结构和主机名、之际地址、服务名和端口号的字符串表示之间的相互转化。*
说明：
(1)getaddrinfo函数将主机名、主机地址、服务名和端口号的字符串转化成套接字地址结构。和之前的那些函数不同，这个函数是可重入的（特点是它被多个线程调用时，不会引用任何共享数据），适用于任何协议。
(2)==这里先放放，待补充==

## 四、并发编程
**1.创建线程**

	#include <pthread.h>
	typedef void* (func)(void *);
	/*返回：成功返回0，出错则返回非0*/
	int	pthread_create(pthread_t* tid, pthread_attr_t* attr, func* f, void* arg);
描述：*线程通过调用pthread_create函数来创建其他线程。*
说明：当pthread_create返回时，参数tid包含新创建线程的ID。

	#include <pthread.h>
	/*返回：调用者的线程ID*/
	pthread_t	pthread_self(void);
描述：*新线程可以通过调用pthread_self函数来获得它自己的线程ID*

**2.终止线程**

	#include <pthread.h>
	/*返回：从不返回*/
	void	pthread_exit(void* thread_return);
	/*放回：成功返回0，出错则返回非0*/
	int	pthread_cancel(pthread_t tid);
描述：*通过调用pthread_exit函数，线程会显示地终止。*
说明：一个线程是以下列方式之一来终止的：
(1)当顶层的线程例程返回时，线程会==隐式地终止==；
(2)调用pthread_exit会==显式地终止==。如果主线程调用pthread_exit，它会等待所有其他线程终止，然后再终止主线程和整个进程，返回值为thread_return。
(3)某个对等线程调用linux的exit函数，该函数终止进程以及所有与该进程相关的线程。
(4)另一个对等线程通过以当前线程ID作为参数调用pthread_cancel函数来终止当前线程。

**3.回收已终止线程的资源**

	#include <pthread.h>
	/*返回：成功则返回0，出错则返回非0*/
	int	pthread_join(pthread_t tid, void** thread_return);
描述：*线程通过调用pthread_join函数等待其他线程终止。*
说明：pthread_join会阻塞，直到线程tid终止，将线程例程返回的通用（void*）指针赋值为thread_return指向的位置，然后回收已终止线程占用的所有内存资源。只能等待一个指定的线程终止。

**4.分离线程**

	#include <pthread.h>
	/**返回：若成功则返回0，出错则为非0/
	int	pthread_detach(pthread_t tid);
描述：**
说明：==待补充==

**5.初始化线程**

	#include <pthread.h>
	pthread_once_t once_control = PTHREAD_ONCE_INIT;
	/*返回：总是返回0*/
	int	pthread_once(pthread_once_t* once_control, void (*init_routine)(void));
描述：*pthread_once函数允许你初始化与线程例程相关的状态。*
说明：==待补充==

**6.信号量**

	#include <semaphore.h>
	/*返回：若成功则为0，出错则为-1*/
	int	sem_init(sem_t* sem,0,unsigned int value);
	int	sem_wait(sem_t* s);//P(s)
	int	sem_post(sem_t* s);//V(s)
描述：*Posix标准定义了许多操作信号量的函数。*
说明：
(1)sem_init函数将信号量sem初始化为value。每个信号量在使用前必须初始化。程序分别通过调用sem_wait和sem_post函数来执行P操作和V操作；
(2)P(s)：如果s是非0的，那么将s减去1，并且立即返回。如果s为0，那么挂机这个线程，直到s变为非0。而一个V操作会重启这个线程。重启之后，P操作将s减1，并将控制返回调用者；
(3)V(s)：V操作将s加上1.如果有任何线程阻塞在P操作等待s变成非0，那么V操作会作为重启这些线程中的一个，然后该线程将s减去1，完成它的P操作；
(4)P操作和V操作具有原子性（一气呵成，不可分割，不能有中断）。