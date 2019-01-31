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

subroutine calc_myf_gf(em, ftj, fcj, h, ea, omx, & 
                       ya, sya, ipenteflex, kappa_flex,&
                       myf, gf)
! 
    implicit none
!
! PARAMETRES ENTRANTS
#include "asterfort/assert.h"
#include "asterfort/calc_axe_neutre.h"
#include "asterfort/calc_moment.h"
#include "asterfort/utmess.h"
    real(kind=8) :: em, ftj, fcj, h, ea, omx, ya, sya, kappa_flex
    integer :: ipenteflex
!
! PARAMETRES SORTANTS
    real(kind=8) :: gf, myf
!
! RESONSABLE
! ----------------------------------------------------------------------
!
! BUT : CALCUL DES PARAMETRES D'ENDOMMAGEMENT GAMMA_T, GAMMA_C
!       ET GAMMA_F
!
! IN:
!       EM    : MODULE D YOUNG EN MEMBRANE
!       EF    : MODULE D YOUNG EN FLEXION
!       H     : EPAISSEUR DE LA PLAQUE
!       EA    : MODULES D YOUNG DES ACIERS
!       SYA   : LIMITES ELASTIQUES DES ACIERS
!       SYT   : SEUIL D'ENDOMMAGEMENT EN TRACTION
!       SYC   : SEUIL D'ENDOMMAGEMENT EN COMPRESSION

!       IPENTE: OPTION DE CALCUL DES PENTES POST ENDOMMAGEMENT
!               1 : RIGI_ACIER
!               2 : PLAS_ACIER
!               3 : UTIL
! OUT:
!       GF    : GAMMA DE FLEXION
!       MYF   : MOMENT DE FLEXION
! ----------------------------------------------------------------------
! PARAMETRES INTERMEDIAIRES
    integer :: nb_decoup, ind_s, i, cas
    real(kind=8) :: e_t, e_c, e_u, kappa_y, kappa_test, pentelf
    real(kind=8) :: kappa_s, dpent_min, pendt_c, kappa_c, momen_c
    real(kind=8) :: kappa_f, momen_f, pendt_f, dkappa, dpent_p, kappa
    real(kind=8) :: effort, moment, moelas, dmom, kappa1, moment1, moment2
    real(kind=8) :: kappa2, pendt_cc, pendt_d, dpent, kappa_r, momen_r
    real(kind=8) :: area, coef, darea_min, aread, darea, c, e0, pendt

    c= 1.d0
    
    e_t=ftj/em
    e_c=-fcj/em
    e_u=(1.d0+c)*e_t
    kappa_y = (2.d0*e_t)/h
    
    kappa_test = min(-2.d0*e_c/h,2*e_u/h)
    !ASSERT(kappa_test .gt. kappa_y)
    
    pentelf = ((1.d0/12.d0)*em*(h**3)+2.d0*ea*omx*(ya**2))
    
    if (ipenteflex .eq. 1)then
        nb_decoup = 1000
        ind_s = 0 
        myf = 0.d0
        kappa_s = 0.d0
        
        dpent_min = pentelf 
        
        pendt_c = pentelf
        kappa_c = 0.d0
        momen_c = 0.d0
        
        kappa_f = 0.d0
        momen_f = 0.d0
        pendt_f = 0.d0
        
        dkappa = (kappa_test-kappa_y)/nb_decoup
        dpent_p = pentelf
        do i = 0, nb_decoup-1
            kappa = kappa_y + dkappa*i
            call calc_axe_neutre(em, ftj, fcj, c, h, ea, omx, ya, sya, kappa,&
                                 e0, cas)
            call calc_moment(e0, kappa, em, ftj, fcj, c, h, ea, omx, ya, sya, cas,&
                             effort, moment)
            call calc_moment(0.d0, kappa, em, ftj, fcj, c, h, ea, omx, ya, sya, 1,&
                            effort, moelas)
            
            dmom = abs(moment-moelas)/moelas
            if (dmom .lt. 5.d0/100.d0)then
                ind_s = i
            elseif (ind_s .eq. i-1)then
!           le point seuil est selectionne 
                kappa_s = kappa
                myf = moelas 
            else    
