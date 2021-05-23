(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Library Functions                    *)
(*       Based on dlgs.h                                        *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Dlgs;

(*+++
Abstract:

    This module contains the UI dialog header information.
---*)

interface

const

//
//  Constant Declarations.
//
  ctlFirst = $0400;
  ctlLast = $04ff;

//
//  Push buttons.
//
  psh1 = $0400;
  psh2 = $0401;
  psh3 = $0402;
  psh4 = $0403;
  psh5 = $0404;
  psh6 = $0405;
  psh7 = $0406;
  psh8 = $0407;
  psh9 = $0408;
  psh10 = $0409;
  psh11 = $040a;
  psh12 = $040b;
  psh13 = $040c;
  psh14 = $040d;
  psh15 = $040e;
  pshHelp = psh15;
  psh16 = $040f;

//
//  Checkboxes.
//
  chx1 = $0410;
  chx2 = $0411;
  chx3 = $0412;
  chx4 = $0413;
  chx5 = $0414;
  chx6 = $0415;
  chx7 = $0416;
  chx8 = $0417;
  chx9 = $0418;
  chx10 = $0419;
  chx11 = $041a;
  chx12 = $041b;
  chx13 = $041c;
  chx14 = $041d;
  chx15 = $041e;
  chx16 = $041f;

//
//  Radio buttons.
//
  rad1 = $0420;
  rad2 = $0421;
  rad3 = $0422;
  rad4 = $0423;
  rad5 = $0424;
  rad6 = $0425;
  rad7 = $0426;
  rad8 = $0427;
  rad9 = $0428;
  rad10 = $0429;
  rad11 = $042a;
  rad12 = $042b;
  rad13 = $042c;
  rad14 = $042d;
  rad15 = $042e;
  rad16 = $042f;

//
//  Groups, frames, rectangles, and icons.
//
  grp1 = $0430;
  grp2 = $0431;
  grp3 = $0432;
  grp4 = $0433;
  frm1 = $0434;
  frm2 = $0435;
  frm3 = $0436;
  frm4 = $0437;
  rct1 = $0438;
  rct2 = $0439;
  rct3 = $043a;
  rct4 = $043b;
  ico1 = $043c;
  ico2 = $043d;
  ico3 = $043e;
  ico4 = $043f;

//
//  Static text.
//
  stc1 = $0440;
  stc2 = $0441;
  stc3 = $0442;
  stc4 = $0443;
  stc5 = $0444;
  stc6 = $0445;
  stc7 = $0446;
  stc8 = $0447;
  stc9 = $0448;
  stc10 = $0449;
  stc11 = $044a;
  stc12 = $044b;
  stc13 = $044c;
  stc14 = $044d;
  stc15 = $044e;
  stc16 = $044f;
  stc17 = $0450;
  stc18 = $0451;
  stc19 = $0452;
  stc20 = $0453;
  stc21 = $0454;
  stc22 = $0455;
  stc23 = $0456;
  stc24 = $0457;
  stc25 = $0458;
  stc26 = $0459;
  stc27 = $045a;
  stc28 = $045b;
  stc29 = $045c;
  stc30 = $045d;
  stc31 = $045e;
  stc32 = $045f;

//
//  Listboxes.
//
  lst1 = $0460;
  lst2 = $0461;
  lst3 = $0462;
  lst4 = $0463;
  lst5 = $0464;
  lst6 = $0465;
  lst7 = $0466;
  lst8 = $0467;
  lst9 = $0468;
  lst10 = $0469;
  lst11 = $046a;
  lst12 = $046b;
  lst13 = $046c;
  lst14 = $046d;
  lst15 = $046e;
  lst16 = $046f;

//
//  Combo boxes.
//
  cmb1 = $0470;
  cmb2 = $0471;
  cmb3 = $0472;
  cmb4 = $0473;
  cmb5 = $0474;
  cmb6 = $0475;
  cmb7 = $0476;
  cmb8 = $0477;
  cmb9 = $0478;
  cmb10 = $0479;
  cmb11 = $047a;
  cmb12 = $047b;
  cmb13 = $047c;
  cmb14 = $047d;
  cmb15 = $047e;
  cmb16 = $047f;

//
//  Edit controls.
//
  edt1 = $0480;
  edt2 = $0481;
  edt3 = $0482;
  edt4 = $0483;
  edt5 = $0484;
  edt6 = $0485;
  edt7 = $0486;
  edt8 = $0487;
  edt9 = $0488;
  edt10 = $0489;
  edt11 = $048a;
  edt12 = $048b;
  edt13 = $048c;
  edt14 = $048d;
  edt15 = $048e;
  edt16 = $048f;

//
//  Scroll bars.
//
  scr1 = $0490;
  scr2 = $0491;
  scr3 = $0492;
  scr4 = $0493;
  scr5 = $0494;
  scr6 = $0495;
  scr7 = $0496;
  scr8 = $0497;

//
//  These dialog resource ordinals really start at 0x0600, but the
//  RC Compiler can't handle hex for resource IDs, hence the decimal.
//
  FILEOPENORD = 1536;
  MULTIFILEOPENORD = 1537;
  PRINTDLGORD = 1538;
  PRNSETUPDLGORD = 1539;
  FINDDLGORD = 1540;
  REPLACEDLGORD = 1541;
  FONTDLGORD = 1542;
  FORMATDLGORD31 = 1543;
  FORMATDLGORD30 = 1544;
  PAGESETUPDLGORD = 1546;
  NEWFILEOPENORD = 1547;

//
//  Typedef Declarations.
//
type
  tagCRGB = record
    bRed:   BYTE;
    bGreen: BYTE;
    bBlue:  BYTE;
    bExtra: BYTE;
  end;
  CRGB = tagCRGB; /* RGB Color */

implementation

end.

