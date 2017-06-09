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

subroutine jjlidy(iadyn, iadmi)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "jeveux_private.h"
#include "asterc/hpdeallc.h"
#include "asterfort/assert.h"
    integer :: iadyn, iadmi
! ----------------------------------------------------------------------
! MISE A JOUR DU COMPTEUR DES SEGMENTS DE VALEURS U ET LIBERATION
! DU SEGMENT DE VALEURS
!
! IN  IADYN  : ADRESSE DYNAMIQUE DU SEGMENT DE VALEUR
! IN  IADMI  : ADRESSE DU PREMIER MOT DU SEGMENT DE VALEUR
!
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
! ----------------------------------------------------------------------
    real(kind=8) :: mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio, cuvtrav
    common /r8dyje/ mxdyn ,mcdyn, mldyn, vmxdyn, vmet, lgio(2), cuvtrav
    integer :: ldyn, lgdyn, nbdyn, nbfree
    common /idynje/  ldyn , lgdyn , nbdyn , nbfree
    integer :: istat
    common /istaje/  istat(4)
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    real(kind=8) :: svuse, smxuse
    common /statje/  svuse,smxuse
    integer :: lundef, idebug
    common /undfje/  lundef,idebug
! ----------------------------------------------------------------------
    integer :: iet, lgs, lgsv, k
! DEB ------------------------------------------------------------------
    if (iadyn .ne. 0) then
        iet = iszon(jiszon+iadmi-1)
        lgs = iszon(jiszon+iadmi-4) - iadmi + 4
        lgsv= iszon(jiszon+iadmi-4) - iadmi - 4
        do 100 k = 1, lgsv
            iszon(jiszon+iadmi+k-1) = lundef
100      continue
        if (iet .eq. istat(2)) then
            svuse = svuse - lgs
            ASSERT(lgs .gt. 0)
            smxuse = max(smxuse,svuse)
        endif
        mcdyn = mcdyn - lgs
        mldyn = mldyn + lgs
        call hpdeallc(iadyn, nbfree)
    endif
! FIN ------------------------------------------------------------------
end subroutine
