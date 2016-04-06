//+------------------------------------------------------------------+
//|                                           MultiInstrument_YK.mq4 |
//|                               Copyright © 2010, Vladimir Hlystov |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Vladimir Hlystov"
#property link      "http://cmillion.narod.ru"
//выводит 4 инструмента в текущее окно

//#property indicator_chart_window
#property indicator_separate_window
#property indicator_buffers 5

#property indicator_color1 C'0xFF,0x00,0x00'
#property indicator_color2 C'0xFF,0x80,0x00'
#property indicator_color3 C'0xFF,0xFF,0x00'
#property indicator_color4 C'0x80,0xFF,0x00'
#property indicator_color5 C'0x00,0xFF,0x00'
#property indicator_color6 C'0x00,0xFF,0x80'
#property indicator_color7 C'0x00,0xFF,0xFF'
#property indicator_color8 C'0x00,0x80,0xFF'
#property indicator_color9 C'0x00,0x00,0xFF'
#property indicator_color10 C'0x80,0x00,0xFF'
#property indicator_color11 C'0xFF,0x00,0xFF'
#property indicator_color12 C'0xFF,0x00,0x80'
#property indicator_color13 C'0x66,0x66,0x66'
#property indicator_color14 C'0x88,0x88,0x88'
#property indicator_color15 C'0xAA,0xAA,0xAA'
#property indicator_color16 C'0xCC,0xCC,0xCC'
#property indicator_color17 C'0xFF,0xFF,0xFF'

#property indicator_level1    1.0
/*#property indicator_minimum    1.995
#property indicator_maximum    2.005*/
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

extern int ControlBars = 500;       //колличество контроллируемых свечей
extern int mid           = 10;      //усреднение
double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];
double Buffer_6[];
double Buffer_7[];
double Buffer_8[];
double Buffer_9[];
double Buffer_10[];
double Buffer_11[];
double Buffer_12[];
double Buffer_13[];
double Buffer_14[];
double Buffer_15[];
double Buffer_16[];

int col_added_valutes[17];

string valutes[17] = {"EUR", "GBP", "AUD", "NZD", "USD", "CAD", "CHF", "CZK", "DKK", "HKD", "HUF", "MXN", "NOK", "SEK", "SGD", "ZAR", "JPY"};
int cnt = 400,i, k, j, m, size = ArraySize(valutes);

//+------------------------------------------------------------------+
int init()  {
   Comment("");

   SetIndexBuffer(0,Buffer_0);
   SetIndexBuffer(1,Buffer_1);
   SetIndexBuffer(2,Buffer_2);
   SetIndexBuffer(3,Buffer_3);
   SetIndexBuffer(4,Buffer_4);
   SetIndexBuffer(5,Buffer_5);
   SetIndexBuffer(6,Buffer_6);
   /*SetIndexBuffer(7,Buffer_7);
   SetIndexBuffer(8,Buffer_8);
   SetIndexBuffer(9,Buffer_9);
   SetIndexBuffer(10,Buffer_10);
   SetIndexBuffer(11,Buffer_11);
   SetIndexBuffer(12,Buffer_12);
   SetIndexBuffer(13,Buffer_13);
   SetIndexBuffer(14,Buffer_14);
   SetIndexBuffer(15,Buffer_15);*/
   SetIndexBuffer(16,Buffer_16);
   
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);   
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexStyle(7,DRAW_LINE);   
   SetIndexStyle(8,DRAW_LINE);
   SetIndexStyle(9,DRAW_LINE);
   SetIndexStyle(10,DRAW_LINE);
   SetIndexStyle(11,DRAW_LINE);   
   SetIndexStyle(12,DRAW_LINE);
   SetIndexStyle(13,DRAW_LINE);
   SetIndexStyle(14,DRAW_LINE);
   SetIndexStyle(15,DRAW_LINE);
   SetIndexStyle(16,DRAW_LINE);
   
   for (i=0; i<16; i++) {
      SetIndexLabel(i,valutes[i]);
   }   
   
   return(0);
  }
  
  
int getIndexOfArray(string str) {
   for (i=0; i<size; i++) {
      if (str == valutes[i]) return i;
   }
   return -1;
}

