#米浩东 1551867
#极品飞车游戏的mips程序
.text
GameStart:#游戏开始的准备工作
	InitGraphRam:#显存初始化
 
GameReady:
	InitGameData:#初始化游戏数据
		addi $s0,$zero,300#user_posx
		addi $s1,$zero,200#user_posy
		addi $s2,$zero,10#enemy1_posx
		addi $s3,$zero,10#enemy1_posy
		addi $s4,$zero,0#road_margin
		addi $s5,$zero,0x00#button_input
		addi $s6,$zero,0x00000000#game_state
		addi $s7,$zero,0#score 
		addi $t8,$zero,0#mvoe_speed
	WaitStartPress:#准备游戏开始
		lw $s5,0x10010010($zero) #从按钮读入输入
		andi $t1,$s5,0x000000002#判断开始键是否按下
		beq $zero,$t1,WaitStartPress#如果没按下继续等待按下
		addi $s6,$zero,	0x00000001 #游戏状态改变
GameLoop:#进入游戏的循环
	addi $k0,$zero,81500#设置一个延时，这个常数越大，速度越慢
	DelaySpeed:#通过这里的耗时控制游戏速度
		addi $k0,$k0,-1
		bne $k0,$zero,DelaySpeed
	AutoChgPos:#自动变换车、背景的坐标
		lw $t8,0x10010030($zero)#从开关读入速度
		add $s3,$s3,$t8
		JudgingAutoBorder:#判断自动边界
			addi $t1,$s3,-477
			bgez $t1,AdjustEnemy1Y
			beq $zero,$zero,FiAE1Y
		AdjustEnemy1Y:#如果从下面消失
			addi $s3,$zero,-300 #需要从上面出现
			add  $t1,$s4,$s0    #x位置随机产生，产生种子为Road_Margin、User_Posx
			add  $t1,$t1,$s1
			addi $t2,$zero,550
			div  $t1,$t2   
			mfhi $t1
			add  $s2,$zero,$t1#这样就随机产生了新的x坐标
		FiAE1Y:	
			addi $t1,$s1,-320
			sub  $t1,$zero,$t1
			bgez $t1,UserFall
			beq $zero,$zero,RoadMove
		UserFall:
			add $s1,$s1,$t8
		RoadMove:#背景自己动
			add $s7,$s7,$t8
			add $s4,$s4,$t8
			addi $t1,$s4,-240
			bgez $t1,AdjustRoadMargin
			beq $zero,$zero,UserChgPos
		AdjustRoadMargin:
			addi $s4,$zero,0
			#结束判断边界
	UserChgPos:#玩家改变车的位置
		ReadInput:#读取玩家输入
			lw $s5,0x10010010($zero) #从按钮读入输入
			andi $t1,$s5,0x00000007#判断是否有键按下
			beq $zero,$t1,CollisionJudge#如果没按下跳过
		TryLeftMove:
			addi $t1,$s0,-5
			bgez $t1,LeftMove
			beq $zero,$zero,TryRightMove
		LeftMove:
			andi $t1,$s5,0x00000004
			beq $zero,$t1,TryRightMove
			sub $s0,$s0,$t8
		TryRightMove:
			addi $t1,$s0,-550
			bgez $t1,TryUpmove
		RightMove:
			andi $t1,$s5,0x00000001
			beq $zero,$t1,TryUpmove
			add $s0,$s0,$t8		
		TryUpmove:
			addi $t1,$s1,-6
			bgez $t1,Upmove
			beq $zero,$zero,CollisionJudge		
		Upmove:
			andi $t1,$s5,0x00000002
			beq $zero,$t1,CollisionJudge
			sub $s1,$s1,$t8
			sub $s1,$s1,$t8
	CollisionJudge:#判断是否相撞	
		LUCOLLISION:#左上撞击检测
			LUCON1:#LU撞击第一个条件
				sub $t0,$s2,$s0
				bgez $t0,LDCOLLISION
			LUCON2:#LU撞击第二个条件
				addi $t1,$s2,90
				sub $t0,$s0,$t1
				bgez $t0,LDCOLLISION
			LUCON3:#LU撞击第三个条件
				sub $t0,$s3,$s1
				bgez $t0,LDCOLLISION
			LUCON4:#LU撞击第四个条件
				addi $t1,$s3,160
				sub $t0,$s1,$t1
				bgez $t0,LDCOLLISION
				beq $zero,$zero,HasCollision
		LDCOLLISION:
			LDCON1:#LD撞击第一个条件
				sub $t0,$s2,$s0
				bgez $t0,RUCOLLISION
			LDCON2:#LD撞击第二个条件
				addi $t1,$s2,90
				sub $t0,$s0,$t1
				bgez $t0,RUCOLLISION
			LDCON3:#LD撞击第三个条件
				sub $t0,$s1,$s3
				bgez $t0,RUCOLLISION
			LDCON4:#LD撞击第四个条件
				addi $t1,$s1,160
				sub $t0,$s3,$t1
				bgez $t0,RUCOLLISION
				beq $zero,$zero,HasCollision
		RUCOLLISION:
			RUCON1:#RU撞击第一个条件
				addi $t1,$s0,90
				sub $t0,$s2,$t1
				bgez $t0,RDCOLLISION
			RUCON2:#RU撞击第二个条件
				sub $t0,$s0,$s2
				bgez $t0,RDCOLLISION
			RUCON3:#RU撞击第三个条件
				sub $t0,$s3,$s1
				bgez $t0,RDCOLLISION
			RUCON4:#RU撞击第四个条件
				addi $t1,$s3,160
				sub $t0,$s1,$t1
				bgez $t0,RDCOLLISION
				beq $zero,$zero,HasCollision
		RDCOLLISION:
			RDCON1:#RD撞击第一个条件
				addi $t1,$s0,90
				sub $t0,$s2,$t1
				bgez $t0,OutputVGA1
			RDCON2:#RD撞击第二个条件
				sub $t0,$s0,$s2
				bgez $t0,OutputVGA1
			RDCON3:#RD撞击第三个条件
				sub $t0,$s1,$s3
				bgez $t0,OutputVGA1
			RDCON4:#RD撞击第四个条件
				addi $t1,$s1,160
				sub $t0,$s3,$t1
				bgez $t0,OutputVGA1
				beq $zero,$zero,HasCollision
	OutputVGA1:#向VGA模块送去游戏状态、三辆车和背景图的坐标
		sw $s7,0x10010020($zero)#显示得分
		#传送roadmargin
		addi $t1,$zero,0x80000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s4,17
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#传送enemy
		addi $t1,$zero,0x40000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s3,17
		sll $t2,$t2,4
		srl $t2,$t2,4
		or $t1,$t1,$t2
		sll $t2,$s2,6
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#传送user
		addi $t1,$zero,0x00000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s1,17
		or $t1,$t1,$t2
		sll $t2,$s0,6
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
	ContinueGameLoop:
		beq $zero,$zero,GameLoop
		

