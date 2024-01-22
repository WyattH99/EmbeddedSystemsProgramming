	.cpu cortex-m4
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.global	current_task
	.data
	.type	current_task, %object
	.size	current_task, 1
current_task:
	.byte	1
	.global	global_tick_count
	.bss
	.align	2
	.type	global_tick_count, %object
	.size	global_tick_count, 4
global_tick_count:
	.space	4
	.global	user_tasks
	.align	2
	.type	user_tasks, %object
	.size	user_tasks, 80
user_tasks:
	.space	80
	.text
	.align	1
	.global	main
	.arch armv7e-m
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	enable_processor_faults
	ldr	r0, .L3
	bl	init_scheduler_stack
	bl	init_tasks_stack
	bl	led_init_all_
	mov	r0, #1000
	bl	init_systick_timer
	bl	switch_sp_to_psp
	bl	task1_handler
.L2:
	b	.L2
.L4:
	.align	2
.L3:
	.word	536996864
	.size	main, .-main
	.align	1
	.global	idle_task
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idle_task, %function
idle_task:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
.L6:
	b	.L6
	.size	idle_task, .-idle_task
	.align	1
	.global	task1_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task1_handler, %function
task1_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L8:
	movs	r0, #10
	bl	led_on
	mov	r0, #1000
	bl	task_delay
	movs	r0, #10
	bl	led_off
	mov	r0, #1000
	bl	task_delay
	b	.L8
	.size	task1_handler, .-task1_handler
	.align	1
	.global	task2_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task2_handler, %function
task2_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L10:
	movs	r0, #6
	bl	led_on
	mov	r0, #500
	bl	task_delay
	movs	r0, #6
	bl	led_off
	mov	r0, #500
	bl	task_delay
	b	.L10
	.size	task2_handler, .-task2_handler
	.align	1
	.global	task3_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task3_handler, %function
task3_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L12:
	movs	r0, #9
	bl	led_on
	movs	r0, #250
	bl	task_delay
	movs	r0, #9
	bl	led_off
	movs	r0, #250
	bl	task_delay
	b	.L12
	.size	task3_handler, .-task3_handler
	.align	1
	.global	task4_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task4_handler, %function
