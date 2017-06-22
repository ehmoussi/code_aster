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

subroutine ef0585(nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/tuforc.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: nomte
!     CALCUL DE EFGE_ELNO
!     ------------------------------------------------------------------
!
    integer :: nbrddm
    parameter(nbrddm=156)
    real(kind=8) :: b(4, nbrddm), f(nbrddm)
    real(kind=8) :: vin(nbrddm), vout(nbrddm), mat(nbrddm, 4)
    real(kind=8) :: vtemp(nbrddm), pass(nbrddm, nbrddm)
!
!     CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
!
    integer :: ndim, nnos, nno, jcoopg, idfdk, jdfd2, jgano
    integer :: npg, ipoids, ivf
    integer :: m, nbrddl
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jcoopg=jcoopg,jvf=ivf,jdfde=idfdk,&
  jdfd2=jdfd2,jgano=jgano)
!
    m=3
    if (nomte .eq. 'MET6SEG3') m=6
!
!     FORMULE GENERALE
!
    nbrddl=nno*(6+3+6*(m-1))
!
!     VERIFS PRAGMATIQUES
!
    if (nbrddl .gt. nbrddm) then
        call utmess('F', 'ELEMENTS4_40')
    endif
    if (nomte .eq. 'MET3SEG3') then
        if (nbrddl .ne. 63) then
            call utmess('F', 'ELEMENTS4_41')
        endif
    else if (nomte.eq.'MET6SEG3') then
        if (nbrddl .ne. 117) then
            call utmess('F', 'ELEMENTS4_41')
        endif
    else if (nomte.eq.'MET3SEG4') then
        if (nbrddl .ne. 84) then
            call utmess('F', 'ELEMENTS4_41')
        endif
    else
        call utmess('F', 'ELEMENTS4_42')
    endif
!
    call tuforc('EFGE_ELNO', nomte, nbrddl, b, f,&
                vin, vout, mat, pass, vtemp)
end subroutine
