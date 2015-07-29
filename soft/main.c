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

void main(void) {
  int j;
  char i;
  
  while (1) {
    /* Rotate the LEDs */
    for (i = 1; ; ++i) {
      *leds=i;
      
      /* Each loop iteration takes 4 cycles.
       * It runs at 125MHz.
       * Sleep 0.2 second.
       */
      for (j = 0; j < 12500000/4/5; ++j) {
        asm("# noop"); /* no-op the compiler can't optimize away */
        //int a = fb[0];
        }
    int k = 0;
    for (k=0;k<0x80;k++) {
        draw_pixel(0, 3, 1);
        draw_pixel(1, 4, 1);
        draw_pixel(2, 5, 1);
        draw_pixel(3, 30, 1);
        draw_pixel(4, 40, 1);
        draw_pixel(5, 50, 1);
        draw_pixel(6, 50, 1);
        draw_pixel(7, 50, 1);
        draw_pixel(8, 40, 1);
        draw_pixel(9, 40, 1);
        draw_pixel(10, 40, 1);
        draw_pixel(11, 40, 1);
      }
    }
  }
}
