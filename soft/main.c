volatile unsigned char* leds = (unsigned char*)0x80000000;
volatile unsigned char* fb = (unsigned char*)0x1000;

void _irq_entry(void) {
  /* Currently only triggered by DMA completion */
}





void draw_pixel(int row, int col, int val) {
    fb[row+col] = val;
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
    for (k=0;k<100;k++) {
        draw_pixel(k, k, 1);

      }
    }
  }
}
