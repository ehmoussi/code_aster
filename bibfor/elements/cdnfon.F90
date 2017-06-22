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

subroutine cdnfon(zimat, kfonc, xx, dn, fxx,&
                  ier)
!
    implicit none
!
!     OBTENTION DE LA VALEUR FXX D'UN "ELEMENT" D'UNE RELATION DE
!     COMPORTEMENT D'UN MATERIAU DONNE
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  KFONC : NOM DES RESULTATS (EX: FMEX1,... )
! IN  XX : VALEURS DES PARAMETRES
! IN  DN : CODE
!
! OUT FXX : VALEURS DES RESULTATS APRES RECUPERATION ET INTERPOLATION
! OUT IER : CODE RETOUR
!
#include "asterfort/rcvalb.h"
    integer :: dn, ier, zimat, kpg, spt
!
    real(kind=8) :: xx, fxx, val(1)
!
    integer :: codres(1)
    character(len=8) :: kfonc, kaux, fami, poum
    character(len=16) :: phenom
!
    phenom = 'GLRC_DAMAGE'
    ier = 0
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    if (dn .eq. 0) then
        call rcvalb(fami, kpg, spt, poum, zimat,&
                    ' ', phenom, 1, 'X ', [xx],&
                    1, kfonc, val, codres, 0)
    else if (dn .eq. 1) then
        write (kaux,'(A1,A7)') 'D',kfonc(1:7)
        call rcvalb(fami, kpg, spt, poum, zimat,&
                    ' ', phenom, 1, 'X ', [xx],&
                    1, kaux, val, codres, 0)
    else if (dn .eq. 2) then
        write (kaux,'(A2,A6)') 'DD',kfonc(1:6)
        call rcvalb(fami, kpg, spt, poum, zimat,&
                    ' ', phenom, 1, 'X ', [xx],&
                    1, kaux, val, codres, 0)
    else
        ier = 3
    endif
!
    if (codres(1) .ne. 0) then
        fxx = 0.d0
        ier = 2
    else
        fxx=val(1)    
    endif
!
end subroutine
