;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.9.0 #11195 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _crt_init
	.globl _t_none
	.globl _key_disp
	.globl _menu_disp
	.globl _msg_dac
	.globl _msg_dac1
	.globl _msg_amp_4
	.globl _msg_amp_3
	.globl _msg_amp_2
	.globl _msg_amp_1
	.globl _msg_mix_3
	.globl _msg_mix_2
	.globl _msg_mix_1
	.globl _msg_set_c
	.globl _msg_set_b
	.globl _msg_cust_amp
	.globl _msg_amp
	.globl _msg_mix
	.globl _msg_set
	.globl _msg_info
	.globl _msg_info1
	.globl _msg_fupd1
	.globl _msg_fupd
	.globl _msg_save1
	.globl _msg_save
	.globl _msg_boot
	.globl _msg_res
	.globl _msg_mode
	.globl _msg_main
	.globl _wait
	.globl _play_wav
	.globl _set_mix
	.globl _getkey
	.globl _reset_chip
	.globl _wait_online
	.globl _detect_chip
	.globl _unlock_chip
	.globl _wait_busy
	.globl _rd_reg_str
	.globl _rd_reg_arr
	.globl _rd_reg32
	.globl _rd_reg16
	.globl _rd_reg8
	.globl _rd_reg
	.globl _wr_arrpg
	.globl _wr_arr
	.globl _wr_data_chunk
	.globl _wr_reg32
	.globl _wr_reg8
	.globl _wr_reg
	.globl _wr_addr
	.globl _wr_page
	.globl _msg
	.globl _frame
	.globl _putc
	.globl _fade
	.globl _cls
	.globl _drawc
	.globl _border
	.globl _puts
	.globl _printf
	.globl _fw_bin_len
	.globl _c_amp
	.globl _clk_sel
	.globl _bus_sel
	.globl _atb_sel
	.globl _task
	.globl _req_unpress
	.globl _menu
	.globl _cc
	.globl _defx
	.globl _cy
	.globl _cx
	.globl _fw_bin
	.globl _pagsst
	.globl _wav
	.globl _res_font6x8_bin
	.globl _mix_sel_val
	.globl _bus_sel_txt
	.globl _atab_sel_txt
	.globl _clk_sel_txt
	.globl _putchar
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_cx::
	.ds 1
_cy::
	.ds 1
_defx::
	.ds 1
_cc::
	.ds 1
_menu::
	.ds 1
_req_unpress::
	.ds 1
_task::
	.ds 2
_atb_sel::
	.ds 1
_bus_sel::
	.ds 1
_clk_sel::
	.ds 1
_c_amp::
	.ds 64
_msg_dac1_v_65536_142:
	.ds 1
_msg_dac1_d_65536_142:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_fw_bin_len::
	.ds 2
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;src/msg.c:389: static u8 v = 0;
	ld	iy, #_msg_dac1_v_65536_142
	ld	0 (iy), #0x00
;src/msg.c:390: static bool d = false;
	ld	iy, #_msg_dac1_d_65536_142
	ld	0 (iy), #0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/screen.c:6: void border(u8 b) __naked
;	---------------------------------
; Function border
; ---------------------------------
_border::
;src/screen.c:15: __endasm;
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	out	(254), a
	ret
