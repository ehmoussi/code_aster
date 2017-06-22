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

function cotsti(typsup)
    implicit none
    character(len=16) :: typsup, cotsti
!     BUT : DETERMINER LE TYPE "INFORMATIQUE" CORRESPONDANT A
!           UN TYPE "SUPERVISEUR"
!======================================================================
#include "jeveux.h"
!
    character(len=16) :: typinf
!----------------------------------------------------------------------
!
    if (typsup .eq. 'LISTR8_SDASTER') then
        typinf='LISTR8'
    else if (typsup.eq.'LISTIS_SDASTER') then
        typinf='LISTIS'
    else if (typsup.eq.'MAILLAGE_SDASTER') then
        typinf='MAILLAGE'
    else if (typsup.eq.'MODELE_SDASTER') then
        typinf='MODELE'
    else if (typsup.eq.'FONCTION_SDASTER') then
        typinf='FONCTION'
    else if (typsup.eq.'NAPPE_SDASTER') then
        typinf='FONCTION'
    else if (typsup.eq.'TABLE_SDASTER') then
        typinf='TABLE'
    else if (typsup.eq.'EVOL_ELAS') then
        typinf='RESULTAT'
    else if (typsup.eq.'EVOL_NOLI') then
        typinf='RESULTAT'
    else if (typsup.eq.'EVOL_THER') then
        typinf='RESULTAT'
    else if (typsup.eq.'CABL_PRECONT') then
        typinf='CABL_PRECONT'
    else
        typinf='INCONNU'
    endif
    cotsti=typinf
end function
