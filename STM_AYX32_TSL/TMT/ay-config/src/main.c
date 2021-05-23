
#include <stdio.h>
#include <string.h>
#include "defs.h"
const
#include "../res/font6x8.h"
const
#include "../res/wav.h"
#include "screen.c"
#include "ayx32.c"
#include "kbd.c"
#include "func.c"
const
#include "../res/fw.h"
#include "msg.c"
#include "menu.c"

void t_none() {}

void crt_init()
{
  menu = M_MAIN;
}

void main()
{
  crt_init();

  border(1);
  //wr_pag_init();
  while (1)
  {
    req_unpress = true;
    task = t_none;
    menu_disp();

    while (1)
    {
      task();
      if (key_disp())
        break;
    }
  }
}