#EndOfGameLoop
HasCollision:#CollisionJudge中如果判断为相撞，跳转到这里
	OutputVGA2:#向VGA模块送去游戏状态、三辆车和背景图的坐标
		addi $s6,$zero,2#设置游戏状态为撞击
		#传送roadmargin
		addi $t1,$zero,0x80000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s4,17
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#传送enemy
		addi $t1,$zero,0x40000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s3,17
		sll $t2,$t2,4
		srl $t2,$t2,4
		or $t1,$t1,$t2
		sll $t2,$s2,6
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#传送user
		addi $t1,$zero,0x00000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s1,17
		or $t1,$t1,$t2
		sll $t2,$s0,6
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#sw $s7,0x10010020($zero)#显示得分
	addi $k0,$zero,50000000#设置一个延时，这个常数越大，速度越慢
	DelayToEnd:#通过这里的耗时控制游戏速度
		addi $k0,$k0,-1
		bne $k0,$zero,DelayToEnd
EndGame:#游戏结束做的工作
	addi $s6,$zero,3#游戏状态变成over
	OutputVGA3:#向VGA模块送去游戏结束的信号
		addi $t1,$zero,0x30000000
		sw $t1,0x10010000($zero)
	WaitRestartPress:#准备游戏开始
		lw $s5,0x10010010($zero) #从按钮读入输入
		andi $t1,$s5,0x000000008#判断重新开始键是否按下
		beq $zero,$t1,WaitRestartPress#如果没按下继续等待按下
	GameReStart:#跳转到GameReady
		addi $s6,$zero,0#游戏状态变成准备
		addi $t1,$zero,0x00000000
		sw $t1,0x10010000($zero)
		beq $zero,$zero,GameReady
	





