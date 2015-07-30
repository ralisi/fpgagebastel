volatile unsigned char* leds = (unsigned char*)0x80000000;
volatile unsigned char* fb = (unsigned char*)0x40000000;

void _irq_entry(void) {
  /* Currently only triggered by DMA completion */
}



void draw_pixel(int row, int col, int val) {
    int offset = col + 128*row;
    if (offset > 0x7fff)
        return;
    fb[offset] = val;
}


void setScreen(char val) {
    int i;
    for (i=0;i<0x7fff;i++)
        fb[i]=~val;

    for(i=0;i<120;i++)
        memset(&fb[i*128], val, i);


    return;
}

void main(void) {
  int j;
  char i;
  
  while (1) {
    /* Rotate the LEDs */
    for (i = 1; ; ++i) {
      *leds=i;
      setScreen(i);
      
      /* Each loop iteration takes 4 cycles.
       * It runs at 125MHz.
       * Sleep 0.2 second.
       */
      for (j = 0; j < 125000000/4/5; ++j) {
        asm("# noop"); /* no-op the compiler can't optimize away */
        }
    }
  }
}
