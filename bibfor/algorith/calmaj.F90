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

subroutine calmaj(option, max, may, maz, model,&
                  vesto, modmec, chamno, num, vrai,&
                  i, j, mij)
    implicit none
!
!ROUTINE STOCKANT LE VECTEUR PRESSION ISSUE D UNE RESOLUTION DE LAPLACE
! IN : VECSOL : VECTEUR SOLUTION K*
! OUT : VESTO : VECTEUR STOCKE K*
!---------------------------------------------------------------------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/calcin.h"
#include "asterfort/ploint.h"
    aster_logical :: vrai
    integer :: i, j
    character(len=*) :: modmec, chamno, model
    character(len=9) :: option
    character(len=14) :: num
    character(len=19) :: modx, mody, modz, veprj, vesto, may, max, maz
    real(kind=8) :: mij
! ---------------------------------------------------------------
!
!--------- CALCUL DE LA MASSE AJOUTEE POUR UN FLUIDE-------------
!-------------------N AYANT PAS FORCEMENT------------------------
!-----------------LA MEME DENSITE PARTOUT------------------------
!
!-----------PLONGEMENT DE LA PRESSION ET DES CHAMPS DE DEPL_R----
!---------------SUR LE MODELE THERMIQUE D INTERFACE--------------
!
    call ploint(vesto, modmec, chamno, num, i,&
                vrai, model, veprj, modx, mody,&
                modz)
!
!-------------------CALCUL DE LA MASSE AJOUTEE-------------------
!---------------SUR LE MODELE THERMIQUE D INTERFACE--------------
!
    call calcin(option, max, may, maz, model,&
                veprj, modx, mody, modz, i,&
                j, mij)
!
!
end subroutine
