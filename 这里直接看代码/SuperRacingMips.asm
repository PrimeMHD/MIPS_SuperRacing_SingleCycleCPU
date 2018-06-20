#�׺ƶ� 1551867
#��Ʒ�ɳ���Ϸ��mips����
.text
GameStart:#��Ϸ��ʼ��׼������
	InitGraphRam:#�Դ��ʼ��
 
GameReady:
	InitGameData:#��ʼ����Ϸ����
		addi $s0,$zero,300#user_posx
		addi $s1,$zero,200#user_posy
		addi $s2,$zero,10#enemy1_posx
		addi $s3,$zero,10#enemy1_posy
		addi $s4,$zero,0#road_margin
		addi $s5,$zero,0x00#button_input
		addi $s6,$zero,0x00000000#game_state
		addi $s7,$zero,0#score 
		addi $t8,$zero,0#mvoe_speed
	WaitStartPress:#׼����Ϸ��ʼ
		lw $s5,0x10010010($zero) #�Ӱ�ť��������
		andi $t1,$s5,0x000000002#�жϿ�ʼ���Ƿ���
		beq $zero,$t1,WaitStartPress#���û���¼����ȴ�����
		addi $s6,$zero,	0x00000001 #��Ϸ״̬�ı�
GameLoop:#������Ϸ��ѭ��
	addi $k0,$zero,81500#����һ����ʱ���������Խ���ٶ�Խ��
	DelaySpeed:#ͨ������ĺ�ʱ������Ϸ�ٶ�
		addi $k0,$k0,-1
		bne $k0,$zero,DelaySpeed
	AutoChgPos:#�Զ��任��������������
		lw $t8,0x10010030($zero)#�ӿ��ض����ٶ�
		add $s3,$s3,$t8
		JudgingAutoBorder:#�ж��Զ��߽�
			addi $t1,$s3,-477
			bgez $t1,AdjustEnemy1Y
			beq $zero,$zero,FiAE1Y
		AdjustEnemy1Y:#�����������ʧ
			addi $s3,$zero,-300 #��Ҫ���������
			add  $t1,$s4,$s0    #xλ�������������������ΪRoad_Margin��User_Posx
			add  $t1,$t1,$s1
			addi $t2,$zero,550
			div  $t1,$t2   
			mfhi $t1
			add  $s2,$zero,$t1#����������������µ�x����
		FiAE1Y:	
			addi $t1,$s1,-320
			sub  $t1,$zero,$t1
			bgez $t1,UserFall
			beq $zero,$zero,RoadMove
		UserFall:
			add $s1,$s1,$t8
		RoadMove:#�����Լ���
			add $s7,$s7,$t8
			add $s4,$s4,$t8
			addi $t1,$s4,-240
			bgez $t1,AdjustRoadMargin
			beq $zero,$zero,UserChgPos
		AdjustRoadMargin:
			addi $s4,$zero,0
			#�����жϱ߽�
	UserChgPos:#��Ҹı䳵��λ��
		ReadInput:#��ȡ�������
			lw $s5,0x10010010($zero) #�Ӱ�ť��������
			andi $t1,$s5,0x00000007#�ж��Ƿ��м�����
			beq $zero,$t1,CollisionJudge#���û��������
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
	CollisionJudge:#�ж��Ƿ���ײ	
		LUCOLLISION:#����ײ�����
			LUCON1:#LUײ����һ������
				sub $t0,$s2,$s0
				bgez $t0,LDCOLLISION
			LUCON2:#LUײ���ڶ�������
				addi $t1,$s2,90
				sub $t0,$s0,$t1
				bgez $t0,LDCOLLISION
			LUCON3:#LUײ������������
				sub $t0,$s3,$s1
				bgez $t0,LDCOLLISION
			LUCON4:#LUײ�����ĸ�����
				addi $t1,$s3,160
				sub $t0,$s1,$t1
				bgez $t0,LDCOLLISION
				beq $zero,$zero,HasCollision
		LDCOLLISION:
			LDCON1:#LDײ����һ������
				sub $t0,$s2,$s0
				bgez $t0,RUCOLLISION
			LDCON2:#LDײ���ڶ�������
				addi $t1,$s2,90
				sub $t0,$s0,$t1
				bgez $t0,RUCOLLISION
			LDCON3:#LDײ������������
				sub $t0,$s1,$s3
				bgez $t0,RUCOLLISION
			LDCON4:#LDײ�����ĸ�����
				addi $t1,$s1,160
				sub $t0,$s3,$t1
				bgez $t0,RUCOLLISION
				beq $zero,$zero,HasCollision
		RUCOLLISION:
			RUCON1:#RUײ����һ������
				addi $t1,$s0,90
				sub $t0,$s2,$t1
				bgez $t0,RDCOLLISION
			RUCON2:#RUײ���ڶ�������
				sub $t0,$s0,$s2
				bgez $t0,RDCOLLISION
			RUCON3:#RUײ������������
				sub $t0,$s3,$s1
				bgez $t0,RDCOLLISION
			RUCON4:#RUײ�����ĸ�����
				addi $t1,$s3,160
				sub $t0,$s1,$t1
				bgez $t0,RDCOLLISION
				beq $zero,$zero,HasCollision
		RDCOLLISION:
			RDCON1:#RDײ����һ������
				addi $t1,$s0,90
				sub $t0,$s2,$t1
				bgez $t0,OutputVGA1
			RDCON2:#RDײ���ڶ�������
				sub $t0,$s0,$s2
				bgez $t0,OutputVGA1
			RDCON3:#RDײ������������
				sub $t0,$s1,$s3
				bgez $t0,OutputVGA1
			RDCON4:#RDײ�����ĸ�����
				addi $t1,$s1,160
				sub $t0,$s3,$t1
				bgez $t0,OutputVGA1
				beq $zero,$zero,HasCollision
	OutputVGA1:#��VGAģ����ȥ��Ϸ״̬���������ͱ���ͼ������
		sw $s7,0x10010020($zero)#��ʾ�÷�
		#����roadmargin
		addi $t1,$zero,0x80000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s4,17
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#����enemy
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
		#����user
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
HasCollision:#CollisionJudge������ж�Ϊ��ײ����ת������
	OutputVGA2:#��VGAģ����ȥ��Ϸ״̬���������ͱ���ͼ������
		addi $s6,$zero,2#������Ϸ״̬Ϊײ��
		#����roadmargin
		addi $t1,$zero,0x80000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s4,17
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#����enemy
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
		#����user
		addi $t1,$zero,0x00000000
		sll $t2,$s6,28
		or $t1,$t1,$t2
		sll $t2,$s1,17
		or $t1,$t1,$t2
		sll $t2,$s0,6
		or $t1,$t1,$t2
		sw $t1,0x10010000($zero)
		#sw $s7,0x10010020($zero)#��ʾ�÷�
	addi $k0,$zero,50000000#����һ����ʱ���������Խ���ٶ�Խ��
	DelayToEnd:#ͨ������ĺ�ʱ������Ϸ�ٶ�
		addi $k0,$k0,-1
		bne $k0,$zero,DelayToEnd
EndGame:#��Ϸ�������Ĺ���
	addi $s6,$zero,3#��Ϸ״̬���over
	OutputVGA3:#��VGAģ����ȥ��Ϸ�������ź�
		addi $t1,$zero,0x30000000
		sw $t1,0x10010000($zero)
	WaitRestartPress:#׼����Ϸ��ʼ
		lw $s5,0x10010010($zero) #�Ӱ�ť��������
		andi $t1,$s5,0x000000008#�ж����¿�ʼ���Ƿ���
		beq $zero,$t1,WaitRestartPress#���û���¼����ȴ�����
	GameReStart:#��ת��GameReady
		addi $s6,$zero,0#��Ϸ״̬���׼��
		addi $t1,$zero,0x00000000
		sw $t1,0x10010000($zero)
		beq $zero,$zero,GameReady
	





