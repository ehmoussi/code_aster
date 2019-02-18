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

subroutine calc_axe_neutre(e_b, f_t, f_c, c, h, e_a, s_a,&
                                y_a, f_ta, kappa,&
                                e0, cas)
! 
    implicit none
!
! PARAMETRES ENTRANTS
#include "asterfort/assert.h"
    real(kind=8) :: e_b, f_t, f_c, c, h, e_a, s_a, y_a, f_ta, kappa
!
! PARAMETRES SORTANTS
    real(kind=8) :: e0
    integer :: cas


! PARAMETRES D'ENTREE 
!     e_b   MODULE DU BETON MODIFIE
!     f_t   CONTRAINTE LIMITE DE TRACTION DU BETON 
!     f_c   CONTAINTE LIMITE EN COMPRESSION DU BETON 
!     c     COEFFICIENT ADOUCISSEMENT BETON  ( A CALCULER) PAS NUL 
!     h     HAUTEUR DE LA SECTION 
!     e_a   MODULE ELASTIQUE DU BETON 
!     Sa    SECTION DES ACIERS ATTENTION L
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
    real(kind=8) :: e_t, e_c, e_u, e_ta, a, b, s, d, f
    integer :: action

!     valeurs intermediaires 
    e_t=f_t/e_b
    e_c=-f_c/e_b
    e_u=(1.d0+c)*e_t
    e_ta=f_ta/e_a
    
    e0 = 1.d3
    cas = 0
    action = 1
    
!   CAS 1 ELASTIQUE 
    if (kappa .lt. ((2*e_t)/h))then
!       TOUT ELASTIQUE 
        e0 = 0.d0 
        cas = 1 
        action = 0 
    endif

!   CAS BETON FISSURE / PAS DE COMPRESSION / ACIER ELASTIQUES    
    if (action .eq. 1)then
    !     on suppose que c!=0
    !     on suppose qu"on est dans le cas2 : fissuration du beton <eu 
        a = -(e_b/(2.d0*kappa))*(1.d0+(1.d0/c)) 
        b = e_b*((1.d0/kappa)*(1.d0+(1.d0/c))*e_t+0.5d0*h*(1.d0-(1.d0/c)))&
            +2.d0*e_a*s_a
        s = (1.d0+(1.d0/c))*(0.5d0*h*e_t-(1.d0/(2.d0*kappa))*(e_t**2)&
             -0.125d0*kappa*(h**2))*e_b 
        d = (b**2)-4.d0*a*s
        if (d .ge. 0)then
            f=(-b+sqrt(d))/(2.d0*a)
        !   verification de la plastification des aciers 
            if (f+kappa*y_a  .lt. e_ta .and. f-kappa*y_a .gt. -e_ta)then
                e0 = f 
!               CAS BETON FISSURE / PAS DE COMPRESSION / ACIER ELASTIQUES=
                cas = 2 
                action = 2
            else
!               prise en compte de la plastification aciers en traction 
                b = b-e_a*s_a
                s = s+e_a*s_a*(e_ta-kappa*y_a)
                d = (b**2)-4.d0*a*s 
                if (d .ge. 0.d0)then
                    f=(-b+sqrt(d))/(2.d0*a)
                else
                    f = 0.d0
                endif
                
                if (f .ne. 0.d0 .and. (f+kappa*y_a) .gt. e_ta .and. (f-kappa*y_a) .gt. -e_ta)then
                    e0 = f
                    cas = 3
                    action = 2
                else             
                    b=b-e_a*s_a
                    s=(1.d0+(1.d0/c))*(0.5d0*h*e_t-(1.d0/(2.d0*kappa))*(e_t**2)&
                      -0.125d0*kappa*(h**2))*e_b
                    d=b**2-4.d0*a*s
                    if (d .ge. 0.d0)then
                        f=(-b+sqrt(d))/(2.d0*a)
                        e0 = f 
                        cas = 4
                        action = 2
                    else
                        action = 4
                    endif
                endif
            endif
        else
            action = 4
        endif
    endif

!   VERIFICATION DE LA COMPRESSION DU BETON     
    if (action .eq. 2)then
!       si on a passe la limite en compression
        if ((e0-0.5d0*kappa*h) .lt. e_c) then 
            a=-(e_b/(2.d0*kappa))*(1.d0+(1.d0/c))+(e_b/(2.d0*kappa)) 
            b=e_b*((1.d0/kappa)*(1.d0+(1.d0/c))*e_t+0.5d0*h*(1.d0-(1.d0/c)))&
              +2.d0*e_a*s_a+(f_c/kappa)-0.5d0*h*e_b
            s=(1.d0+(1.d0/c))*(0.5d0*h*e_t-(1.d0/(2.d0*kappa))*(e_t**2)-0.125d0*kappa*(h**2))*e_b&
               +0.125d0*kappa*e_b*h**2+(0.5d0*f_c**2)/(e_b*kappa)-0.5d0*h*f_c
            d=(b**2)-4.d0*a*s
            if (d .ge. 0.d0)then   
                f=(-b+sqrt(d))/(2.d0*a)
                if (f+kappa*y_a .lt. e_ta .and. f-kappa*y_a .gt. -e_ta)then
                    e0 = f
