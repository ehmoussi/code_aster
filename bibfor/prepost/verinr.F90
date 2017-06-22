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

function verinr(nbval, tbins1, tbins2)
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    aster_logical :: verinr
    integer :: nbval
    character(len=19) :: tbins1, tbins2
! --- BUT : VERIFICATION QUE LES LISTES D'INSTANTS DES CHAMPS ----------
! ------- : MECANIQUES SONT IDENTIQUES ---------------------------------
! ======================================================================
! IN  : NBVAL  : DIMENSION DE LA LISTE D'INSTANT -----------------------
! --- : TBINS1 : TABLE 1 -----------------------------------------------
! --- : TBINS2 : TABLE 2 -----------------------------------------------
! OUT : VERINR : FALSE SI LES LISTES SONT IDENTIQUES -------------------
! ------------ : TRUE  SI LES LISTES SONT DIFFERENTES ------------------
! ======================================================================
! ======================================================================
    integer :: ii, jtbini, jtbin1, jtbin2
    real(kind=8) :: somme
    character(len=19) :: vecins
! ======================================================================
    vecins = '&&VERINR.VECINS'
    call wkvect(vecins, 'V V R', nbval, jtbini)
    call jeveuo(tbins1, 'L', jtbin1)
    call jeveuo(tbins2, 'L', jtbin2)
! ======================================================================
! --- CALCUL DE LA NORME -----------------------------------------------
! ======================================================================
    somme = 0.0d0
    verinr = .false.
    do 10 ii = 1, nbval
        zr(jtbini-1+ii) = zr(jtbin1-1+ii) - zr(jtbin2-1+ii)
        somme = somme + zr(jtbini-1+ii)
 10 end do
    if (somme .gt. 0.0d0) verinr = .true.
! ======================================================================
! --- DESTRUCTION DE VECTEURS INUTILES ---------------------------------
! ======================================================================
    call jedetr(vecins)
! ======================================================================
end function