;src/screen.c:16: }
;src/screen.c:18: void drawc(u8 c) __naked
;	---------------------------------
; Function drawc
; ---------------------------------
_drawc::
;src/screen.c:170: __endasm;
	ld	hl, #2
	add	hl, sp
	ld	l, (hl)
	ld	h, #0
	ld	bc, #_res_font6x8_bin
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	a, (#_cy)
	and	#0x18
	or	#0x40
	ld	d, a
	ld	a, (#_cx)
	rrca
	rrca
	rrca
	and	#0x1F
	ld	e, a
	ld	a, (#_cy)
	and	#7
	rrca
	rrca
	rrca
	or	e
	ld	e, a
	ld	b, #8
	ld	a, (#_cx)
	rrca
	rrca
	jr	c, draw26
	rrca
	jr	c, draw4
	ld	c, #3
	  draw0:
	ld	a, (de)
	and	c
	or	(hl)
	ld	(de), a
	inc	hl
	inc	d
	djnz	draw0
	jr	drawc_a0
	  draw26:
	rrca
	jr	c, draw6
	  draw2:
	ld	a, (hl)
	rrca
	rrca
	ld	c, a
	ld	a, (de)
	and	#0xC0
	or	c
	ld	(de), a
	inc	hl
	inc	d
	djnz	draw2
	  drawc_a0:
	ld	a, (#_cy)
	rrca
	rrca
	rrca
	and	#3
	or	#0x58
	ld	d, a
	ld	a, (#_cc)
	ld	(de), a
	ret
	  draw4:
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	#0x0F
	ld	c, a
	ld	a, (de)
	and	#0xF0
	or	c
	ld	(de), a
	inc	e
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	#0xC0
	ld	c, a
	ld	a, (de)
	and	#0x3F
	or	c
	ld	(de), a
	dec	e
	inc	d
	inc	hl
	djnz	draw4
	jr	drawc_a1
	  draw6:
	ld	a, (hl)
	rlca
	rlca
	and	#0x03
	ld	c, a
	ld	a, (de)
	and	#0xFC
	or	c
	ld	(de), a
	inc	e
	ld	a, (hl)
	rlca
	rlca
	and	#0xF0
	ld	c, a
	ld	a, (de)
	and	#0x0F
	or	c
	ld	(de), a
	dec	e
	inc	d
	inc	hl
	djnz	draw6
	  drawc_a1:
	ld	a, (#_cy)
	rrca
	rrca
	rrca
	and	#3
	or	#0x58
	ld	d, a
	ld	a, (#_cc)
	ld	(de), a
	inc	e
	ld	(de), a
	ret
;src/screen.c:171: }
;src/screen.c:173: void cls()
;	---------------------------------
; Function cls
; ---------------------------------
_cls::
;src/screen.c:175: memset((void*)0x4000, 0, 6144);
	ld	hl, #0x4000
	ld	(hl), #0x00
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x17ff
	ldir
;src/screen.c:176: memset((void*)0x5800, 0, 768);
	ld	hl, #0x5800
	ld	(hl), #0x00
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x02ff
	ldir
;src/screen.c:177: defx = 0;
	ld	hl,#_defx + 0
	ld	(hl), #0x00
;src/screen.c:178: xy(0, 0);
	ld	hl,#_cx + 0
	ld	(hl), #0x00
	ld	hl,#_cy + 0
	ld	(hl), #0x00
;src/screen.c:179: }
	ret
_clk_sel_txt:
	.dw __str_0
	.dw __str_1
	.dw __str_2
	.dw __str_3
	.dw __str_4
	.dw __str_5
	.dw __str_6
	.dw __str_7
_atab_sel_txt:
	.dw __str_8
	.dw __str_9
	.dw __str_10
	.dw __str_11
_bus_sel_txt:
	.dw __str_12
	.dw __str_13
	.dw __str_14
	.dw __str_15
	.dw __str_16
	.dw __str_17
	.dw __str_17
	.dw __str_18
_mix_sel_val:
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
_res_font6x8_bin:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x54	; 84	'T'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x54	; 84	'T'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x6c	; 108	'l'
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x54	; 84	'T'
	.db #0x7c	; 124
	.db #0x54	; 84	'T'
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xcc	; 204
	.db #0x84	; 132
	.db #0x84	; 132
	.db #0xcc	; 204
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xcc	; 204
	.db #0xb4	; 180
	.db #0xb4	; 180
	.db #0xcc	; 204
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x1c	; 28
	.db #0x0c	; 12
	.db #0x14	; 20
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x60	; 96
	.db #0xe0	; 224
	.db #0x60	; 96
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x4c	; 76	'L'
	.db #0xcc	; 204
	.db #0xc0	; 192
	.db #0x10	; 16
	.db #0x54	; 84	'T'
	.db #0x38	; 56	'8'
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x78	; 120	'x'
	.db #0x70	; 112	'p'
	.db #0x60	; 96
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x18	; 24
	.db #0x38	; 56	'8'
	.db #0x78	; 120	'x'
	.db #0x38	; 56	'8'
	.db #0x18	; 24
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x34	; 52	'4'
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x7c	; 124
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x7c	; 124
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x84	; 132
	.db #0xfc	; 252
	.db #0x84	; 132
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x7c	; 124
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x7c	; 124
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x50	; 80	'P'
	.db #0x7c	; 124
	.db #0x14	; 20
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.db #0x6c	; 108	'l'
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x6c	; 108	'l'
	.db #0x4c	; 76	'L'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x2c	; 44
	.db #0x48	; 72	'H'
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x4c	; 76	'L'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x04	; 4
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x18	; 24
	.db #0x04	; 4
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x18	; 24
	.db #0x28	; 40
	.db #0x48	; 72	'H'
	.db #0x7c	; 124
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x04	; 4
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x5c	; 92
	.db #0x5c	; 92
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x48	; 72	'H'
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x40	; 64
	.db #0x5c	; 92
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x50	; 80	'P'
	.db #0x60	; 96
	.db #0x50	; 80	'P'
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x54	; 84	'T'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x64	; 100	'd'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x4c	; 76	'L'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x54	; 84	'T'
	.db #0x48	; 72	'H'
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x04	; 4
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x04	; 4
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x48	; 72	'H'
	.db #0x50	; 80	'P'
	.db #0x60	; 96
	.db #0x50	; 80	'P'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x04	; 4
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x60	; 96
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x0c	; 12
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x84	; 132
	.db #0xb4	; 180
	.db #0xa4	; 164
	.db #0xa4	; 164
	.db #0xb4	; 180
	.db #0x84	; 132
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0xfc	; 252
	.db #0x84	; 132
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x18	; 24
	.db #0x04	; 4
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x4c	; 76	'L'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x54	; 84	'T'
	.db #0x44	; 68	'D'
	.db #0x4c	; 76	'L'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x48	; 72	'H'
	.db #0x70	; 112	'p'
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x54	; 84	'T'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x7c	; 124
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x7c	; 124
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x64	; 100	'd'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x04	; 4
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x54	; 84	'T'
	.db #0x74	; 116	't'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x04	; 4
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0xfc	; 252
	.db #0x84	; 132
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x18	; 24
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x4c	; 76	'L'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x44	; 68	'D'
	.db #0x4c	; 76	'L'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x48	; 72	'H'
	.db #0x70	; 112	'p'
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x54	; 84	'T'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0xa8	; 168
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x00	; 0
	.db #0xa8	; 168
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x00	; 0
	.db #0xa8	; 168
	.db #0x54	; 84	'T'
	.db #0xa8	; 168
	.db #0x54	; 84	'T'
	.db #0xa8	; 168
	.db #0x54	; 84	'T'
	.db #0xa8	; 168
	.db #0x54	; 84	'T'
	.db #0xa8	; 168
	.db #0xfc	; 252
	.db #0x54	; 84	'T'
	.db #0xfc	; 252
	.db #0xa8	; 168
	.db #0xfc	; 252
	.db #0x54	; 84	'T'
	.db #0xfc	; 252
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xe8	; 232
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xe8	; 232
	.db #0x08	; 8
	.db #0xe8	; 232
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x08	; 8
	.db #0xe8	; 232
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xe8	; 232
	.db #0x08	; 8
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xfc	; 252
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x2c	; 44
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x2c	; 44
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x2c	; 44
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xec	; 236
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xec	; 236
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x2c	; 44
	.db #0x20	; 32
	.db #0x2c	; 44
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xec	; 236
	.db #0x00	; 0
	.db #0xec	; 236
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0xec	; 236
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xfc	; 252
	.db #0x20	; 32
	.db #0xfc	; 252
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x40	; 64
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x28	; 40
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x7c	; 124
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x7c	; 124
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x38	; 56	'8'
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x64	; 100	'd'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x78	; 120	'x'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x04	; 4
	.db #0x3c	; 60
	.db #0x04	; 4
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x54	; 84	'T'
	.db #0x74	; 116	't'
	.db #0x54	; 84	'T'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x24	; 36
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x48	; 72	'H'
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x34	; 52	'4'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x58	; 88	'X'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_wav:
	.db #0x87	; 135
	.db #0x90	; 144
	.db #0x98	; 152
	.db #0xa0	; 160
	.db #0xa7	; 167
	.db #0xaf	; 175
	.db #0xb6	; 182
	.db #0xbc	; 188
	.db #0xc4	; 196
	.db #0xca	; 202
	.db #0xd2	; 210
	.db #0xd7	; 215
	.db #0xdc	; 220
	.db #0xe2	; 226
	.db #0xe6	; 230
	.db #0xec	; 236
	.db #0xef	; 239
	.db #0xf2	; 242
	.db #0xf7	; 247
	.db #0xf9	; 249
	.db #0xfb	; 251
	.db #0xfd	; 253
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfb	; 251
	.db #0xf9	; 249
	.db #0xf7	; 247
	.db #0xf3	; 243
	.db #0xf1	; 241
	.db #0xed	; 237
	.db #0xe7	; 231
	.db #0xe2	; 226
	.db #0xde	; 222
	.db #0xd7	; 215
	.db #0xd1	; 209
	.db #0xcc	; 204
	.db #0xc5	; 197
	.db #0xbe	; 190
	.db #0xb6	; 182
	.db #0xb0	; 176
	.db #0xa8	; 168
	.db #0xa1	; 161
	.db #0x99	; 153
	.db #0x91	; 145
	.db #0x88	; 136
	.db #0x81	; 129
	.db #0x7a	; 122	'z'
	.db #0x72	; 114	'r'
	.db #0x6a	; 106	'j'
	.db #0x61	; 97	'a'
	.db #0x59	; 89	'Y'
	.db #0x52	; 82	'R'
	.db #0x4a	; 74	'J'
	.db #0x44	; 68	'D'
	.db #0x3c	; 60
	.db #0x36	; 54	'6'
	.db #0x2f	; 47
	.db #0x29	; 41
	.db #0x24	; 36
	.db #0x1e	; 30
	.db #0x1a	; 26
	.db #0x15	; 21
	.db #0x11	; 17
	.db #0x0e	; 14
	.db #0x0b	; 11
	.db #0x07	; 7
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x09	; 9
	.db #0x0c	; 12
	.db #0x10	; 16
	.db #0x14	; 20
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x22	; 34
	.db #0x27	; 39
	.db #0x2e	; 46
	.db #0x34	; 52	'4'
	.db #0x3c	; 60
	.db #0x42	; 66	'B'
	.db #0x48	; 72	'H'
	.db #0x4f	; 79	'O'
	.db #0x57	; 87	'W'
	.db #0x5f	; 95
	.db #0x66	; 102	'f'
	.db #0x6e	; 110	'n'
	.db #0x78	; 120	'x'
	.db #0x7e	; 126
__str_0:
	.ascii "Internal 1.75MHz"
	.db 0x00
__str_1:
	.ascii "Internal 1.775MHz"
	.db 0x00
__str_2:
	.ascii "Internal 3.5MHz"
	.db 0x00
__str_3:
	.ascii "Internal 3.55MHz"
	.db 0x00
__str_4:
	.ascii "Internal 1.0MHz"
	.db 0x00
__str_5:
	.ascii "Internal 2.0MHz"
	.db 0x00
__str_6:
	.ascii "External"
	.db 0x00
__str_7:
	.ascii "External with SEL"
	.db 0x00
__str_8:
	.ascii "AY-3-8912"
	.db 0x00
__str_9:
	.ascii "YM-2149F"
	.db 0x00
__str_10:
	.ascii "Unreal Speccy"
	.db 0x00
__str_11:
	.ascii "Custom"
	.db 0x00
__str_12:
	.ascii "2 chips (TS)"
	.db 0x00
__str_13:
	.ascii "1 chip"
	.db 0x00
__str_14:
	.ascii "2 chips"
	.db 0x00
__str_15:
	.ascii "3 chips"
	.db 0x00
__str_16:
	.ascii "4 chips"
	.db 0x00
__str_17:
	.db 0x00
__str_18:
	.ascii "Disable PSG"
	.db 0x00
;src/screen.c:181: void fade()
;	---------------------------------
; Function fade
; ---------------------------------
_fade::
;src/screen.c:183: memset((void*)0x5800, 1, 768);
	ld	hl, #0x5800
	ld	(hl), #0x01
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x02ff
	ldir
;src/screen.c:184: }
	ret
;src/screen.c:186: void putc(u8 c)
;	---------------------------------
; Function putc
; ---------------------------------
_putc::
;src/screen.c:188: if((c == '\r') || (c == '\n'))
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	sub	a, #0x0d
	jr	Z,00101$
	ld	a, 0 (iy)
	sub	a, #0x0a
	jr	NZ,00102$
00101$:
;src/screen.c:190: xy(defx, cy + 1);
	ld	a,(#_defx + 0)
	ld	(#_cx + 0),a
	ld	hl, #_cy+0
	inc	(hl)
;src/screen.c:191: return;
	ret
00102$:
;src/screen.c:194: drawc(c);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_drawc
	inc	sp
;src/screen.c:195: xy(cx + 6, cy);
	ld	iy, #_cx
	ld	a, 0 (iy)
	add	a, #0x06
	ld	0 (iy), a
;src/screen.c:196: }
	ret
;src/screen.c:198: int putchar(int c)
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
;src/screen.c:200: putc(c);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_putc
	inc	sp
;src/screen.c:201: return 0;
	ld	hl, #0x0000
;src/screen.c:202: }
	ret
;src/screen.c:204: void frame(u8 xx, u8 yy, u8 sx, u8 sy, u8 cf)
;	---------------------------------
; Function frame
; ---------------------------------
_frame::
	push	ix
	ld	ix,#0
	add	ix,sp
;src/screen.c:207: xy(xx, yy);
	ld	a, 4 (ix)
	ld	(#_cx + 0),a
	ld	a, 5 (ix)
	ld	(#_cy + 0),a
;src/screen.c:209: color(cf);
	ld	a, 8 (ix)
	ld	(#_cc + 0),a
;src/screen.c:211: putc(201);
	ld	a, #0xc9
	push	af
	inc	sp
	call	_putc
	inc	sp
;src/screen.c:212: for (i = 0; i < sx; i++)
	ld	c, #0x00
00106$:
	ld	a, c
	sub	a, 6 (ix)
	jr	NC,00101$
;src/screen.c:213: putc(205);
	push	bc
	ld	a, #0xcd
	push	af
	inc	sp
	call	_putc
	inc	sp
	pop	bc
;src/screen.c:212: for (i = 0; i < sx; i++)
	inc	c
	jr	00106$
00101$:
;src/screen.c:214: putc(187);
	ld	a, #0xbb
	push	af
	inc	sp
	call	_putc
	inc	sp
;src/screen.c:215: xy(xx, cy + 1);
	ld	a, 4 (ix)
	ld	(#_cx + 0),a
	ld	hl, #_cy+0
	inc	(hl)
;src/screen.c:217: for(j = 0; j < sy; j++)
	ld	c, 4 (ix)
	ld	b, #0x00
00112$:
	ld	a, b
	sub	a, 7 (ix)
	jr	NC,00103$
;src/screen.c:219: putc(186);
	push	bc
	ld	a, #0xba
	push	af
	inc	sp
	call	_putc
	inc	sp
	pop	bc
;src/screen.c:220: for (i = 0; i < sx; i++)
	ld	e, #0x00
00109$:
	ld	a, e
	sub	a, 6 (ix)
	jr	NC,00102$
;src/screen.c:221: putc(32);
	push	bc
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	call	_putc
	inc	sp
	pop	de
	pop	bc
;src/screen.c:220: for (i = 0; i < sx; i++)
	inc	e
	jr	00109$
00102$:
;src/screen.c:222: putc(186);
	push	bc
	ld	a, #0xba
	push	af
	inc	sp
	call	_putc
	inc	sp
	pop	bc
;src/screen.c:223: xy(xx, cy + 1);
	ld	hl,#_cx + 0
	ld	(hl), c
	ld	hl, #_cy+0
	inc	(hl)
;src/screen.c:217: for(j = 0; j < sy; j++)
	inc	b
	jr	00112$
00103$:
;src/screen.c:226: putc(200);
	ld	a, #0xc8
	push	af
	inc	sp
	call	_putc
	inc	sp
;src/screen.c:227: for (i = 0; i < sx; i++)
	ld	c, #0x00
00115$:
	ld	a, c
	sub	a, 6 (ix)
	jr	NC,00104$
;src/screen.c:228: putc(205);
	push	bc
	ld	a, #0xcd
	push	af
	inc	sp
	call	_putc
	inc	sp
	pop	bc
;src/screen.c:227: for (i = 0; i < sx; i++)
	inc	c
	jr	00115$
00104$:
;src/screen.c:229: putc(188);
	ld	a, #0xbc
	push	af
	inc	sp
	call	_putc
	inc	sp
;src/screen.c:231: defx = xx + 8;
	ld	a, 4 (ix)
	add	a, #0x08
	ld	iy, #_defx
	ld	0 (iy), a
;src/screen.c:232: xy(defx, yy + 1);
	ld	a, 0 (iy)
	ld	(#_cx + 0),a
	ld	a, 5 (ix)
	inc	a
	ld	(#_cy + 0),a
;src/screen.c:233: }
	pop	ix
	ret
;src/screen.c:235: void msg(u8 *adr)
;	---------------------------------
; Function msg
; ---------------------------------
_msg::
;src/screen.c:238: while(c = *adr++)
	pop	de
	pop	bc
	push	bc
	push	de
00101$:
	ld	a, (bc)
	inc	bc
	ld	d, a
	or	a, a
	ret	Z
;src/screen.c:239: putc(c);
	push	bc
	push	de
	inc	sp
	call	_putc
	inc	sp
	pop	bc
;src/screen.c:240: }
	jr	00101$
;src/ayx32.c:16: void wr_page(u8 v) __naked
;	---------------------------------
; Function wr_page
; ---------------------------------
_wr_page::
;src/ayx32.c:26: __endasm;
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	ld	bc, #0x7FFD
	out	(c), a
	ret
;src/ayx32.c:27: }
;src/ayx32.c:30: void wr_addr(u8 v) __naked
;	---------------------------------
; Function wr_addr
; ---------------------------------
_wr_addr::
;src/ayx32.c:40: __endasm;
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	ld	bc, #0xFFFD
	out	(c), a
	ret
;src/ayx32.c:41: }
;src/ayx32.c:43: void wr_reg(u8 v) __naked
;	---------------------------------
; Function wr_reg
; ---------------------------------
_wr_reg::
;src/ayx32.c:53: __endasm;
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	ld	bc, #0xBFFD
	out	(c), a
	ret
;src/ayx32.c:54: }
;src/ayx32.c:56: void wr_reg8(u8 reg, u8 data)
;	---------------------------------
; Function wr_reg8
; ---------------------------------
_wr_reg8::
;src/ayx32.c:58: wr_addr(reg);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:59: wr_reg(data);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_wr_reg
	inc	sp
;src/ayx32.c:60: }
	ret
_pagsst:
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x16	; 22
	.db #0x17	; 23
;src/ayx32.c:62: void wr_reg32(u8 reg, u32 data)
;	---------------------------------
; Function wr_reg32
; ---------------------------------
_wr_reg32::
;src/ayx32.c:64: wr_addr(reg);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:65: wr_reg((u8)data);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_wr_reg
	inc	sp
;src/ayx32.c:66: wr_reg((u8)(data >> 8));
	ld	hl, #3+1
	add	hl, sp
	ld	b, (hl)
	ld	c, #0x00
	push	bc
	inc	sp
	call	_wr_reg
	inc	sp
;src/ayx32.c:67: wr_reg((u8)(data >> 16));
	ld	iy, #3
	add	iy, sp
	ld	b, 2 (iy)
	ld	c, 3 (iy)
	push	bc
	inc	sp
	call	_wr_reg
	inc	sp
;src/ayx32.c:68: wr_reg((u8)(data >> 24));
	ld	hl, #3+3
	add	hl, sp
	ld	b, (hl)
	ld	c, #0x00
	push	bc
	inc	sp
	call	_wr_reg
	inc	sp
;src/ayx32.c:69: }
	ret
;src/ayx32.c:73: void wr_data_chunk(u8 *v) __naked
;	---------------------------------
; Function wr_data_chunk
; ---------------------------------
_wr_data_chunk::
;src/ayx32.c:149: __endasm;
	ld	hl, #2
	add	hl, sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	ld	bc, #0xC0FD
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	ret
;src/ayx32.c:150: }
;src/ayx32.c:152: void wr_arr(u8 *ptr, u16 size)
;	---------------------------------
; Function wr_arr
; ---------------------------------
_wr_arr::
	push	ix
	ld	ix,#0
	add	ix,sp
;src/ayx32.c:154: while (size >= CHUNK_SIZE)
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	ld	c, 6 (ix)
	ld	b, 7 (ix)
00101$:
	ld	a, c
	sub	a, #0x40
	ld	a, b
	sbc	a, #0x00
	jr	C,00112$
;src/ayx32.c:156: wr_data_chunk(ptr);
	push	hl
	push	bc
	push	hl
	call	_wr_data_chunk
	pop	af
	pop	bc
	pop	hl
;src/ayx32.c:157: ptr += CHUNK_SIZE;
	ld	de, #0x0040
	add	hl, de
;src/ayx32.c:158: size -= CHUNK_SIZE;
	ld	a, c
	add	a, #0xc0
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	jr	00101$
;src/ayx32.c:160: while (size--)
00112$:
00104$:
	ld	e, c
	ld	d, b
	dec	bc
	ld	a, d
	or	a, e
	jr	Z,00107$
;src/ayx32.c:161: wr_reg(*ptr++);
	ld	a, (hl)
	inc	hl
	push	hl
	push	bc
	push	af
	inc	sp
	call	_wr_reg
	inc	sp
	pop	bc
	pop	hl
	jr	00104$
00107$:
;src/ayx32.c:162: }
	pop	ix
	ret
;src/ayx32.c:164: void wr_arrpg(u8 *ptr, u16 size)
;	---------------------------------
; Function wr_arrpg
; ---------------------------------
_wr_arrpg::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;src/ayx32.c:166: u16 adr = (u16)(&ptr[0]);
	ld	c, 4 (ix)
	ld	b, 5 (ix)
;src/ayx32.c:171: wr_page(pagsst[pp++]);
	ld	a, (#_pagsst + 0)
	push	bc
	push	af
	inc	sp
	call	_wr_page
	inc	sp
	pop	bc
;src/ayx32.c:172: while(size--)
	ld	e, 6 (ix)
	ld	d, 7 (ix)
	ld	-1 (ix), #0x01
00103$:
	ld	l, e
	ld	h, d
	dec	de
	ld	a, h
	or	a, l
	jr	Z,00105$
;src/ayx32.c:175: u8 b = ((u8 *)(adr))[0];
	ld	l, c
	ld	h, b
	ld	a, (hl)
;src/ayx32.c:176: wr_reg(b);
	push	bc
	push	de
	push	af
	inc	sp
	call	_wr_reg
	inc	sp
	pop	de
	pop	bc
;src/ayx32.c:177: adr++;
	inc	bc
;src/ayx32.c:178: if (adr==0)
	ld	a, b
	or	a, c
	jr	NZ,00103$
;src/ayx32.c:180: wr_page(pagsst[pp++]);
	ld	a, #<(_pagsst)
	add	a, -1 (ix)
	ld	c, a
	ld	a, #>(_pagsst)
	adc	a, #0x00
	ld	b, a
	inc	-1 (ix)
	ld	a, (bc)
	push	de
	push	af
	inc	sp
	call	_wr_page
	inc	sp
	pop	de
;src/ayx32.c:181: adr = 49152;
	ld	bc, #0xc000
	jr	00103$
00105$:
;src/ayx32.c:196: wr_page(16);
	ld	a, #0x10
	push	af
	inc	sp
	call	_wr_page
	inc	sp
;src/ayx32.c:200: }
	inc	sp
	pop	ix
	ret
;src/ayx32.c:201: u8 rd_reg() __naked
;	---------------------------------
; Function rd_reg
; ---------------------------------
_rd_reg::
;src/ayx32.c:207: __endasm;
	ld	bc, #0xFFFD
	in	l, (c)
	ret
;src/ayx32.c:208: }
;src/ayx32.c:210: u8 rd_reg8(u8 reg)
;	---------------------------------
; Function rd_reg8
; ---------------------------------
_rd_reg8::
;src/ayx32.c:212: wr_addr(reg);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:213: return rd_reg();
;src/ayx32.c:214: }
	jp  _rd_reg
;src/ayx32.c:216: u16 rd_reg16(u8 reg)
;	---------------------------------
; Function rd_reg16
; ---------------------------------
_rd_reg16::
	push	ix
	ld	ix,#0
	add	ix,sp
