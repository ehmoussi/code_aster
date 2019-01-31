! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine calc_moment(e0, kappa, e_b, f_t, f_c, c,&
                       h, e_a, s_a, y_a, f_ta, cas, eff, mom)
! 
    implicit none
!
! PARAMETRES ENTRANTS
#include "asterfort/assert.h"
    real(kind=8) :: e0, kappa, e_b, f_t, f_c, c, h, e_a, s_a, y_a, f_ta
    integer :: cas
!
! PARAMETRES SORTANTS
    real(kind=8) :: eff, mom

! PARAMETRES D'ENTREE 
!     e_b   MODULE DU BETON MODIFIE
!     f_t   CONTRAINTE LIMITE DE TRACTION DU BETON 
!     f_c   CONTAINTE LIMITE EN COMPRESSION DU BETON 
!     c     COEFFICIENT ADOUCISSEMENT BETON  ( A CALCULER) PAS NUL 
!     h     HAUTEUR DE LA SECTION 
!     e_a   MODULE ELASTIQUE DU BETON 
!     s_a    SECTION DES ACIERS ATTENTION L
!     y_a   POSITION DES ACIERS (PAS RELATIVE)
!     f_ta  LIMITE ELASTIQUE DES ACIERS 
!     kappa VALEUR DE LA COURBURE 

!     liste des cas 
!     1 TOUT ELASTIQUE 
!     2 CAS BETON FISSURE / PAS DE COMPRESSION / ACIER ELASTIQUES 
!     3 CAS BETON FISSURE / PAS DE COMPRESSION / ACIER PLASTIQUE 
!     4 CAS BETON FISSURE / PAS DE COMPRESSION / ACIERS PLASTIQUES
!     5 CAS BETON FISSURE /  COMPRESSION / ACIER ELASTIQUES 
!     6 CAS BETON FISSURE /  COMPRESSION / ACIER PLASTIQUE 
!     7 CAS BETON FISSURE /  COMPRESSION / ACIERS PLASTIQUES
!     8 CAS BETON FISSURE RUPT/ PAS DE COMPRESSION / ACIER ELASTIQUES 
!     9 CAS BETON FISSURE RUPT/ PAS DE COMPRESSION / ACIER PLASTIQUE
!     10 CAS BETON FISSURE RUPT/ PAS DE COMPRESSION / ACIERS PLASTIQUES
!     11 CAS BETON FISSURE RUPT/ COMPRESSION / ACIER ELASTIQUES 
!     12 CAS BETON FISSURE RUPT/ COMPRESSION / ACIER PLASTIQUE 
!     13 CAS BETON FISSURE RUPT/ COMPRESSION / ACIERS PLASTIQUES
!     0 indetermine

! PARAMETRES INTERNES
    real(kind=8) :: e_t, e_c, e_u, e_ta, y1, y2, f, cc, y

    
!   calcul intermediare 
    e_t=f_t/e_b
    e_c=-f_c/e_b
    e_u=(1.d0+c)*e_t
    e_ta=f_ta/e_a

    
    if (cas .eq. 1)then 
!       TOUT ELASTIQUE ( ACIER ELASTIQUES) 
        if (kappa*y_a .lt. e_ta) then
            mom=kappa*((1.d0/12.d0)*e_b*(h**3)+2.d0*e_a*s_a*(y_a**2))
        else
            mom=kappa*((1.d0/12.d0)*e_b*(h**3)+2.d0*e_a*s_a*(y_a**2))&
             +2.d0*e_a*s_a*y_a*(e_ta-kappa*y_a)
        endif
        eff = 0.d0
!   cas beton fissure mais pas rompu
    elseif (cas .ge. 2 .and. cas .le.7) then 
        y=(1.d0/kappa)*(e0-e_t)
        f=(1.d0+(1.d0/c))*(0.125d0*y*(h**2)-(1.d0/6.d0)*(y**3))-(1.d0-(1.d0/c))*((h**3)/24.d0)
        mom = -e_b*f*kappa+2.d0*e_a*s_a*(y_a**2)*kappa
        
        eff = e_b*((e_t+(e_t-e0)/c)*(y+h/2.d0)+kappa/(2.d0*c)*(y**2-h**2/4.d0))
        eff = eff + e_b*(e0*(h/2.d0-y)-1.d0/2.d0*kappa*(h**2/4.d0-y**2))
        eff = eff + 2.d0*e_a*s_a*e0
!       prise en compte de la limite en compression du beton
        if (cas .ge. 5) then 
            y2=(e0-e_c)/kappa
            cc =0.125d0*y2*h**2-(1.d0/6.d0)*y2**3-(1.d0/24.d0)*h**3
            mom = mom + e_b*kappa*cc  
            eff = eff + 1.d0/2.d0*e_b*kappa*(h**2*0.25d0-y2**2)+(f_c+e_b*e0)*(y2-h*0.5d0)
        endif
!       un acier plastifie  
        if (cas .eq. 3 .or. cas .eq. 6) then
            mom = mom-(e_a*s_a*y_a*(e0+kappa*y_a-e_ta))
            eff = eff -e_a*s_a*e0+e_a*s_a*(e_ta-kappa*y_a)
        endif
!       deux aciers plastifies 
        if (cas .eq. 4 .or. cas .eq. 7) then
            mom = mom - 2*e_a*s_a*(y_a**2)*kappa+2*e_a*s_a*y_a*e_ta
            eff = eff - 2*e_a*s_a*e0
        endif
!   cas beton rompu
    elseif (cas .ge. 8 .and. cas .le. 13) then 
        y1=(1.d0/kappa)*(e0-e_u)
        y2=(1.d0/kappa)*(e0-e_t)
        f=0.5d0*(e_t*(1.d0+(1.d0/c))-(e0/c))*((y2**2)-(y1**2))+e0*(0.125d0*(h**2)-0.5d0*(y2**2))&
         +(kappa/(3.d0*c))*((y2**3)-(y1**3))+kappa*(((y2**3)/3.d0)-((h**3)/24.d0))
        mom = -e_b*f+2.d0*e_a*s_a*(y_a**2)*kappa
    
        eff = e_b*((e_t*(1+1./c)-e0/c)*(y2-y1)+kappa/(2*c)*(y2**2-y1**2))
        eff = eff + e_b*(e0*(h/2.d0-y2)-1.d0/2.d0*kappa*(h**2*0.25d0-y2**2))
        eff = eff + 2.d0*e_a*s_a*e0 
        
!       prise en compte de la limite en compression du beton 
        if (cas .ge. 11)then
            y2=(e0-e_c)/kappa
            cc =0.125d0*y2*h**2-(1.d0/6.d0)*y2**3-(1.d0/24.d0)*h**3
            mom = mom + e_b*kappa*cc  
            eff = eff + 1.d0/2.d0*e_b*kappa*(h**2*0.25d0-y2**2)+(f_c+e_b*e0)*(y2-h*0.5d0)
        endif
!       un acier plastifie
        if (cas .eq. 9 .or. cas .eq. 12)then
            mom = mom -e_a*s_a*y_a*(e0+kappa*y_a-e_ta)
            eff = eff -e_a*s_a*e0+e_a*s_a*(e_ta-kappa*y_a)
!       deux aciers plastifies
        elseif (cas .eq. 10 .or. cas .eq. 13)then 
            mom = mom -2.d0*e_a*s_a*(y_a**2)*kappa+2.d0*e_a*s_a*y_a*e_ta
            eff = eff -2.d0*e_a*s_a*e0
        endif
    else
        ASSERT(.false.)
    endif

end subroutine
