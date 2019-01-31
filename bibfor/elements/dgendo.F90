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

subroutine dgendo(em, ef, h, ea, sya, fcj, ftj, epsi_c, omx, rx,&
                  syt, syc, num, pendt, pelast,&
                  icisai, gt,&
                  gf, gc, ipentetrac, ipenteflex, kapflex, np, dxp,&
                  b, myf, alpha_c)
!
    implicit none
!
! PARAMETRES ENTRANTS
#include "asterfort/utmess.h"
#include "asterfort/dgendo1.h"
#include "asterfort/calc_myf_gf.h"
    integer :: icisai, ipentetrac, ipenteflex
    real(kind=8) :: em, ef, h, syt, num, np, dxp, ea, sya, rx, omx
    real(kind=8) :: pendt, pendc, pelast, fcj, ftj, epsi_c
    real(kind=8) :: kapflex, b
!
! PARAMETRES SORTANTS
    real(kind=8) :: gt, gf, gc, syc, myf, alpha_c
!
! RESONSABLE
! ----------------------------------------------------------------------
!
! BUT : CALCUL DES PARAMETRES D'ENDOMMAGEMENT GAMMA_T, GAMMA_C
!       ET GAMMA_F + MYF et ALPHA_C
!
! IN:
!       EM    : MODULE D YOUNG EN MEMBRANE
!       EF    : MODULE D YOUNG EN FLEXION
!       H     : EPAISSEUR DE LA PLAQUE
!       EA    : MODULES D YOUNG DES ACIERS
!       SYA   : LIMITES ELASTIQUES DES ACIERS
!       SYT   : SEUIL D'ENDOMMAGEMENT EN TRACTION
!       NUM   : COEFF DE POISSON EN MEMBRANE
!       PENDT : PENTE POST ENDOMMAGEMENT EN MEMBRANNE
!       PELAST: PENTE ELASTIQUE EN TRACTION
!       ICISAI: INDICATEUR DE CISAILLEMENT
!       IPENTE: OPTION DE CALCUL DES PENTES POST ENDOMMAGEMENT
!               1 : RIGI_ACIER
!               2 : PLAS_ACIER
!               3 : UTIL
!       NP    : EFFORT A PLASTICITE
!       DXP   : DEPLACEMENT A PLASTICITE
! OUT:
!       GT    : GAMMA DE TRACTION
!       GF    : GAMMA DE FLEXION
!       GC    : GAMMA DE CISAILLEMENT
!       SYC   : SEUIL D'ENDOMMAGEMENT EN COMPRESSION
!       MYF   :
!       ALPHA_C :
! ----------------------------------------------------------------------
! PARAMETRES INTERMEDIAIRES
    real(kind=8) :: ya
    real(kind=8) :: sytxy, dxd, efm
    
    alpha_c = 1.d0

    gt=pendt/pelast
    
    call dgendo1(em, ea, sya, b, syt, h, fcj, epsi_c, num,&
                   gt, gc, syc, alpha_c)
!
! - PARAMETRES D'ENDOMMAGEMENT MENBRANAIRE EN CISAILLEMENT
!   PUR DANS LE PLAN
    if (icisai .eq. 1) then
! - On calule SYTXY a partir de GT et GC calculé en traction
        sytxy=syt/(1.d0+num)*sqrt(((1.d0-num)*(1.d0+2.d0*num)*&
        (1.d0-gt)+num**2*(1.d0-gc))/(2.d0-gc-gt))
        syt=sytxy
! - PENTE='PENTE_LIM'
        if (ipentetrac .eq. 1) then
            pendc=pendt
! - PENTE ='EPSI_MAX' OU PENTE = 'PLAS'
        else if ((ipentetrac .eq. 3) .or. (ipentetrac .eq. 2)) then
            dxd=sytxy/pelast
            pendc=(np-sytxy)/(dxp-dxd)
        endif

        gt=pendc/((em*h)/2.d0/(1.d0+num))
        call dgendo1(em, ea, sya, b, syt, h, fcj, epsi_c, num,&
                   gt, gc, syc, alpha_c)
    endif

    ya = rx*h
    efm = 1./12.*ef*h**3-2*ea*omx*(ya**2)
    efm = efm*12/(h**3)
    call calc_myf_gf(efm, ftj, fcj, h, ea, omx,& 
                       ya, sya, ipenteflex, kapflex,&
                       myf, gf)

    if (gt .lt. 1.d-3) then
        call utmess('A', 'ALGORITH6_4', sk='GAMMAT')
        gt = 1.d-3
    endif
    if (gc .lt. 1.d-3) then
        call utmess('A', 'ALGORITH6_4', sk='GAMMAC')
        gc = 1.d-3
    endif
    if (gf .lt. 1.d-3) then
        call utmess('A', 'ALGORITH6_4', sk='GAMMAF')
        gf = 1.d-3
    endif
    if (alpha_c .lt. 1.d-3) then
        call utmess('A', 'ALGORITH6_4', sk='ALPHAC')
        alpha_c = 1.d-3
    endif
!
end subroutine
