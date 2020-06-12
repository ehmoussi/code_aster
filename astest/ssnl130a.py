# coding=utf-8

def Pression(t,x,y,z):
   Pressy = 5.0*(y-2.0)**2
   if ( t <= 1.0 ): return Pressy*t
   return Pressy

def Deplacer(t,x,y,z):
   if ( t<= 1.0): return 0.0
   return (t-1.0)*0.5E-02
