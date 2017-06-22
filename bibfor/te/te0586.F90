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

subroutine te0586(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tufull.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!
!    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
!                          TUYAU
!                          OPTION : RIGI_MECA_TANG, FULL_MECA
!                                   RAPH_MECA
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: nbrddm
    parameter (nbrddm=156)
    integer :: m, nbrddl, jcret, codret
    integer :: ndim, nnos, nno, jcoopg, idfdk, jdfd2, jgano
    integer :: npg, ipoids, ivf
    real(kind=8) :: deplm(nbrddm), deplp(nbrddm), vtemp(nbrddm)
    real(kind=8) :: b(4, nbrddm)
    real(kind=8) :: ktild(nbrddm, nbrddm), effint(nbrddm)
    real(kind=8) :: pass(nbrddm, nbrddm)
!
!      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
!
!     RECUPERATION DES OBJETS
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jcoopg=jcoopg,jvf=ivf,jdfde=idfdk,&
  jdfd2=jdfd2,jgano=jgano)
!
!
    m = 3
    if (nomte .eq. 'MET6SEG3') m = 6
!
!     FORMULE GENERALE
!
    nbrddl = nno* (6+3+6* (m-1))
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
    call tufull(option, nomte, nbrddl, deplm, deplp,&
                b, ktild, effint, pass, vtemp,&
                codret)
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call jevech('PCODRET', 'E', jcret)
        zi(jcret) = codret
    endif
!
end subroutine