;src/ayx32.c:219: wr_addr(reg);
	ld	a, 4 (ix)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:220: rc = rd_reg();
	call	_rd_reg
	ld	c, l
	ld	b, #0x00
;src/ayx32.c:221: rc |= rd_reg() << 8;
	push	bc
	call	_rd_reg
	pop	bc
	ld	d, l
	ld	e, #0x00
	ld	a, c
	or	a, e
	ld	l, a
	ld	a, b
	or	a, d
	ld	h, a
;src/ayx32.c:222: return rc;
;src/ayx32.c:223: }
	pop	ix
	ret
;src/ayx32.c:225: u32 rd_reg32(u8 reg)
;	---------------------------------
; Function rd_reg32
; ---------------------------------
_rd_reg32::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-8
	add	hl, sp
	ld	sp, hl
;src/ayx32.c:228: wr_addr(reg);
	ld	a, 4 (ix)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:229: rc  = (u32)rd_reg();
	call	_rd_reg
	ld	-8 (ix), l
	ld	-7 (ix), #0x00
	ld	-6 (ix), #0x00
	ld	-5 (ix), #0x00
;src/ayx32.c:230: rc |= (u32)rd_reg() << 8;
	call	_rd_reg
	ld	h, #0x00
	ld	c, #0x00
	ld	b, l
	ld	e, h
	ld	d, c
	ld	c, #0x00
	ld	a, -8 (ix)
	or	a, c
	ld	-4 (ix), a
	ld	a, -7 (ix)
	or	a, b
	ld	-3 (ix), a
	ld	a, -6 (ix)
	or	a, e
	ld	-2 (ix), a
	ld	a, -5 (ix)
	or	a, d
	ld	-1 (ix), a
;src/ayx32.c:231: rc |= (u32)rd_reg() << 16;
	call	_rd_reg
	ld	h, #0x00
	ld	bc, #0x0000
	ld	a, -4 (ix)
	or	a, c
	ld	c, a
	ld	a, -3 (ix)
	or	a, b
	ld	b, a
	ld	a, -2 (ix)
	or	a, l
	ld	e, a
	ld	a, -1 (ix)
	or	a, h
	ld	d, a
	ld	-4 (ix), c
	ld	-3 (ix), b
	ld	-2 (ix), e
	ld	-1 (ix), d
;src/ayx32.c:232: rc |= (u32)rd_reg() << 24;
	call	_rd_reg
	ld	d, l
	ld	bc, #0x0000
	ld	e, #0x00
	ld	a, -4 (ix)
	or	a, c
	ld	l, a
	ld	a, -3 (ix)
	or	a, b
	ld	h, a
	ld	a, -2 (ix)
	or	a, e
	ld	e, a
	ld	a, -1 (ix)
	or	a, d
	ld	d, a
;src/ayx32.c:233: return rc;
;src/ayx32.c:234: }
	ld	sp, ix
	pop	ix
	ret
;src/ayx32.c:236: void rd_reg_arr(u8 reg, u8 *ptr, u16 size)
;	---------------------------------
; Function rd_reg_arr
; ---------------------------------
_rd_reg_arr::
	push	ix
	ld	ix,#0
	add	ix,sp
;src/ayx32.c:238: wr_addr(reg);
	ld	a, 4 (ix)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:240: while (size--)
	ld	e, 5 (ix)
	ld	d, 6 (ix)
	ld	c, 7 (ix)
	ld	b, 8 (ix)
00101$:
	ld	l, c
	ld	h, b
	dec	bc
	ld	a, h
	or	a, l
	jr	Z,00104$
;src/ayx32.c:241: *ptr++ = rd_reg();
	push	bc
	push	de
	call	_rd_reg
	ld	a, l
	pop	de
	pop	bc
	ld	(de), a
	inc	de
	jr	00101$
00104$:
;src/ayx32.c:242: }
	pop	ix
	ret
;src/ayx32.c:244: void rd_reg_str(u8 reg, u8 *str, u8 n)
;	---------------------------------
; Function rd_reg_str
; ---------------------------------
_rd_reg_str::
;src/ayx32.c:248: wr_addr(reg);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/ayx32.c:250: while (--n)
	ld	hl, #3
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #5+0
	add	hl, sp
	ld	e, (hl)
00103$:
	dec	e
	jr	Z,00105$
;src/ayx32.c:252: d = rd_reg();
	push	bc
	push	de
	call	_rd_reg
	ld	a, l
	pop	de
	pop	bc
;src/ayx32.c:253: if (!d) break;
;src/ayx32.c:254: *str++ = d;
	ld	d,a
	or	a,a
	jr	Z,00105$
	ld	(bc), a
	inc	bc
	jr	00103$
00105$:
;src/ayx32.c:257: *str = 0;
	xor	a, a
	ld	(bc), a
;src/ayx32.c:258: }
	ret
;src/ayx32.c:260: void wait_busy()
;	---------------------------------
; Function wait_busy
; ---------------------------------
_wait_busy::
;src/ayx32.c:262: while (rd_reg8(R_STATUS) & S_BUSY);
00101$:
	ld	a, #0xe1
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	rrca
	jr	C,00101$
;src/ayx32.c:263: }
	ret
;src/ayx32.c:265: void unlock_chip()
;	---------------------------------
; Function unlock_chip
; ---------------------------------
_unlock_chip::
;src/ayx32.c:267: wr_reg32(R_PARAM, MAGIC_LCK);
	ld	hl, #0xc0de
	push	hl
	ld	hl, #0xface
	push	hl
	ld	a, #0xe3
	push	af
	inc	sp
	call	_wr_reg32
	pop	af
	pop	af
	inc	sp
;src/ayx32.c:268: wr_reg8(R_CMD, C_LOCK);
	ld	de, #0xe4e1
	push	de
	call	_wr_reg8
	pop	af
;src/ayx32.c:269: wait_busy();
;src/ayx32.c:270: }
	jp  _wait_busy
;src/ayx32.c:272: bool detect_chip()
;	---------------------------------
; Function detect_chip
; ---------------------------------
_detect_chip::
;src/ayx32.c:274: return rd_reg16(R_DEV_SIG) == M_DEVSIG;
	ld	a, #0xe0
	push	af
	inc	sp
	call	_rd_reg16
	inc	sp
	ld	a, l
	sub	a, #0x55
	jr	NZ,00103$
	ld	a, h
	sub	a, #0xaa
	jr	NZ, 00103$
	ld	a, #0x01
	.db	#0x20
00103$:
	xor	a, a
00104$:
	ld	l, a
;src/ayx32.c:275: }
	ret
;src/ayx32.c:277: void wait_online()
;	---------------------------------
; Function wait_online
; ---------------------------------
_wait_online::
;src/ayx32.c:279: while(1)
00106$:
;src/ayx32.c:282: if (detect_chip()) break;
	call	_detect_chip
	ld	a, l
	or	a, a
	ret	NZ
;src/ayx32.c:285: wr_reg8(0, 0x55);
	ld	a, #0x55
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_wr_reg8
	pop	af
;src/ayx32.c:286: if (rd_reg8(0) == 0x55) break;
	xor	a, a
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	sub	a, #0x55
	jr	NZ,00106$
;src/ayx32.c:288: }
	ret
;src/ayx32.c:290: void reset_chip()
;	---------------------------------
; Function reset_chip
; ---------------------------------
_reset_chip::
;src/ayx32.c:292: wr_reg32(R_PARAM, MAGIC_RES);
	ld	hl, #0xdead
	push	hl
	ld	hl, #0xbeef
	push	hl
	ld	a, #0xe3
	push	af
	inc	sp
	call	_wr_reg32
	pop	af
	pop	af
	inc	sp
;src/ayx32.c:293: wr_reg8(R_CMD, C_RESET);
	ld	de, #0xebe1
	push	de
	call	_wr_reg8
	pop	af
;src/ayx32.c:294: wait_online();
;src/ayx32.c:295: }
	jp  _wait_online
;src/kbd.c:3: u8 getkey() __naked
;	---------------------------------
; Function getkey
; ---------------------------------
_getkey::
;src/kbd.c:20: __endasm;
	ld	bc, #0xFEFE
	ld	l, #0
	  k1:
	in	a, (c)
	ld	h, #5
	  k2:
	rra
	ret	nc
	inc	l
	dec	h
	jr	nz, k2
	rlc	b
	jr	c, k1
	ret
;src/kbd.c:21: }
;src/func.c:2: void set_mix(u8 mix)
;	---------------------------------
; Function set_mix
; ---------------------------------
_set_mix::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-11
	add	hl, sp
	ld	sp, hl
;src/func.c:6: for (i = 0; i < 4; i++)
	ld	bc, #_mix_sel_val+0
	ld	e, 4 (ix)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, bc
	ex	de, hl
	inc	sp
	inc	sp
	push	de
	ld	-9 (ix), e
	ld	-8 (ix), d
	ld	-7 (ix), e
	ld	-6 (ix), d
	ld	-5 (ix), e
	ld	-4 (ix), d
	ld	-3 (ix), e
	ld	-2 (ix), d
	ld	-1 (ix), #0x00
00102$:
;src/func.c:8: wr_reg8(R_PSG_SEL, i);
	push	de
	ld	d, -1 (ix)
	ld	e,#0xd0
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:9: wr_reg8(R_PSG_VOL_AL, mix_sel_val[mix][0]);
	ld	a, (de)
	push	de
	ld	d,a
	ld	e,#0x10
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:10: wr_reg8(R_PSG_VOL_AR, mix_sel_val[mix][1]);
	pop	hl
	push	hl
	inc	hl
	ld	a, (hl)
	push	de
	ld	d,a
	ld	e,#0x11
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:11: wr_reg8(R_PSG_VOL_BL, mix_sel_val[mix][2]);
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	inc	hl
	inc	hl
	ld	a, (hl)
	push	de
	ld	d,a
	ld	e,#0x12
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:12: wr_reg8(R_PSG_VOL_BR, mix_sel_val[mix][3]);
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	push	de
	ld	d,a
	ld	e,#0x13
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:13: wr_reg8(R_PSG_VOL_CL, mix_sel_val[mix][4]);
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	bc, #0x0004
	add	hl, bc
	ld	a, (hl)
	push	de
	ld	d,a
	ld	e,#0x14
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:14: wr_reg8(R_PSG_VOL_CR, mix_sel_val[mix][5]);
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	ld	bc, #0x0005
	add	hl, bc
	ld	a, (hl)
	push	de
	ld	d,a
	ld	e,#0x15
	push	de
	call	_wr_reg8
	pop	af
	pop	de
;src/func.c:6: for (i = 0; i < 4; i++)
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x04
	jp	C, 00102$
;src/func.c:16: }
	ld	sp, ix
	pop	ix
	ret
;src/func.c:18: void play_wav(u8 *w, u16 s)
;	---------------------------------
; Function play_wav
; ---------------------------------
_play_wav::
	push	ix
	ld	ix,#0
	add	ix,sp
;src/func.c:22: while (s)
00103$:
	ld	a, 7 (ix)
	or	a, 6 (ix)
	jr	Z,00106$
;src/func.c:24: f = rd_reg16(R_DAC_FREE);
	ld	a, #0x44
	push	af
	inc	sp
	call	_rd_reg16
	inc	sp
	ld	c, l
	ld	b, h
;src/func.c:29: f = min(f, s);
	ld	a, c
	sub	a, 6 (ix)
	ld	a, b
	sbc	a, 7 (ix)
	jr	C,00109$
	ld	c, 6 (ix)
	ld	b, 7 (ix)
00109$:
;src/func.c:30: if (f > 0)
	ld	a, b
	or	a, c
	jr	Z,00103$
;src/func.c:32: wr_addr(R_DAC_DATA);
	push	bc
	ld	a, #0x46
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
	pop	bc
;src/func.c:33: wr_arr(w, f);
	push	bc
	push	bc
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_wr_arr
	pop	af
	pop	af
	pop	bc
;src/func.c:34: w += f;
	ld	a, 4 (ix)
	add	a, c
	ld	4 (ix), a
	ld	a, 5 (ix)
	adc	a, b
	ld	5 (ix), a
;src/func.c:35: s -= f;
	ld	a, 6 (ix)
	sub	a, c
	ld	6 (ix), a
	ld	a, 7 (ix)
	sbc	a, b
	ld	7 (ix), a
	jr	00103$
00106$:
;src/func.c:38: }
	pop	ix
	ret
;src/func.c:40: void wait(u16 d)
;	---------------------------------
; Function wait
; ---------------------------------
_wait::
	push	af
;src/func.c:42: volatile u16 a = d;
	ld	hl, #4+0
	add	hl, sp
	ld	a, (hl)
	ld	iy, #0
	add	iy, sp
	ld	0 (iy), a
	ld	hl, #4+1
	add	hl, sp
	ld	a, (hl)
	ld	iy, #0
	add	iy, sp
	ld	1 (iy), a
;src/func.c:43: while (a--);
00101$:
	pop	bc
	push	bc
	ld	hl, #0
	add	hl, sp
	ld	a, c
	add	a, #0xff
	ld	(hl), a
	ld	a, b
	adc	a, #0xff
	inc	hl
	ld	(hl), a
	ld	a, b
	or	a, c
	jr	NZ,00101$
;src/func.c:44: }
	pop	af
	ret
;src/msg.c:2: void msg_main()
;	---------------------------------
; Function msg_main
; ---------------------------------
_msg_main::
;src/msg.c:4: cls();
	call	_cls
;src/msg.c:5: xy(41,1); color(C_HEAD); printf("AYX-32 Configuration Utility");
	ld	hl,#_cx + 0
	ld	(hl), #0x29
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_19
	push	hl
	call	_printf
	pop	af
;src/msg.c:6: defx = 30; xy(defx, 5);
	ld	hl,#_defx + 0
	ld	(hl), #0x1e
	ld	hl,#_cx + 0
	ld	(hl), #0x1e
	ld	hl,#_cy + 0
	ld	(hl), #0x05
