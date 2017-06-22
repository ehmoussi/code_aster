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

subroutine mlnmin(nu, nomp01, nomp02, nomp03, nomp04,&
                  nomp05, nomp06, nomp07, nomp08, nomp09,&
                  nomp10, nomp11, nomp12, nomp13, nomp14,&
                  nomp15, nomp16, nomp17, nomp18, nomp19,&
                  nomp20)
!     ------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
! aslint: disable=W1504
    implicit none
    character(len=14) :: nu
    character(len=24) :: nomp01, nomp02, nomp03, nomp04, nomp05, nomp06, nomp07
    character(len=24) :: nomp08, nomp09, nomp10, nomp11, nomp12, nomp13, nomp14
    character(len=24) :: nomp15, nomp16, nomp17, nomp18, nomp19, nomp20
    nomp01 = nu(1:14)//'.MLTF.DESC'
    nomp02 = nu(1:14)//'.MLTF.DIAG'
    nomp03 = nu(1:14)//'.MLTF.ADRE'
    nomp04 = nu(1:14)//'.MLTF.SUPN'
    nomp05 = nu(1:14)//'.MLTF.PARE'
    nomp06 = nu(1:14)//'.MLTF.FILS'
    nomp07 = nu(1:14)//'.MLTF.FRER'
    nomp08 = nu(1:14)//'.MLTF.LGSN'
    nomp09 = nu(1:14)//'.MLTF.LFRN'
    nomp10 = nu(1:14)//'.MLTF.NBAS'
    nomp11 = nu(1:14)//'.MLTF.DEBF'
    nomp12 = nu(1:14)//'.MLTF.DEFS'
    nomp13 = nu(1:14)//'.MLTF.ADPI'
    nomp14 = nu(1:14)//'.MLTF.ANCI'
    nomp15 = nu(1:14)//'.MLTF.NBLI'
    nomp16 = nu(1:14)//'.MLTF.LGBL'
    nomp17 = nu(1:14)//'.MLTF.NCBL'
    nomp18 = nu(1:14)//'.MLTF.DECA'
    nomp19 = nu(1:14)//'.MLTF.NOUV'
    nomp20 = nu(1:14)//'.MLTF.SEQU'
end subroutine