//+------------------------------------------------------------------+
int start() {

   double max = 0, min = 1, tmp;
   int res, max_i, min_i;
   string valuta, str = "";
   MqlRates s1[];
   ArraySetAsSeries(s1,true);
   
   for (k=0; k<cnt-(mid+1); k++) {
      Buffer_0[k]  = 0;
      Buffer_1[k]  = 0;
      Buffer_2[k]  = 0;
      Buffer_3[k]  = 0;
	   Buffer_4[k]  = 0;
	   Buffer_5[k]  = 0;
	   Buffer_6[k]  = 0;
	   Buffer_7[k]  = 0;
	   Buffer_8[k]  = 0;
	   Buffer_9[k]  = 0;
	   Buffer_10[k] = 0;
	   Buffer_11[k] = 0;
	   Buffer_12[k] = 0;
	   Buffer_13[k] = 0;
	   Buffer_14[k] = 0;
	   Buffer_15[k] = 0;
	   Buffer_16[k] = 0;	  
   }   
   
   for (i=0; i<17; i++) {
      col_added_valutes[i] = 0;
   }

   for (i=0; i<16; i++) {
      for (k=i+1; k<size; k++) {
         valuta = valutes[i] + valutes[k]; // Валюта 
         res = CopyRates(valuta, 0, 0, cnt, s1);                        
         
         if (res != -1) {             
                  
            if       (i == 0)  col_added_valutes[0]++;
            else if  (i == 1)  col_added_valutes[1]++;
            else if  (i == 2)  col_added_valutes[2]++;
            else if  (i == 3)  col_added_valutes[3]++;
            else if  (i == 4)  col_added_valutes[4]++;
            else if  (i == 5)  col_added_valutes[5]++;
            else if  (i == 6)  col_added_valutes[6]++;
            else if  (i == 7)  col_added_valutes[7]++;
            else if  (i == 8)  col_added_valutes[8]++;
            else if  (i == 9)  col_added_valutes[9]++;
            else if  (i == 10) col_added_valutes[10]++;
            else if  (i == 11) col_added_valutes[11]++;
            else if  (i == 12) col_added_valutes[12]++;
            else if  (i == 13) col_added_valutes[13]++;
            else if  (i == 14) col_added_valutes[14]++;
            else if  (i == 15) col_added_valutes[15]++;
                  
            if       (k == 1)  col_added_valutes[1]++;
            else if  (k == 2)  col_added_valutes[2]++;
            else if  (k == 3)  col_added_valutes[3]++;
            else if  (k == 4)  col_added_valutes[4]++;
            else if  (k == 5)  col_added_valutes[5]++;
            else if  (k == 6)  col_added_valutes[6]++;
            else if  (k == 7)  col_added_valutes[7]++;
            else if  (k == 8)  col_added_valutes[8]++;
            else if  (k == 9)  col_added_valutes[9]++;
            else if  (k == 10) col_added_valutes[10]++;
            else if  (k == 11) col_added_valutes[11]++;
            else if  (k == 12) col_added_valutes[12]++;
            else if  (k == 13) col_added_valutes[13]++;
            else if  (k == 14) col_added_valutes[14]++;
            else if  (k == 15) col_added_valutes[15]++;
            else if  (k == 16) col_added_valutes[16]++;
            
                   
            for (m=0; m<cnt-(mid+1); m++) {
               tmp = 0;
               for (j=1; j<=mid; j++) {
                  tmp += (s1[m+j].close);
               }
               tmp /= mid;
               
               double tmp_1 = tmp / s1[m].close;
               double tmp_2 = s1[m].close / tmp;
               
               if       (i == 0)  Buffer_0[m] += tmp_1;
   			   else if  (i == 1)  Buffer_1[m] += tmp_1;
   			   else if  (i == 2)  Buffer_2[m] += tmp_1;
   			   else if  (i == 3)  Buffer_3[m] += tmp_1;
   			   else if  (i == 4)  Buffer_4[m] += tmp_1;
   			   else if  (i == 5)  Buffer_5[m] += tmp_1;
   			   else if  (i == 6)  Buffer_6[m] += tmp_1;
   			   else if  (i == 7)  Buffer_7[m] += tmp_1;
   			   else if  (i == 8)  Buffer_8[m] += tmp_1;
   			   else if  (i == 9)  Buffer_9[m] += tmp_1;
   			   else if  (i == 10) Buffer_10[m] += tmp_1;
   			   else if  (i == 11) Buffer_11[m] += tmp_1;
   			   else if  (i == 12) Buffer_12[m] += tmp_1;
   			   else if  (i == 13) Buffer_13[m] += tmp_1;
   			   else if  (i == 14) Buffer_14[m] += tmp_1;
   			   else if  (i == 15) Buffer_15[m] += tmp_1;
   			   	  
   			   if       (k == 1)  Buffer_1[m] += tmp_2;
   			   else if  (k == 2)  Buffer_2[m] += tmp_2;
   			   else if  (k == 3)  Buffer_3[m] += tmp_2;
   			   else if  (k == 4)  Buffer_4[m] += tmp_2;
   			   else if  (k == 5)  Buffer_5[m] += tmp_2;
   			   else if  (k == 6)  Buffer_6[m] += tmp_2;
   			   else if  (k == 7)  Buffer_7[m] += tmp_2;
   			   else if  (k == 8)  Buffer_8[m] += tmp_2;
   			   else if  (k == 9)  Buffer_9[m] += tmp_2;
   			   else if  (k == 10) Buffer_10[m] += tmp_2;
   			   else if  (k == 11) Buffer_11[m] += tmp_2;
   			   else if  (k == 12) Buffer_12[m] += tmp_2;
   			   else if  (k == 13) Buffer_13[m] += tmp_2;
   			   else if  (k == 14) Buffer_14[m] += tmp_2;
   			   else if  (k == 15) Buffer_15[m] += tmp_2;
   			   else if  (k == 16) Buffer_16[m] += tmp_2;                 
            }  
         }
      }
   }   
   
   Comment(col_added_valutes[0], "  ", col_added_valutes[1], "  ", col_added_valutes[2], "  ", col_added_valutes[3]);
   for (k=0; k<cnt-(mid+1); k++) {
      Buffer_0[k] /= col_added_valutes[0];
      Buffer_1[k] /= col_added_valutes[1];
      Buffer_2[k] /= col_added_valutes[2];
      Buffer_3[k] /= col_added_valutes[3];
      Buffer_4[k] /= col_added_valutes[4];
      Buffer_5[k] /= col_added_valutes[5];
      Buffer_6[k] /= col_added_valutes[6];
      Buffer_7[k] /= col_added_valutes[7];
      Buffer_8[k] /= col_added_valutes[8];
      Buffer_9[k] /= col_added_valutes[9];
      Buffer_10[k] /= col_added_valutes[10];
      Buffer_11[k] /= col_added_valutes[11];
      Buffer_12[k] /= col_added_valutes[12];
      Buffer_13[k] /= col_added_valutes[13];
      Buffer_14[k] /= col_added_valutes[14];
      Buffer_15[k] /= col_added_valutes[15];
      Buffer_16[k] /= col_added_valutes[16];
   }
   
   return(0);
  }
//+------------------------------------------------------------------+

void deinit() {
   Comment("");
}