task4_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L14:
	movs	r0, #8
	bl	led_on
	movs	r0, #125
	bl	task_delay
	movs	r0, #8
	bl	led_off
	movs	r0, #125
	bl	task_delay
	b	.L14
	.size	task4_handler, .-task4_handler
	.align	1
	.global	init_systick_timer
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_systick_timer, %function
init_systick_timer:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #28
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, .L16
	str	r3, [r7, #20]
	ldr	r2, .L16+4
	ldr	r3, [r7, #4]
	udiv	r3, r2, r3
	subs	r3, r3, #1
	str	r3, [r7, #16]
	ldr	r3, [r7, #20]
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, [r7, #20]
	ldr	r2, [r3]
	ldr	r3, [r7, #16]
	orrs	r2, r2, r3
	ldr	r3, [r7, #20]
	str	r2, [r3]
	ldr	r3, .L16+8
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	ldr	r3, [r3]
	orr	r2, r3, #2
	ldr	r3, [r7, #12]
	str	r2, [r3]
	ldr	r3, [r7, #12]
	ldr	r3, [r3]
	orr	r2, r3, #4
	ldr	r3, [r7, #12]
	str	r2, [r3]
	ldr	r3, [r7, #12]
	ldr	r3, [r3]
	orr	r2, r3, #1
	ldr	r3, [r7, #12]
	str	r2, [r3]
	nop
	adds	r7, r7, #28
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L17:
	.align	2
.L16:
	.word	-536813548
	.word	16000000
	.word	-536813552
	.size	init_systick_timer, .-init_systick_timer
	.align	1
	.global	init_scheduler_stack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_scheduler_stack, %function
init_scheduler_stack:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	r3, r0
	.syntax unified
@ 185 "main.c" 1
	MSR MSP,r3
@ 0 "" 2
@ 186 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	init_scheduler_stack, .-init_scheduler_stack
	.align	1
	.global	init_tasks_stack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_tasks_stack, %function
init_tasks_stack:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #20
	add	r7, sp, #0
	movs	r3, #0
	str	r3, [r7, #12]
	b	.L20
.L21:
	ldr	r2, .L26
	ldr	r3, [r7, #12]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #0
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
.L20:
	ldr	r3, [r7, #12]
	cmp	r3, #4
	ble	.L21
	ldr	r3, .L26
	ldr	r2, .L26+4
	str	r2, [r3]
	ldr	r3, .L26
	ldr	r2, .L26+8
	str	r2, [r3, #16]
	ldr	r3, .L26
	ldr	r2, .L26+12
	str	r2, [r3, #32]
	ldr	r3, .L26
	ldr	r2, .L26+16
	str	r2, [r3, #48]
	ldr	r3, .L26
	ldr	r2, .L26+20
	str	r2, [r3, #64]
	ldr	r3, .L26
	ldr	r2, .L26+24
	str	r2, [r3, #12]
	ldr	r3, .L26
	ldr	r2, .L26+28
	str	r2, [r3, #28]
	ldr	r3, .L26
	ldr	r2, .L26+32
	str	r2, [r3, #44]
	ldr	r3, .L26
	ldr	r2, .L26+36
	str	r2, [r3, #60]
	ldr	r3, .L26
	ldr	r2, .L26+40
	str	r2, [r3, #76]
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L22
.L25:
	ldr	r2, .L26
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r3, [r3]
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	subs	r3, r3, #4
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	mov	r2, #16777216
	str	r2, [r3]
	ldr	r3, [r7, #8]
	subs	r3, r3, #4
	str	r3, [r7, #8]
	ldr	r2, .L26
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r3
	ldr	r3, [r7, #8]
	str	r2, [r3]
	ldr	r3, [r7, #8]
	subs	r3, r3, #4
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	mvn	r2, #2
	str	r2, [r3]
	movs	r3, #0
	str	r3, [r7]
	b	.L23
.L24:
	ldr	r3, [r7, #8]
	subs	r3, r3, #4
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, [r7]
	adds	r3, r3, #1
	str	r3, [r7]
.L23:
	ldr	r3, [r7]
	cmp	r3, #12
	ble	.L24
	ldr	r2, [r7, #8]
	ldr	r1, .L26
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r1
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L22:
	ldr	r3, [r7, #4]
	cmp	r3, #4
	ble	.L25
	nop
	nop
	adds	r7, r7, #20
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L27:
	.align	2
.L26:
	.word	user_tasks
	.word	536997888
	.word	537001984
	.word	537000960
	.word	536999936
	.word	536998912
	.word	idle_task
	.word	task1_handler
	.word	task2_handler
	.word	task3_handler
	.word	task4_handler
	.size	init_tasks_stack, .-init_tasks_stack
	.align	1
	.global	enable_processor_faults
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	enable_processor_faults, %function
enable_processor_faults:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L29
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #262144
	ldr	r3, [r7, #4]
	str	r2, [r3]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #131072
	ldr	r3, [r7, #4]
	str	r2, [r3]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #65536
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L30:
	.align	2
.L29:
	.word	-536810204
	.size	enable_processor_faults, .-enable_processor_faults
	.align	1
	.global	get_psp_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	get_psp_value, %function
get_psp_value:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L33
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L33+4
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r3, [r3]
	mov	r0, r3
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L34:
	.align	2
.L33:
	.word	current_task
	.word	user_tasks
	.size	get_psp_value, .-get_psp_value
	.align	1
	.global	switch_sp_to_psp
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	switch_sp_to_psp, %function
switch_sp_to_psp:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	.syntax unified
@ 258 "main.c" 1
	PUSH {LR}
@ 0 "" 2
@ 259 "main.c" 1
	BL get_psp_value
@ 0 "" 2
@ 260 "main.c" 1
	MSR PSP,R0
@ 0 "" 2
@ 261 "main.c" 1
	POP {LR}
@ 0 "" 2
@ 265 "main.c" 1
	MOV R0,#0x02
@ 0 "" 2
@ 266 "main.c" 1
	MSR CONTROL,R0
@ 0 "" 2
@ 268 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	switch_sp_to_psp, .-switch_sp_to_psp
	.align	1
	.global	save_psp_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	save_psp_value, %function
save_psp_value:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, .L37
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L37+4
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r2, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L38:
	.align	2
.L37:
	.word	current_task
	.word	user_tasks
	.size	save_psp_value, .-save_psp_value
	.align	1
	.global	update_next_task
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	update_next_task, %function
update_next_task:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #255
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [r7]
	b	.L40
.L43:
	ldr	r3, .L47
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r2, r3
	ldr	r3, .L47
	strb	r2, [r3]
	ldr	r3, .L47
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L47+4
	umull	r1, r3, r3, r2
	lsrs	r1, r3, #2
	mov	r3, r1
	lsls	r3, r3, #2
	add	r3, r3, r1
	subs	r3, r2, r3
	uxtb	r2, r3
	ldr	r3, .L47
	strb	r2, [r3]
	ldr	r3, .L47
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L47+8
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #0
	bne	.L41
	ldr	r3, .L47
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L45
.L41:
	ldr	r3, [r7]
	adds	r3, r3, #1
	str	r3, [r7]
.L40:
	ldr	r3, [r7]
	cmp	r3, #4
	ble	.L43
	b	.L42
.L45:
	nop
.L42:
	ldr	r3, [r7, #4]
	cmp	r3, #0
	beq	.L46
	ldr	r3, .L47
	movs	r2, #0
	strb	r2, [r3]
.L46:
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L48:
	.align	2
.L47:
	.word	current_task
	.word	-858993459
	.word	user_tasks
	.size	update_next_task, .-update_next_task
	.align	1
	.global	schedule
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	schedule, %function
schedule:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L50
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #268435456
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L51:
	.align	2
.L50:
	.word	-536810236
	.size	schedule, .-schedule
	.align	1
	.global	task_delay
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task_delay, %function
task_delay:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	.syntax unified
@ 308 "main.c" 1
	MOV R0,#0x01
@ 0 "" 2
@ 308 "main.c" 1
	MSR PRIMASK,R0
@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r3, .L54
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L53
	ldr	r3, .L54+4
	ldr	r2, [r3]
	ldr	r3, .L54
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r3
	ldr	r3, [r7, #4]
	add	r2, r2, r3
	ldr	r1, .L54+8
	lsls	r3, r0, #4
	add	r3, r3, r1
	adds	r3, r3, #4
	str	r2, [r3]
	ldr	r3, .L54
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L54+8
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #255
	strb	r2, [r3]
	bl	schedule
.L53:
	.syntax unified
@ 317 "main.c" 1
	MOV R0,#0x00
@ 0 "" 2
@ 317 "main.c" 1
	MSR PRIMASK,R0
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L55:
	.align	2
.L54:
	.word	current_task
	.word	global_tick_count
	.word	user_tasks
	.size	task_delay, .-task_delay
	.align	1
	.global	PendSV_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	PendSV_Handler, %function
PendSV_Handler:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	.syntax unified
@ 328 "main.c" 1
	MRS R0,PSP
@ 0 "" 2
@ 334 "main.c" 1
	STMDB R0!,{R4-R11}
@ 0 "" 2
@ 338 "main.c" 1
	PUSH {LR}
@ 0 "" 2
@ 339 "main.c" 1
	BL save_psp_value
@ 0 "" 2
@ 346 "main.c" 1
	BL update_next_task
@ 0 "" 2
@ 349 "main.c" 1
	BL get_psp_value
@ 0 "" 2
@ 353 "main.c" 1
	LDMIA R0!,{R4-R11}
@ 0 "" 2
@ 356 "main.c" 1
	MSR PSP,R0
@ 0 "" 2
@ 357 "main.c" 1
	POP {LR}
@ 0 "" 2
@ 358 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	PendSV_Handler, .-PendSV_Handler
	.align	1
	.global	update_global_tick_count
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	update_global_tick_count, %function
update_global_tick_count:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L58
	ldr	r3, [r3]
	adds	r3, r3, #1
	ldr	r2, .L58
	str	r3, [r2]
	nop
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L59:
	.align	2
.L58:
	.word	global_tick_count
	.size	update_global_tick_count, .-update_global_tick_count
	.align	1
	.global	unblock_tasks
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	unblock_tasks, %function
unblock_tasks:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #1
	str	r3, [r7, #4]
	b	.L61
.L63:
	ldr	r2, .L64
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L62
	ldr	r2, .L64
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #4
	ldr	r2, [r3]
	ldr	r3, .L64+4
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L62
	ldr	r2, .L64
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #0
	strb	r2, [r3]
.L62:
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L61:
	ldr	r3, [r7, #4]
	cmp	r3, #4
	ble	.L63
	nop
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L65:
	.align	2
.L64:
	.word	user_tasks
	.word	global_tick_count
	.size	unblock_tasks, .-unblock_tasks
	.align	1
	.global	SysTick_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SysTick_Handler, %function
SysTick_Handler:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	ldr	r3, .L67
	str	r3, [r7, #4]
	bl	update_global_tick_count
	bl	unblock_tasks
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #268435456
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L68:
	.align	2
.L67:
	.word	-536810236
	.size	SysTick_Handler, .-SysTick_Handler
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Exception: HardFault\000"
	.text
	.align	1
	.global	HardFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	HardFault_Handler, %function
HardFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L71
	bl	puts
.L70:
	b	.L70
.L72:
	.align	2
.L71:
	.word	.LC0
	.size	HardFault_Handler, .-HardFault_Handler
	.section	.rodata
	.align	2
.LC1:
	.ascii	"Exception: UsageFault\000"
	.align	2
.LC2:
	.ascii	"UFSR: %lx\012\000"
	.text
	.align	1
	.global	UsageFault_Handler_
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	UsageFault_Handler_, %function
UsageFault_Handler_:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	ldr	r0, .L75
	bl	puts
	ldr	r3, .L75+4
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	uxth	r3, r3
	mov	r1, r3
	ldr	r0, .L75+8
	bl	printf
.L74:
	b	.L74
.L76:
	.align	2
.L75:
	.word	.LC1
	.word	-536810198
	.word	.LC2
	.size	UsageFault_Handler_, .-UsageFault_Handler_
	.section	.rodata
	.align	2
.LC3:
	.ascii	"Exception: MemMangeFault\000"
	.text
	.align	1
	.global	MemManage_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	MemManage_Handler, %function
MemManage_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L79
	bl	puts
.L78:
	b	.L78
.L80:
	.align	2
.L79:
	.word	.LC3
	.size	MemManage_Handler, .-MemManage_Handler
	.section	.rodata
	.align	2
.LC4:
	.ascii	"Exception: BusFault\000"
	.text
	.align	1
	.global	BusFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	BusFault_Handler, %function
BusFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L83
	bl	puts
.L82:
	b	.L82
.L84:
	.align	2
.L83:
	.word	.LC4
	.size	BusFault_Handler, .-BusFault_Handler
	.ident	"GCC: (15:10.3-2021.07-4) 10.3.1 20210621 (release)"
