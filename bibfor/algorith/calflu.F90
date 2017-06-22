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

subroutine calflu(chamno, modele, mate, nu, vectas,&
                  nd, nr, nv, opt)
    implicit none
#include "asterfort/assvec.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/vectfl.h"
    integer :: nr, nd, nv
    character(len=*) :: chamno, modele, mate, nu, vectas, opt
!
!------- CALCUL DES VECTEURS ASSEMBLES DE FLUX FLUIDES
!
!----------------------------------------------------------------------
!  IN  : K19 : CHAMNO : CHAMP AUX NOEUDS DE DEPL_R
!  IN  : K1  : OPT    : CARACTERE RELATIF A L OPTION CHOISIE
!  IN  : K8  : MODELE : MODELE FLUIDE
!  IN  : K24 : MATE   : MATERIAU THERMIQUE (PRIS POUR LE FLUIDE)
!  IN  : K14 : NU     : NUMEROTATION DES DDLS FLUIDES
!  OUT : K19 : VECTAS : CHAMNO DE FLUX FLUIDE
!  OUT : I   : ND,NR,NV : LONGUEURS DES .DESC, .REFE, .VALE
!------------------------------------------------------------------
    real(kind=8) :: r8bid
    character(len=24) :: ve
!------------------------------------------------------------------
!
!     --- CALCUL DU VECTEUR ELEMENTAIRE DE FLUX ---
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    ve ='&&CALFLU.VE'
    call vectfl(opt, modele, ' ', mate, chamno(1:19),&
                r8bid, ve)
!
!     --- ASSEMBLAGE DU VECTEUR ELEMENTAIRE DE FLUX SUR LA
!                       NUMEROTATION NU DU MODELE THERMIQUE ---
!
    call assvec('V', vectas, 1, ve(1:19), [1.d0],&
                nu, ' ', 'ZERO', 1)
    call jedetr(ve)
!
    call jelira(vectas(1:19)//'.DESC', 'LONMAX', nd)
    call jelira(vectas(1:19)//'.REFE', 'LONMAX', nr)
    call jelira(vectas(1:19)//'.VALE', 'LONMAX', nv)
!
end subroutine
