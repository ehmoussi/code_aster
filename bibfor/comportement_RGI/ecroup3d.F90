! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine ecroup3d(rp1,drp1_depl,rpic0,s11,epic0,epl0,epp1,&
       r0,eps0,rmin,hpla,ekdc,beta,rpiceff,epeqpc)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!     sous programme de traitement de l ecrouissage parbolique pre pic

      implicit none
#include "asterf_types.h"

      real(kind=8) :: e
      real(kind=8) :: hpla,e0,ep,rp,x0
      real(kind=8) :: precision1,rp1,drp1_depl,rpic0,s11,epic0,epl0,ekdc,beta
      real(kind=8) :: gama,r0,eps0,rmin,epp1,alpha,rpiceff,epeqpc
      aster_logical ::  end3dpp
        
      real(kind=8) :: t1,t2,t3,t4,t5,t7,t8,t9
      real(kind=8) :: t10,t12,t14,t15,t17
      real(kind=8) :: t23,t28,t29
      real(kind=8) :: t30,t31,t33,t37
      real(kind=8) :: t44,t46,t47,t48,t49
      real(kind=8) :: t50,t51,t56,t57,t59
      real(kind=8) :: t61,t65,t68
      real(kind=8) :: t72,t73
      real(kind=8) :: t80,t82,t87,t88
      real(kind=8) :: t91,t92,t96,t97,t98,t99
      real(kind=8) :: t102,t103,t107
      real(kind=8) :: t110,t111,t113,t116,t119
      real(kind=8) :: t121,t122,t125,t128,t129
      real(kind=8) :: t132,t135,t136,t139
      real(kind=8) :: t148,t149
      real(kind=8) :: t152,t155,t156,t159
      real(kind=8) :: t162,t163,t164
      real(kind=8) :: t170
      real(kind=8) :: t181,t186
      real(kind=8) :: t192,t197
      real(kind=8) :: t200,t201,t206,t209
      real(kind=8) :: t210,t216,t217
      real(kind=8) :: t237
      real(kind=8) :: t252
      real(kind=8) :: t260
      real(kind=8) :: t293
      real(kind=8) :: t302
    
            
!     precision      
!     ecrouissage relatif maxi 95% gam=1/95% > 1
      parameter(precision1=1.0d-6,gama=1.05d0)       
      
!     le module utilise est par defaut celui de la direction 1
      E0=1.d0/s11
!     seuil de plasticité en deformation totale uniax equivalente
      x0=rpic0/E0
!     coeff 1.05 permet d avoir 95%E0 en module tangent à rmin      
      eps0=dmax1((epic0-2.d0*gama*x0)/(1.d0-2.d0*gama),rmin/E0)
!     contrainte seuil de plasticite      
      r0=E0*eps0
!     resistance reduite a la partie plastique
      rp=rpic0-r0
!     deformation plastique de fin d ecrouissage si pas d endo
      epp1=dmax1(epic0-x0,0.d0)      
!     notation maple
      ep=epl0
      E=E0 
!     coeff de passage  de ep axial a la def plast volumique
      alpha=-3.d0*beta/(beta-dsqrt(3.d0)) 
!     def equivalente au pic de compression servant de seuil
!     pour amorcer l endommagement
      epeqpc=epp1*alpha 


!     ******************************************************************      
!     CAS endo prepic autorise      
!      end3dpp=end3d
!     CAS ou on interdit l'endo pre pic en compression pour ameliorer la convergence      
      end3dpp=.false.
!     ******************************************************************      
      
       if(end3dpp) then
!       ****************************************************************      
!       ecrouissage et endommagement
!       ****************************************************************  

            ep=dmax1(precision1,epl0)           
           epp1 = ekdc*(E0 * epic0 - rpic0)/(E0 * ekdc + alpha * rpic0)
!          def seuil d'endo de comp prise à 0, car l'endo commence avec
!          la plasticité 
           epeqpc=0.d0            
           if(ep.le.epp1) then
           