!                   BETON FISS / COMPRESSION / ACIER ELASTIQUE
                    cas = 5
                    action = 3
                else 
                    b=b-e_a*s_a
                    s=s+e_a*s_a*(e_ta-kappa*y_a)
                    d=(b**2)-4.d0*a*s 
                    if (d .ge. 0.d0)then
                        f=(-b+sqrt(d))/(2.d0*a)
                    else
                        f = 0.d0
                    endif
                    if (f .ne. 0.d0 .and. f+kappa*y_a .gt. e_ta .and. f-kappa*y_a .gt. -e_ta)then
                        e0 = f
!                       BETON FISS / COMPRESSION / ACIER PLASTIQUE
                        cas = 6
                        action = 3
                    else              
                        b=b-e_a*s_a
                        s=(1.d0+(1.d0/c))*(0.5d0*h*e_t-(1.d0/(2d0*kappa))*(e_t**2)&
                          -0.125d0*kappa*(h**2))*e_b&
                           +0.125d0*kappa*e_b*h**2+(0.5d0*f_c**2)/(e_b*kappa)-0.5d0*h*f_c
                        d=b**2-4.d0*a*s
                        if (d .ge. 0.d0)then
                            f=(-b+sqrt(d))/(2.d0*a)
                            e0 = f
!                           BETON FISS / COMPRESSION / ACIERS PLASTIQUES
                            cas = 7
                            action = 3
                        else
                            action =4
                        endif
                    endif
                endif
            else
                action = 4
            endif
        else
            action = 3
        endif
    endif
!
!   verification hypothese BETON FISSURE / RUPTURE 
    if (action .eq. 3) then
        if (e0+0.5d0*kappa*h .lt. e_u)then
            action = 0
        else
            action = 4
        endif
    endif

!   BETON RUPTURE 
    if (action .eq. 4)then
        a=-e_b/(2.d0*kappa)
        b=e_b*(0.5d0*h)+2.d0*e_a*s_a
        s=((c+1.d0)*(1.d0/(2.d0*kappa))*(e_t**2)-0.125d0*kappa*(h**2))*e_b
        d=(b**2)-4.d0*a*s
        if (d .ge. 0.d0)then
            f=(-b+sqrt(d))/(2.d0*a)
            if (f+kappa*y_a .lt. e_ta .and. f-kappa*y_a .gt. -e_ta) then
                e0 = f
!               BETON FISS RUPT / COMPRE ELAS / ACIER ELASTIQUE
                cas = 8
                action = 5     
            else  
                b=b-e_a*s_a
                s=s+e_a*s_a*(e_ta-kappa*y_a)
                d=(b**2)-4.d0*a*s 
                if (d .ge. 0.d0) then
                    f=(-b+sqrt(d))/(2.d0*a)
                else
                    f=0.d0
                endif

                if (f.ne. 0.d0 .and. f+kappa*y_a .gt. e_ta .and. f-kappa*y_a .gt. -e_ta)then
                    e0 = f
!                   BETON FISS RUPT / COMPRE ELAS / ACIER PLASTIQUE 
                    cas = 9
                    action = 5
                else
                    b=b-e_a*s_a
                    s=((c+1.d0)*(1.d0/(2.d0*kappa))*(e_t**2)-0.125d0*kappa*(h**2))*e_b
                    d=(b**2)-4.d0*a*s
                    if (d .ge. 0.d0)then
                        f=(-b+sqrt(d))/(2.d0*a)
                        e0 = f
!                       BETON FISS RUPT / COMPRE ELAS / ACIER PLASTIQUE TRAC
                        cas = 10
                        action = 5
                    else
                        action = 10
                    endif
                endif
            endif
        else
!           sortie sans solution  
            action = 10
        endif
    endif

!   VERIFICATION DE LA COMPRESSION DU BETON     
    if (action .eq. 5)then
!       si on a passe la limite en compression 
        if (f-0.5d0*kappa*h .lt. e_c)then
            a=0.d0 
            b= 2*e_a*s_a+(f_c/kappa) 
            s=((c+1.d0)*(1.d0/(2.d0*kappa))*(e_t**2))*e_b+(0.5d0*f_c**2)/(e_b*kappa)-0.5d0*h*f_c
            f=-s/b
            if (f+kappa*y_a .lt. e_ta .and. f-kappa*y_a .gt. -e_ta) then
                e0 = f
!               BETON FISS RUPT / COMPRESSION / ACIER ELASTIQUE
                cas = 11
            else  
                b=b-e_a*s_a
                s=s+e_a*s_a*(e_ta-kappa*y_a)
                f=-s/b
                if (f+kappa*y_a .gt. e_ta .and. f-kappa*y_a .gt. -e_ta)then
                    e0 = f
!                   BETON FISS RUPT / COMPRESSION / ACIER PLASTIQUE    
                    cas = 12
                else
                    b=b-e_a*s_a
                    s=((c+1.d0)*(1.d0/(2.d0*kappa))*(e_t**2))*e_b&
                      +(0.5d0*f_c**2)/(e_b*kappa)-0.5d0*h*f_c
                    f=-s/b
                    e0 = f
!                   BETON FISS RUPT / COMPRESSION / ACIERS PLASTIQUES
                    cas = 13
                endif
            endif
            action = 0  
        else
            action = 0
        endif
    endif
            
    ASSERT(action.eq.0)

end subroutine
