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

subroutine calc_glrcdm_err(l_calc, commax, flexmax, gamma_f,&
                           gamma_c, epsi_c, h, valpar, errcom, errflex)
! 
    implicit none
!
! PARAMETRES ENTRANTS
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calc_axe_neutre.h"
#include "asterfort/calc_moment.h"
    real(kind=8) :: commax, flexmax, gamma_f, gamma_c, epsi_c
    real(kind=8) :: h, valpar(*)
    aster_logical :: l_calc(2)
!
! PARAMETRES SORTANTS
    real(kind=8) :: errcom, errflex 

! PARAMETRES INTERNES
    real(kind=8) :: rx, omx, ea, sya, ftj, fcj, nyc, ey, area1, area2
    real(kind=8) :: omy, b, a, ry, pentelf, kappay, e_t, dkappa, kappa
    real(kind=8) :: e0, c, effort, moment, coef, em ,ef, myf
    integer :: nb_decoup, cas, i
    
    rx = valpar(1)
    omx = valpar(2)
    ea = valpar(3)
    sya = valpar(4)
    ftj = valpar(5)
    fcj = valpar(6)
    em = valpar(7)
    ef = valpar(8)
    nyc = valpar(9)
    myf = valpar(10)
    omy = omx
    ry = rx
    
    c = 1.d0
    
    ! section acier sup et inf omx et omy 
    b = ea*(omx+omy) 
    ! coef a 
    a = ea*(omx+omy)*((0.5d0*rx+0.5d0*ry)/2.d0)**2


! - erreur en compression

    if (l_calc(1)) then
 
!       aire sous la courbe approximee
        ey = nyc/em
        if (commax .lt. ey)then
           area1 = 0.5d0*em*commax**2
        else
           area1 = 0.5d0*em*ey**2+nyc*(commax-ey)+0.5d0*gamma_c*em*(commax-ey)**2
        endif
           
        ! aire sous la courbe theorique
        if (commax .lt. epsi_c)then  
            area2 = (fcj*commax-fcj/(3.d0*epsi_c**2)*((commax-epsi_c)**3+epsi_c**3))&
                    *h+b*commax*commax*0.5
        else
            area2 = (fcj*epsi_c-fcj/(3*epsi_c**2)*(epsi_c**3)+fcj*(commax-epsi_c))&
                    *h+b*commax*commax*0.5   
        endif
        
        if (area2 .eq. 0.d0)then
            errcom = 0.d0
        else
            errcom = abs(area1-area2)/area2*100.d0
        endif
    endif

! - erreur en flexion

    if (l_calc(2)) then
    
        pentelf = ((1.d0/12.d0)*ef*(h**3)+2.d0*ea*omx*((rx*h/2.d0)**2))

        ! aire sous la courbe approx 
        kappay = myf/pentelf 
        if (flexmax .lt. kappay)then
           area1 = 0.5d0*pentelf*flexmax**2
        else
           area1 = 0.5d0*pentelf*kappay**2+myf*(flexmax-kappay)&
                  +0.5d0*gamma_f*pentelf*(flexmax-kappay)**2
        endif
        
    !   aire sous la courbe theorique 
        
        nb_decoup = 100
        e_t=ftj/ef
        kappay = (2.d0*e_t)/h
        dkappa = (flexmax-kappay)/nb_decoup
        
        if (flexmax .lt. kappay) then
            area2 = 0.5d0*pentelf*flexmax**2
        else
            area2 = 0.5d0*pentelf*kappay**2
            do i =0, nb_decoup
                kappa = kappay+dkappa*i
                
                call calc_axe_neutre(ef, ftj, fcj, c, h, ea, omx,&
                                    rx*h/2.d0, sya, kappa,&
                                    e0, cas)
                
                call calc_moment(e0, kappa, ef, ftj, fcj, c, h, ea, omx, rx*h/2.d0,& 
                                 sya, cas, effort, moment)
                                 
                if (i.eq.0 .or. i.eq.nb_decoup)then
                    coef = 0.5d0
                else 
                    coef = 1.d0
                endif
                area2 = area2 + moment*dkappa*coef 
            enddo
        endif

        if (area2 .eq. 0.d0)then
            errflex = 0.d0
        else
            errflex = abs(area1-area2)/area2*100.d0
        endif
    endif

end subroutine
