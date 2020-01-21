! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
interface
    subroutine varcCalcPrep(modelz    , cara_elemz, matez     ,&
                            nume_harm , time_comp ,&
                            l_temp    , l_meta    ,&
                            varc_refez, varc_prevz, varc_currz,&
                            comporz   , mult_compz, chsithz   ,&
                            sigmz     , variz     ,&
                            mxchin    , mxchout   ,&
                            nbin      , nbout     ,&
                            lpain     , lchin     ,&
                            lpaout    , lchout)
        character(len=*), intent(in) :: modelz, cara_elemz, matez
        aster_logical, intent(in) :: l_temp, l_meta
        integer, intent(in) :: nume_harm
        character(len=1), intent(in) :: time_comp
        character(len=*), intent(in) :: varc_refez, varc_prevz, varc_currz
        character(len=*), intent(in) :: comporz, mult_compz, chsithz
        character(len=*), intent(in) :: sigmz, variz
        integer, intent(in) :: mxchin, mxchout
        integer, intent(out) :: nbin, nbout
        character(len=8), intent(out)  :: lpaout(mxchout), lpain(mxchin)
        character(len=19), intent(out)  :: lchout(mxchout), lchin(mxchin)
    end subroutine varcCalcPrep
end interface
