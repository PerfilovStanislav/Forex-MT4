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
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Magenta
#property indicator_level1    1.0
/*#property indicator_minimum    1.995
#property indicator_maximum    2.005*/
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT
/*extern string simbol_1 = "";      //ЕСЛИ "" то текущий
extern string simbol_2 = "EURUSD";//ЕСЛИ "" то текущий
extern string simbol_3 = "EURCHF";//ЕСЛИ "" то текущий
extern string simbol_4 = "EURJPY";//ЕСЛИ "" то текущий*/
extern int ControlBars = 500;     //колличество контроллируемых свечей
extern int mid           = 10;       //усреднение
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];

string valutes[17] = {"EUR", "GBP", "AUD", "NZD", "USD", "CAD", "CHF", "CZK", "DKK", "HKD", "HUF", "MXN", "NOK", "SEK", "SGD", "ZAR", "JPY"};
int v1_index, v2_index, res_1, res_2;
string v1_name, v2_name;
int cnt = 400,i, k, j, size = ArraySize(valutes);

//+------------------------------------------------------------------+
int init()  {
   
   
   v1_name = StringSubstr(_Symbol, 0, 3);
   v2_name = StringSubstr(_Symbol, 3, 3);
   
   v1_index = getIndexOfArray(v1_name);
   v2_index = getIndexOfArray(v2_name);
     

   SetIndexBuffer(0,Buffer_1);
   SetIndexBuffer(1,Buffer_2);
   SetIndexBuffer(2,Buffer_3);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexLabel(0,v1_name);
   SetIndexLabel(1,v2_name);
   SetIndexLabel(2,"");
   SetIndexLabel(3,"");
   
   
   
   
   return(0);
  }
  
  
int getIndexOfArray(string str) {
   for (i=0; i<ArraySize(valutes); i++) {
      if (str == valutes[i]) return i;
   }
   return -1;
}

//+------------------------------------------------------------------+
int start() {
   double sum_1 = 0, tmp_1;
   double sum_2 = 0, tmp_2;
   double kol=size-2;
   string valu_1, valu_2;
   MqlRates s1[];   
   MqlRates s2[];  
   
   for (k=0; k<cnt-(mid+1); k++) {
      Buffer_1[k] = 0;
      Buffer_2[k] = 0;
   }
   
   ArraySetAsSeries(s1,true);
   ArraySetAsSeries(s2,true);
   
   for (i=0; i<size; i++) {
      if (i == v1_index || i == v2_index) continue;
      
      
      if (i < v1_index) valu_1 = valutes[i]          + valutes[v1_index];
      else              valu_1 = valutes[v1_index]   + valutes[i];
      
      if (i < v2_index) valu_2 = valutes[i]          + valutes[v2_index];
      else              valu_2 = valutes[v2_index]   + valutes[i];  
      
      res_1 = CopyRates(valu_1, 0, 0, cnt, s1);
      res_2 = CopyRates(valu_2, 0, 0, cnt, s2);
      
      if (res_1 == -1 || res_2 == -1) {
         kol--;
         Comment(kol);
         continue;
      }
            
      for (k=0; k<cnt-(mid+1); k++) {
         tmp_1 = 0;
         tmp_2 = 0;
         for (j=1; j<=mid; j++) {
            tmp_1 += (s1[k+j].close);
            tmp_2 += (s2[k+j].close);
         }
         tmp_1 /= mid;
         tmp_2 /= mid;
         
         if (i < v1_index) Buffer_1[k] += (tmp_1 / s1[k].close);  
         else              Buffer_1[k] += (s1[k].close / tmp_1);  
         
         if (i < v2_index) Buffer_2[k] += (s2[k].close / tmp_2);  
         else              Buffer_2[k] += (tmp_2 / s2[k].close);             
      }      
   }
   for (k=0; k<cnt-(mid+1); k++) {
      Buffer_1[k] /= kol;  
      Buffer_2[k] /= kol;     
   }
   
   return(0);
  }
//+------------------------------------------------------------------+

void deinit() {
   Comment("");
}