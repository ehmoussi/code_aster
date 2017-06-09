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

subroutine lkvarv(vintr, nbmat, mater, paravi)
!
    implicit      none
    integer :: nbmat
    real(kind=8) :: paravi(3), mater(nbmat, 2)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE---------------------------
! ==================================================================
! --- BUT : CALCUL DES FONCTIONS D'ECROUISSAGE VISQUEUSE------------
! ==================================================================
! IN  : VINTR    : VARIABLE INTERNE (ICI XIV) ----------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES DU MODELE --------------------
! --- : MATER  : PARAMETRES DU MODELE ------------------------------
! OUT : PARAVI : VARIABLE D'ECROUISSAGE ----------------------------
! ------------ : AXIV, SXIV, MXIV ----------------------------------
! ==================================================================
    real(kind=8) :: m0, a0, s0, avmax, mvmax, svmax, xivmax
    real(kind=8) :: sxiv, axiv, mxiv, xiv
    real(kind=8) :: fact1, vintr
! ==================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE -------------------------
! ==================================================================
    a0 = mater( 8,2)
    s0 = mater(11,2)
    m0 = mater(12,2)
!
!
! ==================================================================
! --- ON IMPOSE A0=1 CAR POUR LA LOI LETK ON MODIFIE LES CRITERES --
! --- VISQUEUX POUR AVOIR UNE DROITE
! ==================================================================
    avmax = 1.d0
    mvmax = mater(19,2)
    svmax = s0
!
    xivmax = mater(20,2)
! ==================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS XIV < XIVMAX------
! ==================================================================
    xiv = vintr
    if (xiv .lt. xivmax) then
!
        fact1 = xiv/xivmax
!
        axiv = a0 + (avmax - a0)*fact1
!
        sxiv = s0 + (svmax - s0)*fact1
!
        mxiv = m0 + (mvmax - m0)*fact1
! ==================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS XIV >= XIVMAX   --
! ==================================================================
    else
        axiv = avmax
!
        sxiv = svmax
!
        mxiv = mvmax
! ==================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS XIE< XIP < XIULT--
! ==================================================================
    endif
! ==================================================================
! --- STOCKAGE -----------------------------------------------------
! ==================================================================
    paravi(1) = axiv
    paravi(2) = sxiv
    paravi(3) = mxiv
! ==================================================================
end subroutine