;src/msg.c:7: color(C_BUTN); printf("1. "); color(C_NORM); printf("Device info\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_20
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_22
	push	hl
	call	_puts
	pop	af
;src/msg.c:8: color(C_BUTN); printf("2. "); color(C_NORM); printf("Settings\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_23
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
;src/msg.c:10: printf("\n\n");
	ld	hl, #___str_36
	push	hl
	call	_puts
	pop	af
;src/msg.c:11: color(C_BUTN); printf("U. "); color(C_NORM); printf("Upload Firmware\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_28
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_30
	push	hl
	call	_puts
	pop	af
;src/msg.c:12: color(C_BUTN); printf("R. "); color(C_NORM); printf("Restart device\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_31
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_33
	push	hl
	call	_puts
	pop	af
;src/msg.c:13: color(C_BUTN); printf("B. "); color(C_NORM); printf("Restart device in Boot");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_34
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_35
	push	hl
	call	_printf
	pop	af
;src/msg.c:14: }
	ret
_fw_bin:
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x98	; 152
	.db #0x01	; 1
	.db #0x74	; 116	't'
	.db #0xc5	; 197
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xdd	; 221
	.db #0xa6	; 166
	.db #0xda	; 218
	.db #0x9a	; 154
	.db #0x55	; 85	'U'
	.db #0x4d	; 77	'M'
	.db #0x26	; 38
	.db #0x99	; 153
	.db #0xb0	; 176
	.db #0xb9	; 185
	.db #0xf1	; 241
	.db #0x05	; 5
	.db #0x53	; 83	'S'
	.db #0x9f	; 159
	.db #0xbb	; 187
	.db #0xd7	; 215
	.db #0xde	; 222
	.db #0x4b	; 75	'K'
	.db #0xeb	; 235
	.db #0x37	; 55	'7'
___str_19:
	.ascii "AYX-32 Configuration Utility"
	.db 0x00
___str_20:
	.ascii "1. "
	.db 0x00
___str_22:
	.ascii "Device info"
	.db 0x0a
	.db 0x00
___str_23:
	.ascii "2. "
	.db 0x00
___str_28:
	.ascii "U. "
	.db 0x00
___str_30:
	.ascii "Upload Firmware"
	.db 0x0a
	.db 0x00
___str_31:
	.ascii "R. "
	.db 0x00
___str_33:
	.ascii "Restart device"
	.db 0x0a
	.db 0x00
___str_34:
	.ascii "B. "
	.db 0x00
___str_35:
	.ascii "Restart device in Boot"
	.db 0x00
___str_36:
	.ascii "Settings"
	.db 0x0a
	.db 0x0a
	.db 0x0a
	.db 0x00
;src/msg.c:17: void msg_mode()
;	---------------------------------
; Function msg_mode
; ---------------------------------
_msg_mode::
;src/msg.c:19: color(C_NORM); printf("Mode: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_37
	push	hl
	call	_printf
	pop	af
;src/msg.c:20: color(C_DATA); printf("%s\n\n", (rd_reg8(R_STATUS) & S_BOOT) ? "Boot" : "Work");
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	a, #0xe1
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	rlca
	jr	NC,00103$
	ld	bc, #___str_39+0
	jr	00104$
00103$:
	ld	bc, #___str_40+0
00104$:
	push	bc
	ld	hl, #___str_38
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:21: }
	ret
___str_37:
	.ascii "Mode: "
	.db 0x00
___str_38:
	.ascii "%s"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_39:
	.ascii "Boot"
	.db 0x00
___str_40:
	.ascii "Work"
	.db 0x00
;src/msg.c:23: void msg_res()
;	---------------------------------
; Function msg_res
; ---------------------------------
_msg_res::
;src/msg.c:25: reset_chip();
	call	_reset_chip
;src/msg.c:26: unlock_chip();
	call	_unlock_chip
;src/msg.c:27: fade();
	call	_fade
;src/msg.c:28: frame (56, 8, 22, 5, C_FRAM);
	ld	de, #0x0705
	push	de
	ld	de, #0x1608
	push	de
	ld	a, #0x38
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:29: xy(80, 10); color(C_OK); printf("Device restarted");
	ld	hl,#_cx + 0
	ld	(hl), #0x50
	ld	hl,#_cy + 0
	ld	(hl), #0x0a
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_41
	push	hl
	call	_printf
	pop	af
;src/msg.c:30: xy(96, 12); msg_mode();
	ld	hl,#_cx + 0
	ld	(hl), #0x60
	ld	hl,#_cy + 0
	ld	(hl), #0x0c
;src/msg.c:31: }
	jp  _msg_mode
___str_41:
	.ascii "Device restarted"
	.db 0x00
;src/msg.c:33: void msg_boot()
;	---------------------------------
; Function msg_boot
; ---------------------------------
_msg_boot::
;src/msg.c:35: fade();
	call	_fade
;src/msg.c:36: frame (32, 6, 30, 3, C_FRAM);
	ld	de, #0x0703
	push	de
	ld	de, #0x1e06
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:37: xy(72, 8); color(C_QUST); printf("Short 'BOOT' jumper");
	ld	hl,#_cx + 0
	ld	(hl), #0x48
	ld	hl,#_cy + 0
	ld	(hl), #0x08
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	hl, #___str_42
	push	hl
	call	_printf
	pop	af
;src/msg.c:39: while (1)
00104$:
;src/msg.c:41: reset_chip();
	call	_reset_chip
;src/msg.c:42: unlock_chip();
	call	_unlock_chip
;src/msg.c:43: if (rd_reg8(R_STATUS) & S_BOOT) break;
	ld	a, #0xe1
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	rlca
	jr	NC,00104$
;src/msg.c:46: fade();
	call	_fade
;src/msg.c:47: frame (48, 12, 24, 1, C_FRAM);
	ld	de, #0x0701
	push	de
	ld	de, #0x180c
	push	de
	ld	a, #0x30
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:48: xy(76, 13); color(C_INFO); printf("Device is in Boot");
	ld	hl,#_cx + 0
	ld	(hl), #0x4c
	ld	hl,#_cy + 0
	ld	(hl), #0x0d
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_43
	push	hl
	call	_printf
	pop	af
;src/msg.c:49: }
	ret
___str_42:
	.ascii "Short 'BOOT' jumper"
	.db 0x00
___str_43:
	.ascii "Device is in Boot"
	.db 0x00
;src/msg.c:51: void msg_save()
;	---------------------------------
; Function msg_save
; ---------------------------------
_msg_save::
;src/msg.c:53: fade();
	call	_fade
;src/msg.c:54: frame (32, 6, 30, 6, C_FRAM);
	ld	de, #0x0706
	push	de
	ld	de, #0x1e06
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:55: xy(60, 8); color(C_QUST); printf("You are about to write");
	ld	hl,#_cx + 0
	ld	(hl), #0x3c
	ld	hl,#_cy + 0
	ld	(hl), #0x08
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	hl, #___str_44
	push	hl
	call	_printf
	pop	af
;src/msg.c:56: xy(70, 9); printf("settings into Flash");
	ld	hl,#_cx + 0
	ld	(hl), #0x46
	ld	hl,#_cy + 0
	ld	(hl), #0x09
	ld	hl, #___str_45
	push	hl
	call	_printf
	pop	af
;src/msg.c:57: xy(98, 11); color(C_NORM); printf("Sure? (Y/N)");
	ld	hl,#_cx + 0
	ld	(hl), #0x62
	ld	hl,#_cy + 0
	ld	(hl), #0x0b
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_46
	push	hl
	call	_printf
	pop	af
;src/msg.c:58: }
	ret
___str_44:
	.ascii "You are about to write"
	.db 0x00
___str_45:
	.ascii "settings into Flash"
	.db 0x00
___str_46:
	.ascii "Sure? (Y/N)"
	.db 0x00
;src/msg.c:60: void msg_save1()
;	---------------------------------
; Function msg_save1
; ---------------------------------
_msg_save1::
;src/msg.c:62: frame (48, 15, 24, 1, C_FRAM);
	ld	de, #0x0701
	push	de
	ld	de, #0x180f
	push	de
	ld	a, #0x30
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:63: xy(74, 16); color(C_INFO); printf("Saving ... ");
	ld	hl,#_cx + 0
	ld	(hl), #0x4a
	ld	hl,#_cy + 0
	ld	(hl), #0x10
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_47
	push	hl
	call	_printf
;src/msg.c:65: wr_reg32(R_PARAM, MAGIC_CFG);
	ld	hl, #0x37c8
	ex	(sp),hl
	ld	hl, #0x55aa
	push	hl
	ld	a, #0xe3
	push	af
	inc	sp
	call	_wr_reg32
	pop	af
	pop	af
	inc	sp
;src/msg.c:66: wr_reg8(R_CMD, C_SAVE_CFG);
	ld	de, #0xeae1
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:67: wait_busy();
	call	_wait_busy
;src/msg.c:69: if (rd_reg8(R_ERROR) != E_DONE)
	ld	a, #0xe2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	dec	l
	jr	Z,00102$
;src/msg.c:71: color(C_ERR); printf("error 0x%02X", rd_reg8(R_ERROR));
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	a, #0xe2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	h, #0x00
	ld	bc, #___str_48+0
	push	hl
	push	bc
	call	_printf
	pop	af
	pop	af
;src/msg.c:72: return;
	ret
00102$:
;src/msg.c:76: color(C_OK); printf("ok\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_50
	push	hl
	call	_puts
	pop	af
;src/msg.c:78: }
	ret
___str_47:
	.ascii "Saving ... "
	.db 0x00
___str_48:
	.ascii "error 0x%02X"
	.db 0x00
___str_50:
	.ascii "ok"
	.db 0x00
;src/msg.c:80: void msg_fupd()
;	---------------------------------
; Function msg_fupd
; ---------------------------------
_msg_fupd::
;src/msg.c:82: fade();
	call	_fade
;src/msg.c:83: frame (32, 4, 30, 6, C_FRAM);
	ld	de, #0x0706
	push	de
	ld	de, #0x1e04
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:84: xy(60, 6); color(C_QUST); printf("You are about to flash");
	ld	hl,#_cx + 0
	ld	(hl), #0x3c
	ld	hl,#_cy + 0
	ld	(hl), #0x06
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	hl, #___str_51
	push	hl
	call	_printf
	pop	af
;src/msg.c:85: xy(60, 7); color (C_CRIT); printf("FIRMWARE ");
	ld	hl,#_cx + 0
	ld	(hl), #0x3c
	ld	hl,#_cy + 0
	ld	(hl), #0x07
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	hl, #___str_52
	push	hl
	call	_printf
	pop	af
;src/msg.c:86: color (C_QUST); printf("into the chip");
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	hl, #___str_53
	push	hl
	call	_printf
	pop	af
;src/msg.c:87: xy(98, 9); color(C_NORM); printf("Sure? (Y/N)");
	ld	hl,#_cx + 0
	ld	(hl), #0x62
	ld	hl,#_cy + 0
	ld	(hl), #0x09
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_54
	push	hl
	call	_printf
	pop	af
;src/msg.c:88: }
	ret
___str_51:
	.ascii "You are about to flash"
	.db 0x00
___str_52:
	.ascii "FIRMWARE "
	.db 0x00
___str_53:
	.ascii "into the chip"
	.db 0x00
___str_54:
	.ascii "Sure? (Y/N)"
	.db 0x00