!       ******* resistance en presence d endommagement *****************

                t2 = ep * alpha
                t9 = ekdc * E0
                t10 = epic0 ** 2
                t12 = epic0 * eps0
                t15 = eps0 ** 2
                t23 = ekdc * epic0
                t28 = E0 ** 2
                t29 = ekdc ** 2
                t30 = t29 * t28
                t31 = t10 ** 2
                t33 = t10 * epic0
                t44 = t15 ** 2
                t46 = alpha * E0
                t47 = E0 * alpha * ekdc
                t48 = ep ** 2
                t49 = t10 * t48
                t56 = epic0 * t48
                t57 = eps0 * r0
                t61 = eps0 * rpic0
                t65 = t15 * t48
t72 = -0.4D1 * t15 * eps0 * epic0 * t30 - 0.4D1 * eps0 * t33 * t30-&
0.4D1 * r0 * t49 * t47 - 0.4D1 * r0 * t65 * t47 + 0.4D1 * rpic0*&
t49 * t47 + 0.4D1 * rpic0 * t65 * t47 + 0.6D1 * t15 * t10 * t30+&
0.8D1 * t57 * t56 * t47 - 0.8D1 * t61 * t56 * t47 + t31 * t30 +&
t44 * t30
                t73 = t33 * ep
                t80 = t10 * ep
                t87 = ep * epic0
                t88 = r0 * t15
                t96 = alpha ** 2
                t97 = t48 * t96
                t99 = rpic0 * r0 * t10
                t102 = rpic0 ** 2
                t107 = rpic0 * t57
                t110 = t102 * t12
                t113 = rpic0 * t88
t119 = -0.4D1 * rpic0 * t15 * t87 * t47 + 0.8D1 * t107 * epic0 * &
t97 + 0.4D1 * r0 * t73 * t47 - 0.4D1 * rpic0 * t73 * t47 + 0.4D1 *& 
t102 * t10 * t97 + 0.4D1 * t102 * t15 * t97 - 0.8D1 * t57 * t80 * &
t47 + 0.8D1 * t61 * t80 * t47 + 0.4D1 * t88 * t87 * t47 - 0.8D1 * &
t110 * t97 - 0.4D1 * t113 * t97 - 0.4D1 * t99 * t97
                t121 = t29 * E0
                t128 = ep * t121
                t135 = t15 * ep
                t148 = eps0 * t10
                t155 = t15 * epic0
t162 = 0.8D1 * r0 * t12 * t128 - 0.4D1 * r0 * t135 * t121 - 0.8D1*& 
r0 * t148 * t121 + 0.4D1 * r0 * t155 * t121 + 0.4D1 * r0 * t33 *&
t121 - 0.4D1 * r0 * t80 * t121 - 0.8D1 * rpic0 * t12 * t128 +&
0.4D1 * rpic0 * t135 * t121 + 0.8D1 * rpic0 * t148 * t121 - 0.4D1 *&
rpic0 * t155 * t121 - 0.4D1 * rpic0 * t33 * t121 + 0.4D1 * rpic0 * &
t80 * t121
                t163 = ekdc * alpha
                t164 = ep * t163
                t170 = rpic0 * r0
                t181 = t10 * t29
                t186 = epic0 * t29
                t192 = t15 * t29
t197 = -0.8D1 * t102 * eps0 * t186 + 0.8D1 * t102 * t135 * t163 +& 
0.8D1 * t102 * t80 * t163 + 0.16D2 * t170 * t12 * t164 + 0.4D1 *&
t102 * t181 + 0.4D1 * t102 * t192 + 0.8D1 * t107 * t186 - 0.16D2 *& 
t110 * t164 - 0.8D1 * t113 * t164 - 0.8D1 * t99 * t164 - 0.4D1 * &
t170 * t181 - 0.4D1 * t170 * t192
                t200 = sqrt(t72 + t119 + t162 + t197)
