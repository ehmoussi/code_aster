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

subroutine calc_coor_elga(ligrel, chgeom, chgaus)
!
implicit none
!
#include "asterfort/calcul.h"
#include "asterfort/dismoi.h"
!
!
    character(len=19), intent(in) :: ligrel
    character(len=19), intent(in) :: chgeom
    character(len=19), intent(in) :: chgaus
!
! --------------------------------------------------------------------------------------------------
!
! Compute <CARTE> with informations on Gauss points 
!
! --------------------------------------------------------------------------------------------------
!
! In  ligrel     : list of elements where computing
! In  chgeom     : name of <CARTE> for geometry
! In  chgaus     : name of <CARTE> with informations on Gauss points 
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: lpain(5), lpaout(1), mo
    character(len=16) :: option
    character(len=19) :: lchin(5), lchout(1)
    integer :: nbchin, nfiss
!
! --------------------------------------------------------------------------------------------------
!
    lpain(1)  = 'PGEOMER'
    lchin(1)  = chgeom
    nbchin    = 1
!   si le modele comporte des elements X-FEM, on ajoute les
!   champs ad hoc
    call dismoi('NOM_MODELE', ligrel, 'LIGREL', repk=mo)
    call dismoi('NB_FISS_XFEM', mo, 'MODELE', repi=nfiss)
    if (nfiss.gt.0) then
         lpain(2) = 'PPINTTO'
         lchin(2) = mo(1:8)//'.TOPOSE.PIN'
         lpain(3) = 'PPMILTO'
         lchin(3) = mo(1:8)//'.TOPOSE.PMI'
         lpain(4) = 'PCNSETO'
         lchin(4) = mo(1:8)//'.TOPOSE.CNS'
         lpain(5) = 'PLONCHA'
         lchin(5) = mo(1:8)//'.TOPOSE.LON'
         nbchin   = 5
    endif
!
    lpaout(1) = 'PCOORPG'
    lchout(1) = chgaus
    option    = 'COOR_ELGA'
 
    call calcul('S', option, ligrel, nbchin, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
!
end subroutine
