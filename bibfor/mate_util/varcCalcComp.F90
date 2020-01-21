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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine varcCalcComp(modelz, chsithz   ,&
                        l_temp, l_hydr    , l_ptot,&
                        l_sech, l_epsa    ,&
                        nbin  , nbout     ,&
                        lpain , lchin     ,&
                        lpaout, lchout    ,&
                        base  , vect_elemz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/gcnco2.h"
#include "asterfort/corich.h"
#include "asterfort/reajre.h"
!
character(len=*), intent(in) :: modelz, chsithz
aster_logical, intent(in)  :: l_temp, l_hydr, l_ptot, l_sech, l_epsa
integer, intent(in) :: nbin, nbout
character(len=8), intent(in) :: lpain(*), lpaout(*)
character(len=19), intent(in) :: lchin(*)
character(len=19), intent(inout) :: lchout(*)
character(len=1), intent(in) :: base
character(len=*), intent(in) :: vect_elemz
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Calls to CALCUL
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  chsith           : commande variable for temperature in XFEM
! In  l_temp           : .true. if temperature exists
! In  l_hydr           : .true. if hydratation exists
! In  l_ptot           : .true. if total pressure (THM) exists
! In  l_sech           : .true. if drying exists
! In  l_epsa           : .true. if non-elastic strain exists
! In  nbin             : effective number of input fields
! In  nbout            : effective number of output fields
! In  lpain            : list of input parameters
! In  lchin            : list of input fields
! In  lpaout           : list of output parameters
! IO  lchout           : list of output fields
! In  base             : JEVEUX base to create objects
! In  vect_elem        : name of elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: newnom
    character(len=16) :: option
    character(len=19) :: resu_elem, ligrmo
    integer :: ibid
!
! --------------------------------------------------------------------------------------------------
!
    ligrmo    = modelz(1:8)//'.MODELE'
    newnom    = '.0000000'
    resu_elem = vect_elemz(1:8)//'.0000000'
!
! - Temperature
!
    if (l_temp) then
        call gcnco2(newnom)
        resu_elem(10:16) = newnom(2:8)
        call corich('E', resu_elem, -1, ibid)
        lchout(1) = resu_elem
        option = 'CHAR_MECA_TEMP_R'
        if (nbout .eq. 2) then
            lchout(2) = chsithz(1:19)
        endif
        call calcul('C'  , option, ligrmo, nbin  , lchin,&
                    lpain, nbout , lchout, lpaout, base ,&
                    'OUI')
        call reajre(vect_elemz, resu_elem, base)
    endif
!
! - Hydratation
!
    if (l_hydr) then
        call gcnco2(newnom)
        resu_elem(10:16) = newnom(2:8)
        call corich('E', resu_elem, -1, ibid)
        lchout(1) = resu_elem
        option = 'CHAR_MECA_HYDR_R'
        call calcul('C'  , option, ligrmo, nbin  , lchin,&
                    lpain, nbout , lchout, lpaout, base ,&
                    'OUI')
        call reajre(vect_elemz, resu_elem, base)
    endif
!
! - Total pressure (THM)
!
    if (l_ptot) then
        call gcnco2(newnom)
        resu_elem(10:16) = newnom(2:8)
        call corich('E', resu_elem, -1, ibid)
        lchout(1) = resu_elem
        option = 'CHAR_MECA_PTOT_R'
        call calcul('C'  , option, ligrmo, nbin  , lchin,&
                    lpain, nbout , lchout, lpaout, base ,&
                    'OUI')
        call reajre(vect_elemz, resu_elem, base)
    endif
!
! - Drying
!
    if (l_sech) then
        call gcnco2(newnom)
        resu_elem(10:16) = newnom(2:8)
        call corich('E', resu_elem, -1, ibid)
        lchout(1) = resu_elem
        option = 'CHAR_MECA_SECH_R'
        call calcul('C'  , option, ligrmo, nbin  , lchin,&
                    lpain, nbout , lchout, lpaout, base ,&
                    'OUI')
        call reajre(vect_elemz, resu_elem, base)
    endif
!
! - Non-elastic strain
!
    if (l_epsa) then
        call gcnco2(newnom)
        resu_elem(10:16) = newnom(2:8)
        call corich('E', resu_elem, -1, ibid)
        lchout(1) = resu_elem
        option = 'CHAR_MECA_EPSA_R'
        call calcul('C'  , option, ligrmo, nbin  , lchin,&
                    lpain, nbout , lchout, lpaout, base ,&
                    'OUI')
        call reajre(vect_elemz, resu_elem, base)
    endif
!
end subroutine
