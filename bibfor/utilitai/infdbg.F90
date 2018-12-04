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

subroutine infdbg(optioz, ifm, niv)
!
implicit none
!
#include "asterfort/infniv.h"
!
character(len=*) :: optioz
integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
! ROUTINE POUR AFFICHAGE INFOS DEBUG
!
! POUR L'INSTANT, ON DECONNECTE (FICHE 10620 DU REX)
!
! ----------------------------------------------------------------------
!
!
! IN  OPTION : OPTION DE DEBUGGAGE
!                'CONTACT': DEBUG POUR LE CONTACT
! OUT IFM    : UNITE D'IMPRESSION
! OUT NIV    : NIVEAU D'IMPRESSION
!
! ----------------------------------------------------------------------
!
    character(len=16) :: czcont, czmeca, czpilo, czfact, czappa, czsolv
    common /czdbg/czcont,czmeca,czpilo,czfact,czappa, czsolv
    character(len=16) :: option
!
! ----------------------------------------------------------------------
!
    option = optioz
!
    if (option .eq. 'CONTACT') then
        call infniv(ifm, niv)
        if (czcont .ne. 'CONTACT') niv=1
    else if (option.eq.'XFEM') then
        call infniv(ifm, niv)
    elseif (option.eq.'MECANONLINE') then
        call infniv(ifm, niv)
        if (czmeca .ne. 'MECANONLINE') niv=1
    else if (option.eq.'PRE_CALCUL') then
        call infniv(ifm, niv)
        niv = 1
    else if (option.eq.'PILOTE') then
        call infniv(ifm, niv)
        if (czpilo .ne. 'PILOTE') niv=1
    else if (option .eq.'SOLVEUR') then
        call infniv(ifm, niv)
        if (czsolv .ne. 'SOLVEUR') niv=1
    else if (option .eq.'FACTOR') then
        call infniv(ifm, niv)
        if (czfact .ne. 'FACTOR') niv=1
    else if (option.eq.'APPARIEMENT') then
        call infniv(ifm, niv)
        if (czappa .ne. 'APPARIEMENT') niv=1
    else
        call infniv(ifm, niv)
    endif
!
end subroutine