!               calcul de la tangente a la courbe en ce point 
                kappa1 = kappa-dkappa/2.d0 
                call calc_axe_neutre(em, ftj, fcj, c, h, ea, omx, ya, sya, kappa1,&
                                 e0, cas)

                call calc_moment(e0, kappa1, em, ftj, fcj, c, h, ea, omx, ya, sya, cas,&
                             effort, moment1)

                kappa2 = kappa+dkappa/2.d0
                call calc_axe_neutre(em, ftj, fcj, c, h, ea, omx, ya, sya, kappa2,&
                                 e0, cas)

                call calc_moment(e0, kappa2, em, ftj, fcj, c, h, ea, omx, ya, sya, cas,&
                             effort, moment2)
                
                pendt_cc = (moment2-moment1)/dkappa
                if (pendt_cc .gt. 0.d0 .and. pendt_cc .lt. pendt_c) then
                    pendt_c = pendt_cc
                    kappa_c = kappa 
                    momen_c = moment
                endif
!               tangente 
                pendt_d = (moment-myf)/(kappa-kappa_s)
                if (pendt_d .gt. 0.d0) then
                    dpent = abs(pendt_d-pendt_cc)
                    if (dpent .lt. dpent_min .and. dpent .lt. dpent_p)then
                        kappa_f = kappa 
                        momen_f = moment
                        dpent_min = dpent
                        pendt_f = pendt_d
                    endif
                    if (dpent .gt. dpent_p .and. dpent_min .lt. pentelf)then
                        dpent_p = 0.d0 
                    else
                        dpent_p = dpent
                    endif
                endif
            endif
        enddo
        kappa_r =  kappa_f
        momen_r =  momen_f   
        if  (kappa_f .eq. 0.d0) then 
!       aucun point n'a ete selectionne, il faut modifier My 
            pendt_f = pendt_c
            kappa_s = (momen_c-pendt_c*kappa_c)/(pentelf-pendt_f)
            myf = pentelf*kappa_s
            kappa_r =  kappa_c
            momen_r =  momen_c  
            call utmess('A', 'ALGORITH6_34')
        endif
    elseif (ipenteflex .eq. 2) then
        if (kappa_flex .gt. kappa_y)then
            nb_decoup = 10000
            dkappa = (kappa_flex-kappa_y)/nb_decoup
            area = 0.d0
            coef = 1.d0
            do i = 0, nb_decoup
                kappa = kappa_y+dkappa*i
                
                call calc_axe_neutre(em, ftj, fcj, c, h, ea, omx, ya, sya, kappa,&
                                 e0, cas)
                call calc_moment(e0, kappa, em, ftj, fcj, c, h, ea, omx, ya, sya, cas,&
                             effort, moment)

                if (i.eq.0 .or. i.eq. nb_decoup)then
                    coef = 0.5d0
                else
                    coef = 1.d0
                endif
                area = area + moment*dkappa*coef 
            enddo
            momen_r = moment            
            kappa_s = kappa_y 
            darea_min = area 
            do i = 0, nb_decoup-1
                kappa = kappa_y+dkappa*i
                aread = pentelf*(kappa_y+kappa)/2.d0*(kappa-kappa_y)
                aread =aread + (momen_r+pentelf*kappa)/2.d0*(kappa_flex-kappa)
                darea = abs(aread-area)
                pendt = (momen_r-pentelf*kappa)/(kappa_flex-kappa) 
                if (darea .lt. darea_min .and. pendt .gt. 0.d0)then
                    kappa_s = kappa 
                    darea_min = darea
                endif
            enddo
            myf =  pentelf*kappa_s
            kappa_r = kappa_flex     
                
            pendt_f = (momen_r-myf)/(kappa_r-kappa_s)    
        else
            call utmess('A', 'ALGORITH6_35', sr=kappa_y)
            kappa_s = kappa_y 
            myf = pentelf*kappa_y
            kappa_r = kappa_y 
            momen_r = pentelf*kappa_y
            pendt_f = 0.d0
        endif
        
        if (pendt_f .lt. 0.d0)then
            call utmess('A', 'ALGORITH6_36', sr=kappa_y)
            pendt_f = 0.d0
            kappa_s = kappa_y
            myf =  pentelf*kappa_y
            kappa_r = kappa_flex 
            momen_r = pentelf*kappa_y
        endif
    else
        ASSERT(.false.)
    endif

    gf = pendt_f/pentelf
!
end subroutine
