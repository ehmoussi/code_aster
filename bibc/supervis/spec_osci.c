/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

#include "aster.h"
#include "aster_fort.h"

void calc_SPEC_OSCI( int nbpts, double* vale_x, double* vale_y,
                     int len_f, double* l_freq, int len_a, double* l_amor,
                     double* spectr )
{
   int      i,a,f;
   double   pas, DELTAT, eps, ecart;
   double   XSI, XSI2, W, W2, UNSW2, WDT, COSWDT, SINWDT, A, B, C, D, E, F;
   double   EXPXWT, EXPSA, D1, D2, D3, V2, V3, F1, F2, FSDT, DEUXPI;
   double   WDDT;

   eps = 1.e-6;

   /* pas constant ou variable */
   DELTAT = vale_x[1]-vale_x[0];
   ecart = 0.;
   i = 1;
   while ( i<nbpts-1 && ecart<eps ) {
      pas = vale_x[i+1]-vale_x[i];
      if ( fabs((pas-DELTAT)/DELTAT) > ecart )
         ecart = fabs((pas-DELTAT)/DELTAT);
      i++;
   }

   DEUXPI = (double)(2. * CALL_R8PI());

   /* le pas est constant */
   if (ecart < eps) {
      for (a=0; a<len_a; a++) {
         XSI = l_amor[a];
         XSI2 = XSI * XSI;
         for (f=0; f<len_f; f++) {
            W = DEUXPI * l_freq[f];
            W2 = W * W;
            UNSW2 = 1. / W2;
            WDT = W * DELTAT;
            A = W * sqrt( 1. - XSI2 );
            WDDT = A * DELTAT;
            COSWDT = cos( WDDT );
            SINWDT = sin( WDDT );
            B = 2. * XSI / W;
            C = ( ( 2. * XSI2 ) - 1. ) / A;
            D = XSI * W;
            E = W2 / A;
            F = COSWDT + ( SINWDT * D / A );
            EXPXWT = exp( -D * DELTAT );
            EXPSA = EXPXWT / A;
            D1 = 0.;
            D2 = 0.;
            V2 = 0.;
            F1 = vale_y[0];
            for (i=1; i<nbpts; i++) {
               F2 = vale_y[i];
               FSDT = ( F2 - F1 ) / DELTAT;
               D3 = EXPSA*((A*COSWDT+D*SINWDT)*D2+SINWDT*V2)+UNSW2*
                    (EXPXWT*(FSDT*(B*COSWDT+C*SINWDT)-F1*F)+F2-B*FSDT);
               V3 = EXPSA*((-W2)*SINWDT*D2+((-D)*SINWDT+A*COSWDT)*V2) +
                    UNSW2*(EXPXWT*((-FSDT)*F+F1*E*SINWDT)+FSDT);
               D2 = D3;
               V2 = V3;
               if ( fabs(D3) > D1 )
                  D1 = fabs(D3);
               F1 = F2;
            }
            /* spectr[i, j, k] = spectr[i*dim2*dim3 + j*dim3 + k] */
            spectr[a*3*len_f + 0*len_f + f] = D1;
            spectr[a*3*len_f + 1*len_f + f] = W * D1;
            spectr[a*3*len_f + 2*len_f + f] = W2 * D1;
         }
      }
   }
   /* le pas est variable */
   else
   {

      for (a=0; a<len_a; a++) {
         XSI = l_amor[a];
         XSI2 = XSI * XSI;
         for (f=0; f<len_f; f++) {
            W = DEUXPI * l_freq[f];
            W2 = W * W;
            UNSW2 = 1. / W2;
            D1 = 0.;
            D2 = 0.;
            V2 = 0.;
            F1 = vale_y[0];

            for (i=1; i<nbpts; i++) {
               DELTAT = vale_x[i] - vale_x[i-1];
               F2 = vale_y[i];
               WDT = W * DELTAT;
               A = W * sqrt( 1. - XSI2 );
               WDDT = A * DELTAT;
               COSWDT = cos( WDDT );
               SINWDT = sin( WDDT );
               B = 2. * XSI / W;
               C = ( ( 2. * XSI2 ) - 1. ) / A;
               D = XSI * W;
               E = W2 / A;
               F = COSWDT + ( SINWDT * D / A );
               EXPXWT = exp( -D * DELTAT );
               EXPSA = EXPXWT / A;
               FSDT = ( F2 - F1 ) / DELTAT;
               D3 = EXPSA*((A*COSWDT+D*SINWDT)*D2+SINWDT*V2)+UNSW2*
                    (EXPXWT*(FSDT*(B*COSWDT+C*SINWDT)-F1*F)+F2-B*FSDT);
               V3 = EXPSA*((-W2)*SINWDT*D2+((-D)*SINWDT+A*COSWDT)*V2) +
                    UNSW2*(EXPXWT*((-FSDT)*F+F1*E*SINWDT)+FSDT);
               D2 = D3;
               V2 = V3;
               if ( fabs(D3) > D1 )
                  D1 = fabs(D3);
               F1 = F2;
            }
            /* spectr[i, j, k] = spectr[i*dim2*dim3 + j*dim3 + k] */
            spectr[a*3*len_f + 0*len_f + f] = D1;
            spectr[a*3*len_f + 1*len_f + f] = W * D1;
            spectr[a*3*len_f + 2*len_f + f] = W2 * D1;
         }
      }
   }
}
