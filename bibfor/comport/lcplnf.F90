! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1504
!
subroutine lcplnf(rela_comp, vind, nbcomm, nmat, cpmono,&
                  materd, materf, iter, nvi, itmax,&
                  toler, pgl, nfs, nsg, toutms,&
                  hsr, dt, dy, yd, yf,&
                  vinf, sigd, sigf,&
                  deps, nr, mod, timef,&
                  indi, vins, codret)
!
implicit none
!   POST-TRAITEMENTS SPECIFIQUES AUX LOIS
!
!   CORRESPONDANCE ENTRE LES VARIABLES INTERNES ET LES EQUATIONS
!          DU SYSTEME DIFFERENTIEL APRES INTEGRATION
!
!   CAS GENERAL :
!      COPIE DES YF DANS VINF
!      LA DERNIERE C'EST TOUJOURS L'INDICATEUR PLASTIQUE
!
!   CAS PARTICULIER DU  MONOCRISTAL  :
!       ON GARDE 1 VARIABLE INTERNE PAR SYSTEME DE GLISSEMENT SUR 3
!       DEFORMATION PLASTIQUE EQUIVALENTE CUMULEE MACROSCOPIQUE
! ----------------------------------------------------------------
!  IN
!     LOI    :  NOM DE LA LOI
!     VIND   :  VARIABLE INTERNES A T
!     MATERD :  COEF MATERIAU A T
!     MATERF :  COEF MATERIAU A T+DT
!     NBCOMM :  INCIDES DES COEF MATERIAU
!     NMAT   :  DIMENSION MATER ET DE NBCOMM
!     NVI    :  NOMBRE DE VARIABLES INTERNES
!     DT     : INCREMENT DE TEMPS
!     NR     : DIMENSION VECTEUR INCONNUES (YF/DY)
!     YF     : EQUATIONS DU COMPORTEMENT INTEGRES A T+DT
!     DY     : INCREMENT DES VARIABLES INTERNES
!     TIMED  : INSTANT T
!     TIMEF  : INSTANT T+DT
!     INDI   : INDICATEUR MECANIQMES POT. ACTIFS (HUJEUX)
!     VINS   : VARIABLES INTERNES A T (ORIGINAL - HUJEUX)
!  OUT
!     VINF   :  VARIABLES INTERNES A T+DT
! ----------------------------------------------------------------
#include "asterfort/burlnf.h"
#include "asterfort/hujlnf.h"
#include "asterfort/irrlnf.h"
#include "asterfort/lcdpec.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcopli.h"
#include "asterfort/lcprmv.h"
#include "asterfort/lcprsv.h"
#include "asterfort/lkilnf.h"
#include "asterfort/srilnf.h"
    integer :: ndt, nvi, nmat, ndi, nbcomm(nmat, 3), iter, itmax, nr, codret
    integer :: nfs, nsg, indi(7), i
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2), vins(nvi), timef
    real(kind=8) :: pkc, m13, dtot, hookf(6, 6)
    real(kind=8) :: yd(*), vind(*), toler, pgl(3, 3), dt
    real(kind=8) :: toutms(nfs, nsg, 6), hsr(nsg, nsg), dy(*), yf(*), vinf(*)
    character(len=16) :: rela_comp
    character(len=24) :: cpmono(5*nmat+1)
    character(len=8) :: mod
    real(kind=8) :: sigf(6), deps(*), sigd(6)
!
    common /tdim/   ndt  , ndi
! --- -------------------------------------------------------------
!
!     MISE A JOUR DE SIGF , VINF
    call lceqvn(ndt, yf(1), sigf)
!
    if (rela_comp(1:8) .eq. 'MONOCRIS') then
! ---    DEFORMATION PLASTIQUE EQUIVALENTE CUMULEE MACROSCOPIQUE
        call lcdpec(vind, nbcomm, nmat, ndt, cpmono,&
                    materf, iter, nvi, itmax, toler,&
                    pgl, nfs, nsg, toutms, hsr,&
                    dt, dy, yd, vinf,&
                    sigf, deps, nr, mod,&
                    codret)
!
    else if (rela_comp(1:7).eq.'IRRAD3M') then
        call irrlnf(nmat, materf, yf(ndt+1), 1.0d0, vinf)
    else if (rela_comp(1:12) .eq. 'BETON_BURGER') then
        call burlnf(nvi, vind, nmat, materd, materf,&
                    dt, nr, yd, yf, vinf,&
                    sigf)
    else if (rela_comp(1:4) .eq. 'LETK') then
        call lkilnf(nvi, vind, nmat, materf, dt,&
                    sigd, nr, yd, yf, deps,&
                    vinf)
    else if (rela_comp(1:3).eq.'LKR') then
        call srilnf(nvi,vind,nmat,materf,dt,&
                    nr,yf,deps,vinf)
    else if (rela_comp .eq. 'HAYHURST') then
!        DEFORMATION PLASTIQUE CUMULEE
        vinf(7) = yf(ndt+1)
!        H1
        vinf(8) = yf(ndt+2)
!        H2
        vinf(9) = yf(ndt+3)
!        PHI
        pkc=materf(11,2)
        m13=-1.d0/3.d0
        vinf(10)=1.d0-(1.d0+pkc*timef)**m13
!        DEFORMATION PLASTIQUE
!        D
        vinf(11) = yf(ndt+4)
        dtot=(1.d0-vinf(11))
        call lcopli('ISOTROPE', mod, materf(1, 1), hookf)
        call lcprmv(hookf, yf, sigf)
        call lcprsv(dtot, sigf, sigf)
        do i = 1, ndt
            vinf(i) = yf(i)
        end do
        vinf(nvi) = iter
    else if (rela_comp(1:6) .eq. 'HUJEUX') then
        call hujlnf(toler, nmat, materf, nvi, vind,&
                    vinf, vins, nr, yd, yf,&
                    sigd, sigf, indi, codret)
    else
!        CAS GENERAL :
        call lceqvn(nvi-1, yf(ndt+1), vinf)
        vinf(nvi) = iter
    endif
!
end subroutine
