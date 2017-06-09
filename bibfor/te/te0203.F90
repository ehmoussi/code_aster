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

subroutine te0203(option, nomte)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/pipefi.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: nomte, option
!
!-----------------------------------------------------------------------
!
!     BUT: PILOTAGE POUR LES ELEMENTS DE JOINT
!
!     OPTION : PILO_PRED_ELAS
!
!-----------------------------------------------------------------------
!
!
!
    integer :: igeom, imater, ideplm, ivarim, npg, jtab(7), iret, lgpg
    integer :: iddepl, idepl0, idepl1, ictau, icopil
    character(len=8) :: typmod(2)
!
!    PARAMETRES DE L'ELEMENT FINI
    npg=2
!
! - PARAMETRES EN ENTREE
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imater)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDDEPLR', 'L', iddepl)
    call jevech('PDEPL0R', 'L', idepl0)
    call jevech('PDEPL1R', 'L', idepl1)
    call jevech('PCDTAU', 'L', ictau)
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else
        typmod(1) = 'PLAN'
    endif
    typmod(2) = 'ELEMJOIN'
!
! RECUPERATION DU NOMBRE DE VARIABLES INTERNES PAR POINTS DE GAUSS :
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! PARAMETRE EN SORTIE
!
    call jevech('PCOPILO', 'E', icopil)
!
    call pipefi(npg, lgpg, zi(imater), zr(igeom), zr(ivarim),&
                zr(iddepl), zr(ideplm), zr(idepl0), zr(idepl1), zr(ictau),&
                zr(icopil), typmod)
!
end subroutine