;src/msg.c:90: void msg_fupd1()
;	---------------------------------
; Function msg_fupd1
; ---------------------------------
_msg_fupd1::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;src/msg.c:92: FW_HDR *fw = (FW_HDR*)fw_bin;
;src/msg.c:93: u32 fw_size = fw->size + fw->offs;
	ld	de, #_fw_bin + 8
	ld	hl, #0x0000
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	ld	hl, (#_fw_bin + 6)
	ld	de, #0x0000
	ld	a, -4 (ix)
	add	a, l
	ld	c, a
	ld	a, -3 (ix)
	adc	a, h
	ld	b, a
	ld	a, -2 (ix)
	adc	a, e
	ld	e, a
	ld	a, -1 (ix)
	adc	a, d
	ld	d, a
	ld	-4 (ix), c
	ld	-3 (ix), b
	ld	-2 (ix), e
	ld	-1 (ix), d
;src/msg.c:95: fade();
	call	_fade
;src/msg.c:96: frame (32, 13, 30, 4, C_FRAM);
	ld	de, #0x0704
	push	de
	ld	de, #0x1e0d
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	call	_frame
	pop	af
	pop	af
	inc	sp
;src/msg.c:99: color(C_NORM);
	ld	hl,#_cc + 0
	ld	(hl), #0x47
;src/msg.c:100: printf("Detect: ");
	ld	hl, #___str_55
	push	hl
	call	_printf
	pop	af
;src/msg.c:102: if (detect_chip())
	call	_detect_chip
	ld	a, l
	or	a, a
	jr	Z,00102$
;src/msg.c:104: color(C_OK); printf("found\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_57
	push	hl
	call	_puts
	pop	af
	jr	00103$
00102$:
;src/msg.c:108: color(C_ERR); printf("not found\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	hl, #___str_59
	push	hl
	call	_puts
	pop	af
;src/msg.c:109: return;
	jp	00115$
00103$:
;src/msg.c:113: color(C_NORM); printf("Check mode: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_60
	push	hl
	call	_printf
;src/msg.c:115: if (!(rd_reg8(R_STATUS) & S_BOOT))
	ld	h,#0xe1
	ex	(sp),hl
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	rlca
	jr	C,00105$
;src/msg.c:117: color(C_ERR); printf("restart in Boot\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	hl, #___str_62
	push	hl
	call	_puts
	pop	af
;src/msg.c:118: return;
	jp	00115$
00105$:
;src/msg.c:122: color(C_OK); printf("boot\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_64
	push	hl
	call	_puts
	pop	af
;src/msg.c:126: color(C_NORM); printf("Send f/w (%ub): ", fw_size);
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	push	hl
	ld	hl, #___str_65
	push	hl
	call	_printf
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;src/msg.c:127: wr_reg8(R_CMD, C_BREAK);
	xor	a, a
	ld	d,a
	ld	e,#0xe1
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:128: wr_reg32(R_PARAM, fw_size);
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	push	hl
	ld	a, #0xe3
	push	af
	inc	sp
	call	_wr_reg32
	pop	af
	pop	af
	inc	sp
;src/msg.c:129: wr_reg8(R_CMD, C_UP_FW);
	ld	de, #0xe8e1
	push	de
	call	_wr_reg8
;src/msg.c:131: if (!(rd_reg8(R_STATUS) & S_DRQ))
	ld	h,#0xe1
	ex	(sp),hl
	inc	sp
	call	_rd_reg8
	inc	sp
	bit	1, l
	jr	NZ,00108$
;src/msg.c:133: color(C_ERR); printf("DRQ err\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	hl, #___str_67
	push	hl
	call	_puts
	pop	af
;src/msg.c:134: return;
	jp	00115$
00108$:
;src/msg.c:138: wr_addr(R_DATA);
	ld	a, #0xe4
	push	af
	inc	sp
	call	_wr_addr
	inc	sp
;src/msg.c:139: wr_arrpg((void *)startPageAddress, fw_size);   //fw_bin
	pop	bc
	push	bc
	push	bc
	ld	hl, #0xc000
	push	hl
	call	_wr_arrpg
	pop	af
	pop	af
;src/msg.c:140: wait_busy();
	call	_wait_busy
;src/msg.c:142: if (rd_reg8(R_ERROR) != E_DONE)
	ld	a, #0xe2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	dec	l
	jr	Z,00110$
;src/msg.c:144: color(C_ERR); printf("error 0x%02X\n", rd_reg8(R_ERROR));
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	a, #0xe2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	h, #0x00
	ld	bc, #___str_68+0
	push	hl
	push	bc
	call	_printf
	pop	af
	pop	af
;src/msg.c:145: return;
	jr	00115$
00110$:
;src/msg.c:149: color(C_OK); printf("ok\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_70
	push	hl
	call	_puts
	pop	af
;src/msg.c:153: color(C_NORM); printf("Flash f/w: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_71
	push	hl
	call	_printf
;src/msg.c:154: wr_reg32(R_PARAM, MAGIC_FFW);
	ld	hl, #0x7841
	ex	(sp),hl
	ld	hl, #0xaa55
	push	hl
	ld	a, #0xe3
	push	af
	inc	sp
	call	_wr_reg32
	pop	af
	pop	af
	inc	sp
;src/msg.c:155: wr_reg8(R_CMD, C_FLASH_FW);
	ld	de, #0xe9e1
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:156: wait_busy();
	call	_wait_busy
;src/msg.c:158: if (rd_reg8(R_ERROR) != E_DONE)
	ld	a, #0xe2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	dec	l
	jr	Z,00113$
;src/msg.c:160: color(C_ERR); printf("error 0x%02X", rd_reg8(R_ERROR));
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	a, #0xe2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	h, #0x00
	ld	bc, #___str_72+0
	push	hl
	push	bc
	call	_printf
	pop	af
	pop	af
;src/msg.c:161: return;
	jr	00115$
00113$:
;src/msg.c:165: color(C_OK); printf("ok\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_70
	push	hl
	call	_puts
	pop	af
00115$:
;src/msg.c:167: }
	ld	sp, ix
	pop	ix
	ret
___str_55:
	.ascii "Detect: "
	.db 0x00
___str_57:
	.ascii "found"
	.db 0x00
___str_59:
	.ascii "not found"
	.db 0x00
___str_60:
	.ascii "Check mode: "
	.db 0x00
___str_62:
	.ascii "restart in Boot"
	.db 0x00
___str_64:
	.ascii "boot"
	.db 0x00
___str_65:
	.ascii "Send f/w (%ub): "
	.db 0x00
___str_67:
	.ascii "DRQ err"
	.db 0x00
___str_68:
	.ascii "error 0x%02X"
	.db 0x0a
	.db 0x00
___str_70:
	.ascii "ok"
	.db 0x00
___str_71:
	.ascii "Flash f/w: "
	.db 0x00
___str_72:
	.ascii "error 0x%02X"
	.db 0x00
;src/msg.c:170: void msg_info1()
;	---------------------------------
; Function msg_info1
; ---------------------------------
_msg_info1::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-11
	add	hl, sp
	ld	sp, hl
;src/msg.c:172: u32 f = rd_reg32(R_UPTIME);
	ld	a, #0xeb
	push	af
	inc	sp
	call	_rd_reg32
	inc	sp
	ld	c, l
	ld	b, h
;src/msg.c:175: ms = f % 1000;
	push	bc
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x03e8
	push	hl
	push	de
	push	bc
	call	__modulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-4 (ix), l
	ld	-3 (ix), h
	ld	-2 (ix), e
	ld	-1 (ix), d
	pop	de
	pop	bc
	ld	a, -4 (ix)
	ld	-7 (ix), a
	ld	a, -3 (ix)
	ld	-6 (ix), a
;src/msg.c:176: f /= 1000;
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x03e8
	push	hl
	push	de
	push	bc
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	c, l
	ld	b, h
;src/msg.c:177: s = f % 60;
	push	bc
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x003c
	push	hl
	push	de
	push	bc
	call	__modulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-11 (ix), l
	ld	-10 (ix), h
	ld	-9 (ix), e
	ld	-8 (ix), d
	pop	de
	pop	bc
	ld	a, -11 (ix)
	ld	-2 (ix), a
;src/msg.c:178: f /= 60;
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x003c
	push	hl
	push	de
	push	bc
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	c, l
	ld	b, h
;src/msg.c:179: m = f % 60;
	push	bc
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x003c
	push	hl
	push	de
	push	bc
	call	__modulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-11 (ix), l
	ld	-10 (ix), h
	ld	-9 (ix), e
	ld	-8 (ix), d
	pop	de
	pop	bc
	ld	a, -11 (ix)
	ld	-1 (ix), a
;src/msg.c:180: f /= 60;
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x003c
	push	hl
	push	de
	push	bc
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	c, l
	ld	b, h
;src/msg.c:181: h = f % 24;
	push	bc
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0018
	push	hl
	push	de
	push	bc
	call	__modulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-11 (ix), l
	ld	-10 (ix), h
	ld	-9 (ix), e
	ld	-8 (ix), d
	pop	de
	pop	bc
	ld	a, -11 (ix)
	ld	-5 (ix), a
;src/msg.c:182: d = f / 24;
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0018
	push	hl
	push	de
	push	bc
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ex	de, hl
;src/msg.c:184: xy(0, 21); color(C_NORM); printf("Uptime: ");
	ld	hl,#_cx + 0
	ld	(hl), #0x00
	ld	hl,#_cy + 0
	ld	(hl), #0x15
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	de
	ld	hl, #___str_74
	push	hl
	call	_printf
	pop	af
	pop	de
;src/msg.c:185: color(C_DATA); printf("%ud %uh %um %us %ums     ", d, h, m, s, ms);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	a, -2 (ix)
	ld	-4 (ix), a
	ld	-3 (ix), #0x00
	ld	a, -1 (ix)
	ld	-2 (ix), a
	ld	-1 (ix), #0x00
	ld	c, -5 (ix)
	ld	b, #0x00
	ld	d, #0x00
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	push	hl
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	push	hl
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	push	bc
	push	de
	ld	hl, #___str_75
	push	hl
	call	_printf
	ld	hl, #12
	add	hl, sp
	ld	sp, hl
;src/msg.c:186: }
	ld	sp, ix
	pop	ix
	ret
___str_74:
	.ascii "Uptime: "
	.db 0x00
___str_75:
	.ascii "%ud %uh %um %us %ums     "
	.db 0x00
;src/msg.c:188: void msg_info()
;	---------------------------------
; Function msg_info
; ---------------------------------
_msg_info::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-42
	add	hl, sp
	ld	sp, hl
;src/msg.c:195: cls();
	call	_cls
;src/msg.c:196: xy(90,1); color(C_HEAD); printf("Device Info");
	ld	hl,#_cx + 0
	ld	(hl), #0x5a
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_76
	push	hl
	call	_printf
;src/msg.c:198: f1 = rd_reg16(R_DEV_SIG);
	ld	h,#0xe0
	ex	(sp),hl
	inc	sp
	call	_rd_reg16
	inc	sp
	ld	c, l
	ld	b, h
;src/msg.c:199: xy(0, 4); color(C_NORM); printf("Device signature: ");
	ld	hl,#_cx + 0
	ld	(hl), #0x00
	ld	hl,#_cy + 0
	ld	(hl), #0x04
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	bc
	ld	hl, #___str_77
	push	hl
	call	_printf
	pop	af
	pop	bc
;src/msg.c:200: color(C_DATA); printf("%P\n\n", f1);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	push	bc
	push	bc
	ld	hl, #___str_78
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	bc
;src/msg.c:202: if (f1 == M_DEVSIG)
	ld	a, c
	sub	a, #0x55
	jr	NZ,00102$
	ld	a, b
	sub	a, #0xaa
	jr	NZ,00102$
;src/msg.c:203: unlock_chip();
	call	_unlock_chip
	jr	00103$
00102$:
;src/msg.c:206: color(C_ERR); printf("ERROR: chip not found!");
	ld	hl,#_cc + 0
	ld	(hl), #0x42
	ld	hl, #___str_79
	push	hl
	call	_printf
	pop	af
;src/msg.c:207: return;
	jp	00104$
00103$:
;src/msg.c:210: f = rd_reg32(R_CORE_FRQ) / 1000;
	ld	a, #0xef
	push	af
	inc	sp
	call	_rd_reg32
	inc	sp
	ld	c, l
	ld	b, h
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x03e8
	push	hl
	push	de
	push	bc
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	c, l
	ld	b, h
;src/msg.c:211: color(C_NORM); printf("Core frequency: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	bc
	push	de
	ld	hl, #___str_80
	push	hl
	call	_printf
	pop	af
	pop	de
	pop	bc
;src/msg.c:212: color(C_DATA); printf("%d.%03dMHz\n\n", f / 1000, f % 1000);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	push	bc
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x03e8
	push	hl
	push	de
	push	bc
	call	__modulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-4 (ix), l
	ld	-3 (ix), h
	ld	-2 (ix), e
	ld	-1 (ix), d
	pop	de
	pop	bc
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x03e8
	push	hl
	push	de
	push	bc
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	c, l
	ld	b, h
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	push	hl
	push	de
	push	bc
	ld	hl, #___str_81
	push	hl
	call	_printf
	ld	hl, #10
	add	hl, sp
	ld	sp, hl
;src/msg.c:214: msg_mode();
	call	_msg_mode
;src/msg.c:216: rd_reg_arr(R_VER, (u8*)&ver, sizeof(ver));
	ld	hl, #32
	add	hl, sp
	ex	de, hl
	ld	c, e
	ld	b, d
	push	de
	ld	hl, #0x0006
	push	hl
	push	bc
	ld	a, #0xec
	push	af
	inc	sp
	call	_rd_reg_arr
	pop	af
	pop	af
	inc	sp
	pop	de
;src/msg.c:217: color(C_NORM); printf("Hardware version: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	de
	ld	hl, #___str_82
	push	hl
	call	_printf
	pop	af
	pop	de
;src/msg.c:218: color(C_DATA); printf("%u\n", ver.hw);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	de
	push	bc
	ld	hl, #___str_83
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	de
;src/msg.c:219: color(C_NORM); printf("Firmware version: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	de
	ld	hl, #___str_84
	push	hl
	call	_printf
	pop	af
	pop	de
;src/msg.c:220: color(C_DATA); printf("%u\n", ver.fw);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	de
	push	bc
	ld	hl, #___str_83
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	de
;src/msg.c:221: color(C_NORM); printf("Config version: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	de
	ld	hl, #___str_85
	push	hl
	call	_printf
	pop	af
	pop	de
;src/msg.c:222: color(C_DATA); printf("%u\n\n", ver.cf);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ex	de,hl
	ld	de, #0x0004
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	hl, #___str_86
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:224: rd_reg_str(R_CPR_STR, s, sizeof(s));
	ld	hl, #0
	add	hl, sp
	ex	de, hl
	ld	c, e
	ld	b, d
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	push	bc
	ld	a, #0xed
	push	af
	inc	sp
	call	_rd_reg_str
	pop	af
	pop	af
	pop	de
;src/msg.c:225: color(C_NORM); printf("Info:  ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	de
	ld	hl, #___str_87
	push	hl
	call	_printf
	pop	af
	pop	de
;src/msg.c:226: color(C_DATA); printf("%s\n", s);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	c, e
	ld	b, d
	push	de
	push	bc
	ld	hl, #___str_88
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	de
;src/msg.c:228: rd_reg_str(R_BLD_STR, s, sizeof(s));
	ld	c, e
	ld	b, d
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	push	bc
	ld	a, #0xee
	push	af
	inc	sp
	call	_rd_reg_str
	pop	af
	pop	af
	pop	de
;src/msg.c:229: color(C_NORM); printf("Build: ");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	push	de
	ld	hl, #___str_89
	push	hl
	call	_printf
	pop	af
	pop	de
;src/msg.c:230: color(C_DATA); printf("%s", s);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	push	de
	ld	hl, #___str_90
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:232: task = msg_info1;
	ld	iy, #_task
	ld	0 (iy), #<(_msg_info1)
	ld	1 (iy), #>(_msg_info1)
00104$:
;src/msg.c:233: }
	ld	sp, ix
	pop	ix
	ret
___str_76:
	.ascii "Device Info"
	.db 0x00
___str_77:
	.ascii "Device signature: "
	.db 0x00
___str_78:
	.ascii "%P"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_79:
	.ascii "ERROR: chip not found!"
	.db 0x00
___str_80:
	.ascii "Core frequency: "
	.db 0x00
___str_81:
	.ascii "%d.%03dMHz"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_82:
	.ascii "Hardware version: "
	.db 0x00
___str_83:
	.ascii "%u"
	.db 0x0a
	.db 0x00
___str_84:
	.ascii "Firmware version: "
	.db 0x00
___str_85:
	.ascii "Config version: "
	.db 0x00
___str_86:
	.ascii "%u"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_87:
	.ascii "Info:  "
	.db 0x00
___str_88:
	.ascii "%s"
	.db 0x0a
	.db 0x00
___str_89:
	.ascii "Build: "
	.db 0x00
___str_90:
	.ascii "%s"
	.db 0x00
;src/msg.c:236: void msg_set()
;	---------------------------------
; Function msg_set
; ---------------------------------
_msg_set::
;src/msg.c:238: atb_sel.b = rd_reg8(R_PSG_ACTRL);
	ld	a, #0xd3
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	ld	(#_atb_sel),a
;src/msg.c:239: bus_sel.b = rd_reg8(R_PSG_BCTRL);
	ld	a, #0xd2
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	ld	(#_bus_sel),a
;src/msg.c:240: clk_sel.b = rd_reg8(R_PSG_CCTRL);
	ld	a, #0xd1
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	ld	(#_clk_sel),a
;src/msg.c:242: cls();
	call	_cls
;src/msg.c:243: xy(70,1); color(C_HEAD); printf("PSG and WS Settings");
	ld	hl,#_cx + 0
	ld	(hl), #0x46
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_91
	push	hl
	call	_printf
	pop	af
;src/msg.c:244: defx = 16; xy(defx, 4);
	ld	hl,#_defx + 0
	ld	(hl), #0x10
	ld	hl,#_cx + 0
	ld	(hl), #0x10
	ld	hl,#_cy + 0
	ld	(hl), #0x04
;src/msg.c:246: color(C_BUTN); printf("1. "); color(C_NORM); printf("Clock: "); color(C_SEL); printf("%s\n\n", clk_sel_txt[clk_sel.clksel]);
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_92
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_93
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	bc, #_clk_sel_txt+0
	ld	a, (#_clk_sel)
	and	a, #0x07
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	hl, #___str_94
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:247: color(C_BUTN); printf("2. "); color(C_NORM); printf("Multiple PSG mode: "); color(C_SEL); printf("%s\n\n", bus_sel_txt[bus_sel.psgmul]);
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_95
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_96
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	bc, #_bus_sel_txt+0
	ld	a, (#_bus_sel)
	and	a, #0x07
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	hl, #___str_94
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:248: color(C_BUTN); printf("3. "); color(C_NORM); printf("Set Channel Mixer\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_97
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_99
	push	hl
	call	_puts
	pop	af
;src/msg.c:249: color(C_BUTN); printf("4. "); color(C_NORM); printf("Set Amplitude Table\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_100
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_102
	push	hl
	call	_puts
	pop	af
;src/msg.c:250: color(C_BUTN); printf("5. "); color(C_NORM); printf("Custom Amplitude Table\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_103
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_105
	push	hl
	call	_puts
	pop	af
;src/msg.c:252: xy(defx, 20);
	ld	a,(#_defx + 0)
	ld	(#_cx + 0),a
	ld	hl,#_cy + 0
	ld	(hl), #0x14
;src/msg.c:253: color(C_BUTN); printf("S. "); color(C_NORM); printf("Save settings\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_106
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_108
	push	hl
	call	_puts
	pop	af
;src/msg.c:254: color(C_BUTN); printf("Enter. "); color(C_NORM); printf("Exit to main menu");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_109
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_110
	push	hl
	call	_printf
	pop	af
;src/msg.c:255: }
	ret
___str_91:
	.ascii "PSG and WS Settings"
	.db 0x00
___str_92:
	.ascii "1. "
	.db 0x00
___str_93:
	.ascii "Clock: "
	.db 0x00
___str_94:
	.ascii "%s"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_95:
	.ascii "2. "
	.db 0x00
___str_96:
	.ascii "Multiple PSG mode: "
	.db 0x00
___str_97:
	.ascii "3. "
	.db 0x00
___str_99:
	.ascii "Set Channel Mixer"
	.db 0x0a
	.db 0x00
___str_100:
	.ascii "4. "
	.db 0x00
___str_102:
	.ascii "Set Amplitude Table"
	.db 0x0a
	.db 0x00
___str_103:
	.ascii "5. "
	.db 0x00
___str_105:
	.ascii "Custom Amplitude Table"
	.db 0x0a
	.db 0x00
___str_106:
	.ascii "S. "
	.db 0x00
___str_108:
	.ascii "Save settings"
	.db 0x0a
	.db 0x00
___str_109:
	.ascii "Enter. "
	.db 0x00
___str_110:
	.ascii "Exit to main menu"
	.db 0x00
;src/msg.c:257: void msg_mix()
;	---------------------------------
; Function msg_mix
; ---------------------------------
_msg_mix::
;src/msg.c:261: cls();
	call	_cls
;src/msg.c:262: xy(90,1); color(C_HEAD); printf("Mixer Settings");
	ld	hl,#_cx + 0
	ld	(hl), #0x5a
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_111
	push	hl
	call	_printf
	pop	af
;src/msg.c:263: defx = 16; xy(defx, 4);
	ld	hl,#_defx + 0
	ld	(hl), #0x10
	ld	hl,#_cx + 0
	ld	(hl), #0x10
	ld	hl,#_cy + 0
	ld	(hl), #0x04
;src/msg.c:265: color(C_BUTN); printf("1. "); color(C_NORM); printf("Full stereo\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_112
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_114
	push	hl
	call	_puts
	pop	af
;src/msg.c:266: color(C_BUTN); printf("2. "); color(C_NORM); printf("Half stereo\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_115
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_117
	push	hl
	call	_puts
	pop	af
;src/msg.c:267: color(C_BUTN); printf("3. "); color(C_NORM); printf("Mono\n\n\n");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_118
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_120
	push	hl
	call	_puts
	pop	af
;src/msg.c:268: color(C_NORM); printf("Current settings:");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_121
	push	hl
	call	_printf
	pop	af
;src/msg.c:270: for (i = 0; i < 4; i++)
	ld	b, #0x00
00102$:
;src/msg.c:272: u8 x = i * 54 + 28;
	ld	a, b
	ld	e, a
	add	a, a
	add	a, e
	add	a, a
	add	a, a
	add	a, e
	add	a, a
	add	a, e
	add	a, a
	add	a, #0x1c
	ld	c, a
;src/msg.c:273: xy(x, 13); color(C_NORM); printf("PSG %d:", i);
	ld	hl,#_cx + 0
	ld	(hl), c
	ld	hl,#_cy + 0
	ld	(hl), #0x0d
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	e, b
	ld	d, #0x00
	push	bc
	push	de
	ld	hl, #___str_122
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	bc
;src/msg.c:274: color(C_SEL);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
;src/msg.c:275: wr_reg8(R_PSG_SEL, i);
	push	bc
	push	bc
	inc	sp
	ld	a, #0xd0
	push	af
	inc	sp
	call	_wr_reg8
	pop	af
	pop	bc
;src/msg.c:276: xy(x, 14); printf("%d/%d  ", rd_reg8(R_PSG_VOL_AL), rd_reg8(R_PSG_VOL_AR));
	ld	hl,#_cx + 0
	ld	(hl), c
	ld	hl,#_cy + 0
	ld	(hl), #0x0e
	push	bc
	ld	a, #0x11
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	pop	bc
	ld	h, #0x00
	push	hl
	push	bc
	ld	a, #0x10
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	e, l
	pop	bc
	pop	hl
	ld	d, #0x00
	push	bc
	push	hl
	push	de
	ld	hl, #___str_123
	push	hl
	call	_printf
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/msg.c:277: xy(x, 15); printf("%d/%d  ", rd_reg8(R_PSG_VOL_BL), rd_reg8(R_PSG_VOL_BR));
	ld	hl,#_cx + 0
	ld	(hl), c
	ld	hl,#_cy + 0
	ld	(hl), #0x0f
	push	bc
	ld	a, #0x13
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	pop	bc
	ld	h, #0x00
	push	hl
	push	bc
	ld	a, #0x12
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	e, l
	pop	bc
	pop	hl
	ld	d, #0x00
	push	bc
	push	hl
	push	de
	ld	hl, #___str_123
	push	hl
	call	_printf
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/msg.c:278: xy(x, 16); printf("%d/%d  ", rd_reg8(R_PSG_VOL_CL), rd_reg8(R_PSG_VOL_CR));
	ld	hl,#_cx + 0
	ld	(hl), c
	ld	hl,#_cy + 0
	ld	(hl), #0x10
	push	bc
	ld	a, #0x15
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	pop	bc
	ld	h, #0x00
	push	hl
	push	bc
	ld	a, #0x14
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	e, l
	pop	bc
	pop	hl
	ld	d, #0x00
	push	bc
	push	hl
	push	de
	ld	hl, #___str_123
	push	hl
	call	_printf
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/msg.c:270: for (i = 0; i < 4; i++)
	inc	b
	ld	a, b
	sub	a, #0x04
	jp	C, 00102$
;src/msg.c:281: xy(defx, 22);
	ld	a,(#_defx + 0)
	ld	(#_cx + 0),a
	ld	hl,#_cy + 0
	ld	(hl), #0x16
;src/msg.c:282: color(C_BUTN); printf("Enter. "); color(C_NORM); printf("Back");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_124
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_125
	push	hl
	call	_printf
	pop	af
;src/msg.c:283: }
	ret
___str_111:
	.ascii "Mixer Settings"
	.db 0x00
___str_112:
	.ascii "1. "
	.db 0x00
___str_114:
	.ascii "Full stereo"
	.db 0x0a
	.db 0x00
___str_115:
	.ascii "2. "
	.db 0x00
___str_117:
	.ascii "Half stereo"
	.db 0x0a
	.db 0x00
___str_118:
	.ascii "3. "
	.db 0x00
___str_120:
	.ascii "Mono"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_121:
	.ascii "Current settings:"
	.db 0x00
___str_122:
	.ascii "PSG %d:"
	.db 0x00
___str_123:
	.ascii "%d/%d  "
	.db 0x00
___str_124:
	.ascii "Enter. "
	.db 0x00
___str_125:
	.ascii "Back"
	.db 0x00
;src/msg.c:285: void msg_amp()
;	---------------------------------
; Function msg_amp
; ---------------------------------
_msg_amp::
;src/msg.c:288: atb_sel.b = rd_reg8(R_PSG_ACTRL);
	ld	a, #0xd3
	push	af
	inc	sp
	call	_rd_reg8
	inc	sp
	ld	a, l
	ld	(#_atb_sel),a
;src/msg.c:290: cls();
	call	_cls
;src/msg.c:291: xy(90,1); color(C_HEAD); printf("AmpTab Settings");
	ld	hl,#_cx + 0
	ld	(hl), #0x5a
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_126
	push	hl
	call	_printf
	pop	af
;src/msg.c:292: defx = 16; xy(defx, 4);
	ld	hl,#_defx + 0
	ld	(hl), #0x10
	ld	hl,#_cx + 0
	ld	(hl), #0x10
	ld	hl,#_cy + 0
	ld	(hl), #0x04
;src/msg.c:294: color(C_BUTN); printf("1. "); color(C_NORM); printf("%s\n\n", atab_sel_txt[0]);
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_127
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	bc, (#_atab_sel_txt + 0)
	push	bc
	ld	hl, #___str_128
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:295: color(C_BUTN); printf("2. "); color(C_NORM); printf("%s\n\n", atab_sel_txt[1]);
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_129
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, (#_atab_sel_txt + 2)
	push	hl
	ld	hl, #___str_128
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:296: color(C_BUTN); printf("3. "); color(C_NORM); printf("%s\n\n", atab_sel_txt[2]);
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_130
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, (#_atab_sel_txt + 4)
	push	hl
	ld	hl, #___str_128
	push	hl
	call	_printf
	pop	af
	pop	af
;src/msg.c:297: color(C_BUTN); printf("4. "); color(C_NORM); printf("%s\n\n\n", atab_sel_txt[3]);
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_131
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, (#_atab_sel_txt + 6)
	ld	bc, #___str_132+0
	push	hl
	push	bc
	call	_printf
	pop	af
	pop	af
;src/msg.c:298: color(C_NORM); printf("Current settings:");
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_133
	push	hl
	call	_printf
	pop	af
;src/msg.c:300: for (i = 0; i < 4; i++)
	ld	c, #0x00
00102$:
;src/msg.c:302: xy(defx, i + 15); color(C_NORM); printf("PSG %d: ", i);
	ld	a,(#_defx + 0)
	ld	(#_cx + 0),a
	ld	a, c
	add	a, #0x0f
	ld	(#_cy + 0),a
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	e, c
	ld	d, #0x00
	push	bc
	push	de
	ld	hl, #___str_134
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	bc
;src/msg.c:303: color(C_SEL); printf("%s", atab_sel_txt[(atb_sel.b >> (i * 2)) & 3]);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
	ld	hl, #_atb_sel + 0
	ld	e, (hl)
	ld	a, c
	add	a, a
	inc	a
	jr	00118$
00117$:
	srl	e
00118$:
	dec	a
	jr	NZ, 00117$
	ld	a, e
	and	a, #0x03
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	ld	de, #_atab_sel_txt
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	bc
	push	de
	ld	hl, #___str_135
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	bc
;src/msg.c:300: for (i = 0; i < 4; i++)
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	C,00102$
;src/msg.c:306: xy(defx, 22);
	ld	a,(#_defx + 0)
	ld	(#_cx + 0),a
	ld	hl,#_cy + 0
	ld	(hl), #0x16
;src/msg.c:307: color(C_BUTN); printf("Enter. "); color(C_NORM); printf("Back");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_136
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_137
	push	hl
	call	_printf
	pop	af
;src/msg.c:308: }
	ret
___str_126:
	.ascii "AmpTab Settings"
	.db 0x00
___str_127:
	.ascii "1. "
	.db 0x00
___str_128:
	.ascii "%s"
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_129:
	.ascii "2. "
	.db 0x00
___str_130:
	.ascii "3. "
	.db 0x00
___str_131:
	.ascii "4. "
	.db 0x00
___str_132:
	.ascii "%s"
	.db 0x0a
	.db 0x0a
	.db 0x0a
	.db 0x00
___str_133:
	.ascii "Current settings:"
	.db 0x00
___str_134:
	.ascii "PSG %d: "
	.db 0x00
___str_135:
	.ascii "%s"
	.db 0x00
___str_136:
	.ascii "Enter. "
	.db 0x00
___str_137:
	.ascii "Back"
	.db 0x00
;src/msg.c:310: void msg_cust_amp()
;	---------------------------------
; Function msg_cust_amp
; ---------------------------------
_msg_cust_amp::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;src/msg.c:314: cls();
	call	_cls
;src/msg.c:315: xy(58, 1); color(C_HEAD); printf("Custom amplitude table");
	ld	hl,#_cx + 0
	ld	(hl), #0x3a
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_138
	push	hl
	call	_printf
;src/msg.c:317: rd_reg_arr(R_PSG_AMP_TAB, (u8*)c_amp, sizeof(c_amp));
	ld	hl, #0x0040
	ex	(sp),hl
	ld	hl, #_c_amp
	push	hl
	ld	a, #0xd6
	push	af
	inc	sp
	call	_rd_reg_arr
	pop	af
	pop	af
	inc	sp
;src/msg.c:319: for (j = 0; j < 16; j++)
	ld	c, #0x00
;src/msg.c:320: for (k = 0; k < 2; k++)
00109$:
	ld	b, #0x00
00103$:
;src/msg.c:322: i = k * 16 + j;
	ld	l, b
	ld	a, l
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	ld	e, c
	add	a, e
	ld	-1 (ix), a
;src/msg.c:323: xy((k * 100) + 40, j + 4);
	push	de
	ld	a, l
	ld	e, a
	add	a, a
	add	a, e
	add	a, a
	add	a, a
	add	a, a
	add	a, e
	add	a, a
	add	a, a
	pop	de
	add	a, #0x28
	ld	(#_cx + 0),a
	ld	a, e
	add	a, #0x04
	ld	(#_cy + 0),a
;src/msg.c:324: color(C_NORM);
	ld	hl,#_cc + 0
	ld	(hl), #0x47
;src/msg.c:325: printf("%2u: ", i);
	ld	e, -1 (ix)
	ld	d, #0x00
	push	bc
	push	de
	push	de
	ld	hl, #___str_139
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	de
	pop	bc
;src/msg.c:326: color(C_DATA);
	ld	hl,#_cc + 0
	ld	(hl), #0x46
;src/msg.c:327: printf("%P", c_amp[i++]);
	ex	de,hl
	add	hl, hl
	ld	de, #_c_amp
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	bc
	push	de
	ld	hl, #___str_140
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	bc
;src/msg.c:320: for (k = 0; k < 2; k++)
	inc	b
	ld	a, b
	sub	a, #0x02
	jr	C,00103$
;src/msg.c:319: for (j = 0; j < 16; j++)
	inc	c
	ld	a, c
	sub	a, #0x10
	jr	C,00109$
;src/msg.c:330: xy(16, 22);
	ld	hl,#_cx + 0
	ld	(hl), #0x10
	ld	hl,#_cy + 0
	ld	(hl), #0x16
;src/msg.c:331: color(C_BUTN); printf("Enter. "); color(C_NORM); printf("Back");
	ld	hl,#_cc + 0
	ld	(hl), #0x44
	ld	hl, #___str_141
	push	hl
	call	_printf
	pop	af
	ld	hl,#_cc + 0
	ld	(hl), #0x47
	ld	hl, #___str_142
	push	hl
	call	_printf
	pop	af
;src/msg.c:332: }
	inc	sp
	pop	ix
	ret
___str_138:
	.ascii "Custom amplitude table"
	.db 0x00
___str_139:
	.ascii "%2u: "
	.db 0x00
___str_140:
	.ascii "%P"
	.db 0x00
___str_141:
	.ascii "Enter. "
	.db 0x00
___str_142:
	.ascii "Back"
	.db 0x00
;src/msg.c:334: void msg_set_b()
;	---------------------------------
; Function msg_set_b
; ---------------------------------
_msg_set_b::
;src/msg.c:336: bus_sel.psgmul++;
	ld	bc, #_bus_sel+0
	ld	l, c
	ld	h, b
	ld	a, (hl)
	and	a, #0x07
	inc	a
	and	a, #0x07
	ld	e, a
	ld	a, (hl)
	and	a, #0xf8
	or	a, e
	ld	(hl), a
;src/msg.c:337: if ((bus_sel.psgmul == 5) || (bus_sel.psgmul == 6)) bus_sel.psgmul = 7;
	ld	l, c
	ld	h, b
	ld	a, (hl)
	and	a, #0x07
	sub	a, #0x05
	jr	Z,00101$
	ld	l, c
	ld	h, b
	ld	a, (hl)
	and	a, #0x07
	sub	a, #0x06
	jr	NZ,00102$
00101$:
	ld	e, c
	ld	d, b
	ld	a, (de)
	or	a, #0x07
	ld	(de),a
00102$:
;src/msg.c:338: wr_reg8(R_PSG_BCTRL, bus_sel.b);
	ld	a, (bc)
	ld	d,a
	ld	e,#0xd2
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:339: }
	ret
;src/msg.c:341: void msg_set_c()
;	---------------------------------
; Function msg_set_c
; ---------------------------------
_msg_set_c::
;src/msg.c:343: clk_sel.clksel++;
	ld	hl, #_clk_sel
	ld	a, (hl)
	and	a, #0x07
	inc	a
	and	a, #0x07
	ld	c, a
	ld	a, (hl)
	and	a, #0xf8
	or	a, c
	ld	(hl), a
;src/msg.c:344: wr_reg8(R_PSG_CCTRL, clk_sel.b);
	ld	a, (#_clk_sel + 0)
	ld	d,a
	ld	e,#0xd1
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:345: }
	ret
;src/msg.c:347: void msg_mix_1()
;	---------------------------------
; Function msg_mix_1
; ---------------------------------
_msg_mix_1::
;src/msg.c:349: set_mix(0);
	xor	a, a
	push	af
	inc	sp
	call	_set_mix
	inc	sp
;src/msg.c:350: }
	ret
;src/msg.c:352: void msg_mix_2()
;	---------------------------------
; Function msg_mix_2
; ---------------------------------
_msg_mix_2::
;src/msg.c:354: set_mix(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_mix
	inc	sp
;src/msg.c:355: }
	ret
;src/msg.c:357: void msg_mix_3()
;	---------------------------------
; Function msg_mix_3
; ---------------------------------
_msg_mix_3::
;src/msg.c:359: set_mix(2);
	ld	a, #0x02
	push	af
	inc	sp
	call	_set_mix
	inc	sp
;src/msg.c:360: }
	ret
;src/msg.c:362: void msg_amp_1()
;	---------------------------------
; Function msg_amp_1
; ---------------------------------
_msg_amp_1::
;src/msg.c:364: atb_sel.ampsel0 = atb_sel.ampsel1 = atb_sel.ampsel2 = atb_sel.ampsel3 = 0;
	ld	bc, #_atb_sel+0
	ld	de, #_atb_sel+0
	ld	hl, #_atb_sel
	ld	a, (hl)
	and	a, #0x3f
	ld	(hl),a
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	rlca
	rlca
	and	a, #0x30
	ld	l, a
	ld	a, (de)
	and	a, #0xcf
	or	a, l
	ld	(de), a
	ex	de,hl
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	and	a, #0x0c
	ld	e, a
	ld	a, (bc)
	and	a, #0xf3
	or	a, e
	ld	(bc), a
	ld	l, c
	ld	h, b
	ld	a, (hl)
	rrca
	rrca
	and	a, #0x03
	ld	hl, #_atb_sel
	and	a, #0x03
	ld	c, a
	ld	a, (hl)
	and	a, #0xfc
	or	a, c
	ld	(hl), a
;src/msg.c:365: wr_reg8(R_PSG_ACTRL, atb_sel.b);
	ld	a, (#_atb_sel + 0)
	ld	d,a
	ld	e,#0xd3
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:366: }
	ret
;src/msg.c:368: void msg_amp_2()
;	---------------------------------
; Function msg_amp_2
; ---------------------------------
_msg_amp_2::
;src/msg.c:370: atb_sel.ampsel0 = atb_sel.ampsel1 = atb_sel.ampsel2 = atb_sel.ampsel3 = 1;
	ld	bc, #_atb_sel+0
	ld	de, #_atb_sel+0
	ld	hl, #_atb_sel
	ld	a, (hl)
	and	a, #0x3f
	or	a, #0x40
	ld	(hl),a
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	rlca
	rlca
	and	a, #0x30
	ld	l, a
	ld	a, (de)
	and	a, #0xcf
	or	a, l
	ld	(de), a
	ex	de,hl
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	and	a, #0x0c
	ld	e, a
	ld	a, (bc)
	and	a, #0xf3
	or	a, e
	ld	(bc), a
	ld	l, c
	ld	h, b
	ld	a, (hl)
	rrca
	rrca
	and	a, #0x03
	ld	hl, #_atb_sel
	and	a, #0x03
	ld	c, a
	ld	a, (hl)
	and	a, #0xfc
	or	a, c
	ld	(hl), a
;src/msg.c:371: wr_reg8(R_PSG_ACTRL, atb_sel.b);
	ld	a, (#_atb_sel + 0)
	ld	d,a
	ld	e,#0xd3
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:372: }
	ret
;src/msg.c:374: void msg_amp_3()
;	---------------------------------
; Function msg_amp_3
; ---------------------------------
_msg_amp_3::
;src/msg.c:376: atb_sel.ampsel0 = atb_sel.ampsel1 = atb_sel.ampsel2 = atb_sel.ampsel3 = 2;
	ld	bc, #_atb_sel+0
	ld	de, #_atb_sel+0
	ld	hl, #_atb_sel
	ld	a, (hl)
	and	a, #0x3f
	or	a, #0x80
	ld	(hl),a
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	rlca
	rlca
	and	a, #0x30
	ld	l, a
	ld	a, (de)
	and	a, #0xcf
	or	a, l
	ld	(de), a
	ex	de,hl
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	and	a, #0x0c
	ld	e, a
	ld	a, (bc)
	and	a, #0xf3
	or	a, e
	ld	(bc), a
	ld	l, c
	ld	h, b
	ld	a, (hl)
	rrca
	rrca
	and	a, #0x03
	ld	hl, #_atb_sel
	and	a, #0x03
	ld	c, a
	ld	a, (hl)
	and	a, #0xfc
	or	a, c
	ld	(hl), a
;src/msg.c:377: wr_reg8(R_PSG_ACTRL, atb_sel.b);
	ld	a, (#_atb_sel + 0)
	ld	d,a
	ld	e,#0xd3
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:378: }
	ret
;src/msg.c:380: void msg_amp_4()
;	---------------------------------
; Function msg_amp_4
; ---------------------------------
_msg_amp_4::
;src/msg.c:382: atb_sel.ampsel0 = atb_sel.ampsel1 = atb_sel.ampsel2 = atb_sel.ampsel3 = 3;
	ld	bc, #_atb_sel+0
	ld	de, #_atb_sel+0
	ld	hl, #_atb_sel
	ld	a, (hl)
	or	a, #0xc0
	ld	(hl),a
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	rlca
	rlca
	and	a, #0x30
	ld	l, a
	ld	a, (de)
	and	a, #0xcf
	or	a, l
	ld	(de), a
	ex	de,hl
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	a, #0x03
	rlca
	rlca
	and	a, #0x0c
	ld	e, a
	ld	a, (bc)
	and	a, #0xf3
	or	a, e
	ld	(bc), a
	ld	l, c
	ld	h, b
	ld	a, (hl)
	rrca
	rrca
	and	a, #0x03
	ld	hl, #_atb_sel
	and	a, #0x03
	ld	c, a
	ld	a, (hl)
	and	a, #0xfc
	or	a, c
	ld	(hl), a
;src/msg.c:383: wr_reg8(R_PSG_ACTRL, atb_sel.b);
	ld	a, (#_atb_sel + 0)
	ld	d,a
	ld	e,#0xd3
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:384: }
	ret
;src/msg.c:387: void msg_dac1()
;	---------------------------------
; Function msg_dac1
; ---------------------------------
_msg_dac1::
;src/msg.c:393: wr_reg8(R_DAC_VOL_L, 128 - v);
	ld	hl,#_msg_dac1_v_65536_142 + 0
	ld	c, (hl)
	ld	a, #0x80
	sub	a, c
	ld	d,a
	ld	e,#0x41
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:394: wr_reg8(R_DAC_VOL_R, v);
	ld	a, (_msg_dac1_v_65536_142)
	ld	d,a
	ld	e,#0x42
	push	de
	call	_wr_reg8
	pop	af
;src/msg.c:396: while (n--)
	ld	c, #0x0a
00101$:
	ld	a, c
	dec	c
	or	a, a
	jr	Z,00103$
;src/msg.c:397: play_wav((u8*)wav, sizeof(wav));
	push	bc
	ld	hl, #0x0064
	push	hl
	ld	hl, #_wav
	push	hl
	call	_play_wav
	pop	af
	pop	af
	pop	bc
	jr	00101$
00103$:
;src/msg.c:399: if (!d)
	ld	a,(#_msg_dac1_d_65536_142 + 0)
	or	a, a
	jr	NZ,00109$
;src/msg.c:401: v++;
	ld	iy, #_msg_dac1_v_65536_142
	inc	0 (iy)
;src/msg.c:402: if (v == 128) d = !d;
	ld	a, 0 (iy)
	sub	a, #0x80
	ret	NZ
	ld	iy, #_msg_dac1_d_65536_142
	ld	a, 0 (iy)
	sub	a,#0x01
	ld	a, #0x00
	rla
	ld	0 (iy), a
	ret
00109$:
;src/msg.c:406: v--;
	ld	iy, #_msg_dac1_v_65536_142
	dec	0 (iy)
;src/msg.c:407: if (v == 0) d = !d;
	ld	a, 0 (iy)
	or	a, a
	ret	NZ
	ld	iy, #_msg_dac1_d_65536_142
	ld	a, 0 (iy)
	sub	a,#0x01
	ld	a, #0x00
	rla
	ld	0 (iy), a
;src/msg.c:409: }
	ret
;src/msg.c:411: void msg_dac()
;	---------------------------------
; Function msg_dac
; ---------------------------------
_msg_dac::
;src/msg.c:414: cls();
	call	_cls
;src/msg.c:415: xy(104, 1); color(C_HEAD); printf("DAC test");
	ld	hl,#_cx + 0
	ld	(hl), #0x68
	ld	hl,#_cy + 0
	ld	(hl), #0x01
	ld	hl,#_cc + 0
	ld	(hl), #0x45
	ld	hl, #___str_143
	push	hl
	call	_printf
	pop	af
;src/msg.c:417: task = msg_dac1;
	ld	iy, #_task
	ld	0 (iy), #<(_msg_dac1)
	ld	1 (iy), #>(_msg_dac1)
;src/msg.c:418: }
	ret
___str_143:
	.ascii "DAC test"
	.db 0x00
;src/menu.c:2: void menu_disp()
;	---------------------------------
; Function menu_disp
; ---------------------------------
_menu_disp::
;src/menu.c:4: switch (menu)
	ld	a, #0x15
	ld	iy, #_menu
	sub	a, 0 (iy)
	ret	C
	ld	c, 0 (iy)
	ld	b, #0x00
	ld	hl, #00131$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00131$:
	jp	_msg_main
	jp	_msg_info
	jp	_msg_set
	jp	_msg_set_b
	jp	_msg_set_c
	jp	_msg_mix
	jp	_msg_mix_1
	jp	_msg_mix_2
	jp	_msg_mix_3
	jp	_msg_amp
	jp	_msg_amp_1
	jp	_msg_amp_2
	jp	_msg_amp_3
	jp	_msg_amp_4
	jp	_msg_cust_amp
	jp	_msg_dac
	jp	_msg_res
	jp	_msg_boot
	jp	_msg_save
	jp	_msg_save1
	jp	_msg_fupd
	jp	_msg_fupd1
;src/menu.c:6: case M_MAIN: msg_main(); break;
	jp  _msg_main
;src/menu.c:7: case M_INFO: msg_info(); break;
	jp  _msg_info
;src/menu.c:8: case M_SET: msg_set(); break;
	jp  _msg_set
;src/menu.c:9: case M_SET_B: msg_set_b(); break;
	jp  _msg_set_b
;src/menu.c:10: case M_SET_C: msg_set_c(); break;
	jp  _msg_set_c
;src/menu.c:11: case M_MIX: msg_mix(); break;
	jp  _msg_mix
;src/menu.c:12: case M_MIX_1: msg_mix_1(); break;
	jp  _msg_mix_1
;src/menu.c:13: case M_MIX_2: msg_mix_2(); break;
	jp  _msg_mix_2
;src/menu.c:14: case M_MIX_3: msg_mix_3(); break;
	jp  _msg_mix_3
;src/menu.c:15: case M_AMP: msg_amp(); break;
	jp  _msg_amp
;src/menu.c:16: case M_AMP_1: msg_amp_1(); break;
	jp  _msg_amp_1
;src/menu.c:17: case M_AMP_2: msg_amp_2(); break;
	jp  _msg_amp_2
;src/menu.c:18: case M_AMP_3: msg_amp_3(); break;
	jp  _msg_amp_3
;src/menu.c:19: case M_AMP_4: msg_amp_4(); break;
	jp  _msg_amp_4
;src/menu.c:20: case M_CUST_AMP: msg_cust_amp(); break;
	jp  _msg_cust_amp
;src/menu.c:21: case M_DAC: msg_dac(); break;
	jp  _msg_dac
;src/menu.c:22: case M_RES: msg_res(); break;
	jp  _msg_res
;src/menu.c:23: case M_BOOT: msg_boot(); break;
	jp  _msg_boot
;src/menu.c:24: case M_SAVE: msg_save(); break;
	jp  _msg_save
;src/menu.c:25: case M_SAVE1: msg_save1(); break;
	jp  _msg_save1
;src/menu.c:26: case M_FUPD: msg_fupd(); break;
	jp  _msg_fupd
;src/menu.c:27: case M_FUPD1: msg_fupd1(); break;
;src/menu.c:28: }
;src/menu.c:29: }
	jp  _msg_fupd1
;src/menu.c:31: bool key_disp()
;	---------------------------------
; Function key_disp
; ---------------------------------
_key_disp::
;src/menu.c:33: bool rc = false;
	ld	c, #0x00
;src/menu.c:34: u8 key = getkey();
	push	bc
	call	_getkey
	pop	bc
	ld	b, l
;src/menu.c:36: if (req_unpress)
	ld	iy, #_req_unpress
	ld	a, 0 (iy)
	or	a, a
	jr	Z,00158$
;src/menu.c:38: if (key == K_NONE)
	ld	a, b
	sub	a, #0x28
	jp	NZ,00159$
;src/menu.c:39: req_unpress = false;
	ld	0 (iy), #0x00
	jp	00159$
00158$:
;src/menu.c:41: else switch (menu)
	ld	a, #0x14
	ld	iy, #_menu
	sub	a, 0 (iy)
	jp	C, 00153$
	ld	e, 0 (iy)
	ld	d, #0x00
	ld	hl, #00319$
	add	hl, de
	add	hl, de
	add	hl, de
	jp	(hl)
00319$:
	jp	00103$
	jp	00153$
	jp	00111$
	jp	00121$
	jp	00121$
	jp	00122$
	jp	00137$
	jp	00137$
	jp	00137$
	jp	00128$
	jp	00141$
	jp	00141$
	jp	00141$
	jp	00141$
	jp	00142$
	jp	00153$
	jp	00153$
	jp	00153$
	jp	00145$
	jp	00153$
	jp	00149$
;src/menu.c:43: case M_MAIN:
00103$:
;src/menu.c:44: switch(key)
	ld	a,b
	cp	a,#0x0d
	jr	Z,00108$
	cp	a,#0x0f
	jr	Z,00104$
	cp	a,#0x10
	jr	Z,00105$
	cp	a,#0x11
	jr	Z,00106$
	cp	a,#0x1c
	jr	Z,00107$
	sub	a, #0x27
	jr	Z,00109$
	jp	00159$
;src/menu.c:46: case K_1: menu = M_INFO; rc = true; break;
00104$:
	ld	hl,#_menu + 0
	ld	(hl), #0x01
	ld	c, #0x01
	jp	00159$
;src/menu.c:47: case K_2: menu = M_SET; rc = true; break;
00105$:
	ld	hl,#_menu + 0
	ld	(hl), #0x02
	ld	c, #0x01
	jp	00159$
;src/menu.c:48: case K_3: menu = M_DAC; rc = true; break;
00106$:
	ld	hl,#_menu + 0
	ld	(hl), #0x0f
	ld	c, #0x01
	jp	00159$
;src/menu.c:49: case K_U: menu = M_FUPD; rc = true; break;
00107$:
	ld	hl,#_menu + 0
	ld	(hl), #0x14
	ld	c, #0x01
	jp	00159$
;src/menu.c:50: case K_R: menu = M_RES; rc = true; break;
00108$:
	ld	hl,#_menu + 0
	ld	(hl), #0x10
	ld	c, #0x01
	jp	00159$
;src/menu.c:51: case K_B: menu = M_BOOT; rc = true; break;
00109$:
	ld	hl,#_menu + 0
	ld	(hl), #0x11
	ld	c, #0x01
;src/menu.c:53: break;
	jp	00159$
;src/menu.c:55: case M_SET:
00111$:
;src/menu.c:56: switch(key)
	ld	a,b
	cp	a,#0x06
	jr	Z,00118$
	cp	a,#0x0f
	jr	Z,00112$
	cp	a,#0x10
	jr	Z,00113$
	cp	a,#0x11
	jr	Z,00114$
	cp	a,#0x12
	jr	Z,00115$
	cp	a,#0x13
	jr	Z,00116$
	sub	a, #0x1e
	jr	Z,00117$
	jp	00159$
;src/menu.c:58: case K_1: menu = M_SET_C; rc = true; break;
00112$:
	ld	hl,#_menu + 0
	ld	(hl), #0x04
	ld	c, #0x01
	jp	00159$
;src/menu.c:59: case K_2: menu = M_SET_B; rc = true; break;
00113$:
	ld	hl,#_menu + 0
	ld	(hl), #0x03
	ld	c, #0x01
	jp	00159$
;src/menu.c:60: case K_3: menu = M_MIX; rc = true; break;
00114$:
	ld	hl,#_menu + 0
	ld	(hl), #0x05
	ld	c, #0x01
	jp	00159$
;src/menu.c:61: case K_4: menu = M_AMP; rc = true; break;
00115$:
	ld	hl,#_menu + 0
	ld	(hl), #0x09
	ld	c, #0x01
	jp	00159$
;src/menu.c:62: case K_5: menu = M_CUST_AMP; rc = true; break;
00116$:
	ld	hl,#_menu + 0
	ld	(hl), #0x0e
	ld	c, #0x01
	jp	00159$
;src/menu.c:63: case K_EN: menu = M_MAIN; rc = true; break;
00117$:
	ld	hl,#_menu + 0
	ld	(hl), #0x00
	ld	c, #0x01
	jp	00159$
;src/menu.c:64: case K_S: menu = M_SAVE; rc = true; break;
00118$:
	ld	hl,#_menu + 0
	ld	(hl), #0x12
	ld	c, #0x01
;src/menu.c:66: break;
	jp	00159$
;src/menu.c:69: case M_SET_B:
00121$:
;src/menu.c:70: menu = M_SET; rc = true; break;
	ld	hl,#_menu + 0
	ld	(hl), #0x02
	ld	c, #0x01
	jp	00159$
;src/menu.c:73: case M_MIX:
00122$:
;src/menu.c:74: switch(key)
	ld	a,b
	cp	a,#0x0f
	jr	Z,00123$
	cp	a,#0x10
	jr	Z,00124$
	cp	a,#0x11
	jr	Z,00125$
	sub	a, #0x1e
	jr	Z,00126$
	jp	00159$
;src/menu.c:76: case K_1: menu = M_MIX_1; rc = true; break;
00123$:
	ld	hl,#_menu + 0
	ld	(hl), #0x06
	ld	c, #0x01
	jp	00159$
;src/menu.c:77: case K_2: menu = M_MIX_2; rc = true; break;
00124$:
	ld	hl,#_menu + 0
	ld	(hl), #0x07
	ld	c, #0x01
	jp	00159$
;src/menu.c:78: case K_3: menu = M_MIX_3; rc = true; break;
00125$:
	ld	hl,#_menu + 0
	ld	(hl), #0x08
	ld	c, #0x01
	jp	00159$
;src/menu.c:79: case K_EN: menu = M_SET; rc = true; break;
00126$:
	ld	hl,#_menu + 0
	ld	(hl), #0x02
	ld	c, #0x01
;src/menu.c:81: break;
	jp	00159$
;src/menu.c:83: case M_AMP:
00128$:
;src/menu.c:84: switch(key)
	ld	a, b
	sub	a, #0x0f
	jr	Z,00129$
	ld	a,b
	cp	a,#0x10
	jr	Z,00130$
	cp	a,#0x11
	jr	Z,00131$
	cp	a,#0x12
	jr	Z,00132$
	sub	a, #0x1e
	jr	Z,00133$
	jp	00159$
;src/menu.c:86: case K_1: menu = M_AMP_1; rc = true; break;
00129$:
	ld	hl,#_menu + 0
	ld	(hl), #0x0a
	ld	c, #0x01
	jp	00159$
;src/menu.c:87: case K_2: menu = M_AMP_2; rc = true; break;
00130$:
	ld	hl,#_menu + 0
	ld	(hl), #0x0b
	ld	c, #0x01
	jp	00159$
;src/menu.c:88: case K_3: menu = M_AMP_3; rc = true; break;
00131$:
	ld	hl,#_menu + 0
	ld	(hl), #0x0c
	ld	c, #0x01
	jp	00159$
;src/menu.c:89: case K_4: menu = M_AMP_4; rc = true; break;
00132$:
	ld	hl,#_menu + 0
	ld	(hl), #0x0d
	ld	c, #0x01
	jp	00159$
;src/menu.c:90: case K_EN: menu = M_SET; rc = true; break;
00133$:
	ld	hl,#_menu + 0
	ld	(hl), #0x02
	ld	c, #0x01
;src/menu.c:92: break;
	jr	00159$
;src/menu.c:96: case M_MIX_3:
00137$:
;src/menu.c:97: menu = M_MIX; rc = true;
	ld	hl,#_menu + 0
	ld	(hl), #0x05
	ld	c, #0x01
;src/menu.c:98: break;
	jr	00159$
;src/menu.c:103: case M_AMP_4:
00141$:
;src/menu.c:104: menu = M_AMP; rc = true;
	ld	hl,#_menu + 0
	ld	(hl), #0x09
	ld	c, #0x01
;src/menu.c:105: break;
	jr	00159$
;src/menu.c:107: case M_CUST_AMP:
00142$:
;src/menu.c:108: switch(key)
	ld	a, b
	sub	a, #0x1e
	jr	NZ,00159$
;src/menu.c:110: case K_EN: menu = M_SET; rc = true; break;
	ld	hl,#_menu + 0
	ld	(hl), #0x02
	ld	c, #0x01
;src/menu.c:112: break;
	jr	00159$
;src/menu.c:114: case M_SAVE:
00145$:
;src/menu.c:115: switch (key)
	ld	a,b
	cp	a,#0x1d
	jr	Z,00146$
	sub	a, #0x26
	jr	Z,00147$
	jr	00159$
;src/menu.c:117: case K_Y: menu = M_SAVE1; rc = true; break;
00146$:
	ld	hl,#_menu + 0
	ld	(hl), #0x13
	ld	c, #0x01
	jr	00159$
;src/menu.c:118: case K_N: menu = M_SET; rc = true; break;
00147$:
	ld	hl,#_menu + 0
	ld	(hl), #0x02
	ld	c, #0x01
;src/menu.c:120: break;
	jr	00159$
;src/menu.c:122: case M_FUPD:
00149$:
;src/menu.c:123: switch (key)
	ld	a,b
	cp	a,#0x1d
	jr	Z,00150$
	sub	a, #0x26
	jr	Z,00151$
	jr	00159$
;src/menu.c:125: case K_Y: menu = M_FUPD1; rc = true; break;
00150$:
	ld	hl,#_menu + 0
	ld	(hl), #0x15
	ld	c, #0x01
	jr	00159$
;src/menu.c:126: case K_N: menu = M_MAIN; rc = true; break;
00151$:
	ld	hl,#_menu + 0
	ld	(hl), #0x00
	ld	c, #0x01
;src/menu.c:128: break;
	jr	00159$
;src/menu.c:130: default:
00153$:
;src/menu.c:131: if (key != K_NONE)
	ld	a, b
	sub	a, #0x28
	jr	Z,00159$
;src/menu.c:132: { menu = M_MAIN; rc = true; break; }
	ld	hl,#_menu + 0
	ld	(hl), #0x00
	ld	c, #0x01
;src/menu.c:133: }
00159$:
;src/menu.c:135: return rc;
	ld	l, c
;src/menu.c:136: }
	ret
;src/main.c:18: void t_none() {}
;	---------------------------------
; Function t_none
; ---------------------------------
_t_none::
	ret
;src/main.c:20: void crt_init()
;	---------------------------------
; Function crt_init
; ---------------------------------
_crt_init::
;src/main.c:22: menu = M_MAIN;
	ld	hl,#_menu + 0
	ld	(hl), #0x00
;src/main.c:23: }
	ret
;src/main.c:25: void main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
;src/main.c:27: crt_init();
	call	_crt_init
;src/main.c:29: border(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_border
	inc	sp
;src/main.c:31: while (1)
00107$:
;src/main.c:33: req_unpress = true;
	ld	hl,#_req_unpress + 0
	ld	(hl), #0x01
;src/main.c:34: task = t_none;
	ld	iy, #_task
	ld	0 (iy), #<(_t_none)
	ld	1 (iy), #>(_t_none)
;src/main.c:35: menu_disp();
	call	_menu_disp
;src/main.c:37: while (1)
00104$:
;src/main.c:39: task();
	ld	hl, (_task)
	call	___sdcc_call_hl
;src/main.c:40: if (key_disp())
	call	_key_disp
	ld	a, l
	or	a, a
	jr	Z,00104$
;src/main.c:41: break;
;src/main.c:44: }
	jr	00107$
	.area _CODE
	.area _INITIALIZER
__xinit__fw_bin_len:
	.dw #0xc70c
	.area _CABS (ABS)