t209 = (0.1D1 - 0.1D1 / (epic0 - eps0) * ((0.2D1 * epic0 * r0 * t2-&
0.2D1 * epic0 * rpic0 * t2 + 0.2D1 * r0 * t23 - 0.2D1 * rpic0 *&
t23 + t10 * t9 - 0.2D1 * t12 * t9 + t15 * t9 - t200) / (ekdc * r0-&
ekdc * rpic0 + r0 * t2 - rpic0 * t2) / 0.2D1 - eps0)) ** 2
t216 = 0.1D1 / ekdc * (t2 + ekdc) * (r0 + (0.1D1 - t209) * (rpic0 -&
r0))
                 rp1=t216
                 rpiceff=rpic0*(ekdc+alpha*epp1)/ekdc               
!    *********** derivee de la resistance en presence dendommagement ***
     
                ep=dmax1(epl0,precision1)  
                t7 = ekdc * r0 - ekdc * rpic0 + r0 * t2 - rpic0 * t2
                t8 = 0.1D1 / t7
                t92 = rpic0 * t15
                t98 = r0 * t10
                t103 = t102 * t10
                t116 = t102 * t15
                t122 = r0 * t80
                t125 = rpic0 * t80
                t129 = r0 * t12
                t132 = rpic0 * t12
                t136 = r0 * t135
                t139 = rpic0 * t135
                t149 = r0 * t148
                t152 = rpic0 * t148
                t156 = r0 * t155
                t159 = rpic0 * t155
t201 = 0.2D1 * epic0 * r0 * t2 - 0.2D1 * epic0 * rpic0 * t2 + 0.2D1*&
r0 * t23 - 0.2D1 * rpic0 * t23 + t10 * t9 - 0.2D1 * t12 * t9 +&
t15 * t9 - t200
                  t206 = 0.1D1 / (epic0 - eps0)
                  t210 = t7 ** 2
                  t217 = epic0 * alpha
                  t237 = t33 * ekdc
                  t252 = ep * t96
t260 = 0.16D2 * t107 * epic0 * t252 + 0.4D1 * r0 * t237 * t46 - &
0.4D1 * rpic0 * t237 * t46 + 0.16D2 * t57 * t87 * t47 - 0.16D2 * &
t61* t87 * t47 + 0.8D1 * t103 * t252 - 0.8D1 * t122 * t47 + 0.8D1*& 
t125 * t47 - 0.8D1 * t136 * t47 + 0.8D1 * t139 * t47 - 0.8D1 * t149*&
t47 + 0.8D1 * t152 * t47 + 0.4D1 * t156 * t47 - 0.4D1 * t159 *&
t47 - 0.8D1 * t99 * t252
t293 = 0.16D2 * t107 * epic0 * t163 + 0.4D1 * rpic0 * t10 * t121 +&
0.8D1 * t103 * t163 - 0.16D2 * t110 * t163 - 0.16D2 * t110 * t252-&
0.8D1 * t113 * t163 - 0.8D1 * t113 * t252 + 0.8D1 * t116 * t163+&
0.8D1 * t116 * t252 + 0.8D1 * t129 * t121 - 0.8D1 * t132 * t121-&
0.4D1 * t88 * t121 + 0.4D1 * t92 * t121 - 0.4D1 * t98 * t121 -& 
0.8D1 * t99 * t163
t302 = t206 * (-(alpha * r0 - alpha * rpic0) * t201 / t210 + (0.2D1*&
r0 * t217 - 0.2D1 * rpic0 * t217 - (t260 + t293) / t200 / 0.2D1)*&
t8) * (0.1D1 - t206 * (t201 * t8 / 0.2D1 - eps0)) * (rpic0 -& 
r0)
                drp1_depl=dmax1(t302,hpla*E0)
            else
!               on est apres le pic
                drp1_depl=hpla*E0
                rpiceff=rpic0*(ekdc+alpha*epp1)/ekdc
                rp1=rpiceff+drp1_depl*(ep-epp1)
            end if
!        end if                

        
      else
      
!     ******************************************************************      
!       ecrouissage seul       
!     ******************************************************************    

            ep=dmax1(precision1,epl0)
            if(ep.le.epp1) then
!               on est avant le pic
 
!       *******  resistance de la partie plastique  ******************** 
                  t1 = rpic0 - r0
                  t3 = epic0 ** 2
                  t4 = t3 * E0
                  t5 = epic0 * E0
                  t8 = eps0 ** 2
                  t14 = E0 ** 2
                  t15 = t3 ** 2
                  t17 = t3 * epic0
                  t28 = t8 ** 2
                  t30 = E0 * ep
                  t31 = r0 * t3
                  t37 = epic0 * eps0
                  t44 = r0 * t8
                  t47 = rpic0 * t8
      t50 = -0.4D1 * t8 * eps0 * epic0 * t14 - 0.4D1 * eps0 * t17 * t14+& 
      0.8D1 * r0 * t37 * t30 + 0.4D1 * rpic0 * t3 * t30 - 0.8D1 * rpic0*&
      t37 * t30 + 0.6D1 * t8 * t3 * t14 + t15 * t14 + t28 * t14 - 0.4D1*&
      t31 * t30 - 0.4D1 * t44 * t30 + 0.4D1 * t47 * t30
                  t51 = t17 * E0
                  t68 = rpic0 ** 2
      t80 = -0.8D1 * eps0 * r0 * t4 + 0.8D1 * eps0 * rpic0 * t4 + 0.8D1*&
      r0 * rpic0 * t37 + 0.4D1 * r0 * t51 - 0.4D1 * rpic0 * t31 - 0.4D1*&
      rpic0 * t44 - 0.4D1 * rpic0 * t51 + 0.4D1 * t68 * t3 - 0.8D1 *&
      t68 * t37 + 0.4D1 * t44 * t5 - 0.4D1 * t47 * t5 + 0.4D1 * t68 * t8
      t82 = dsqrt(t50 + t80)
      t91 = (0.1D1 - 0.1D1 / (epic0 - eps0) * (-(t8 * E0 + 0.2D1 * epic0*&
      r0 - 0.2D1 * epic0 * rpic0 - 0.2D1 * eps0 * t5 + t4 - t82) / t1/&
      0.2D1 - eps0)) ** 2
      
!                 resistance pres pic      
                  rp1 = r0 + (0.1D1 - t91) * t1
                  rpiceff=rpic0

!   ********** calcul de la derivee de la resistance  / def plastique **
        
                  ep=dmax1(epl0,precision1)    
                  t2 = -0.1D1 / t1
                  t9 = t8 * E0
                  t31 = r0 * t3
                  t56 = eps0 * r0
                  t59 = eps0 * rpic0
                  t88 = 0.1D1 / (epic0 - eps0)
      t111 = -t88 * (-0.4D1 * r0 * t4 - 0.4D1 * r0 * t9 + 0.4D1 * rpic0*& 
      t4 + 0.4D1 * rpic0 * t9 + 0.8D1 * t56 * t5 - 0.8D1 * t59 * t5) /&
      t82 * t2 * (0.1D1 - t88 * ((0.2D1 * epic0 * r0 - 0.2D1 * epic0 *& 
      rpic0 - 0.2D1 * eps0 * t5 + t4 - t82 + t9) * t2 / 0.2D1 - eps0)) *&
      t1 / 0.2D1
     
!               derivee de la resistance en pre-pic     
                drp1_depl=dmax1(t111,hpla*E0)
            else
!               on est apres le pic
                drp1_depl=hpla*E0
                rp1=rpic0+drp1_depl*(ep-epp1)
                rpiceff=rpic0
            end if
!        end if
      end if
              
end subroutine
